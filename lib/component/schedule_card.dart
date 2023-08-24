import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import 'package:schedule_mate/const/color.dart';
import 'package:schedule_mate/database/drift_database.dart';
import 'ControlBottomSheet.dart';

class ScheduleCard extends StatefulWidget {
  final DateTime selectedDate;
  final bool isChecked;
  final String? content;
  final int? scheduleId;
  final Function(bool) onScheduleAdded;

  const ScheduleCard({
    required this.selectedDate,
    required this.isChecked,
    this.content,
    this.scheduleId,
    required this.onScheduleAdded,
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();

  bool _isChecked = false;
  String? _content;
  bool editable = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
    _content = widget.content;
    editable = _content == null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: _onChanged,
                  activeColor: PRIMARY_COLOR,
                  side: BorderSide(
                    color: PRIMARY_COLOR,
                  ),
                ),
                Form(
                  key: formKey,
                  child: Expanded(
                    child: TextFormField(
                      focusNode: _focusNode,
                      initialValue: _content,
                      enabled: editable,
                      autocorrect: false,
                      onSaved: (String? val) {
                        this._content = val;
                      },
                      validator: (String? val) {
                        if (val == null || val.isEmpty) {
                          return '값을 입력해주세요';
                        }
                        return null;
                      },
                      autofocus: editable,
                      cursorColor: PRIMARY_COLOR,
                      cursorWidth: 1.0,
                      cursorHeight: 20.0,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        iconColor: Colors.pink,
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.pink,
                          ),
                        ),
                      ),
                      onFieldSubmitted: onFieldSubmitted,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 45.0,
            child: ElevatedButton(
              onPressed: () {
                _showBottomSheet();
              },
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.only(right: 5.0),
              ),
              child: Icon(
                Icons.more_vert,
                color: Colors.grey,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // checkbox onChange시 실행되는 함수
  void _onChanged(bool? newValue) {
    setState(
      () {
        _isChecked = newValue ?? false;

        GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            done: Value(_isChecked),
            content: Value(_content!),
            date: Value(widget.selectedDate),
          ),
        );
      },
    );
  }

  // textField 작성 후 done 클릭시 실행되는 함수
  onFieldSubmitted(String? value) async {
    if (formKey.currentState == null) {
      return;
    }

    formKey.currentState!.save();

    // _content가 null이 아닐 때 저장 및 수정 실행
    if (_content != null && _content!.isNotEmpty) {
      // 새로운 스케줄카드 저장시
      if (widget.scheduleId == null) {
        await GetIt.I<LocalDatabase>().createSchedule(
          SchedulesCompanion(
            done: Value(false),
            content: Value(_content!),
            date: Value(widget.selectedDate),
          ),
        );
        widget.onScheduleAdded(false); // homeScreen의 isCreate 상태를 false로 변경
      }
      // 수정하기 실행시
      if (widget.scheduleId != null) {
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            done: Value(_isChecked),
            content: Value(_content!),
            date: Value(widget.selectedDate),
          ),
        );
      }

      setState(() {
        editable = false;
      });

      _focusNode.unfocus();
    }

    // 수정하기에서 _content를 빈값으로 만들었을 경우
    if (widget.scheduleId != null && _content?.isEmpty == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("스케줄 입력"),
            content: Text("스케줄을 삭제하시겠습니까?"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _content = widget.content!;
                  });
                  Navigator.pop(context);
                },
                child: Text("취소"),
              ),
              TextButton(
                onPressed: () async {
                  await GetIt.I<LocalDatabase>()
                      .removeSchedule(widget.scheduleId!);
                  Navigator.pop(context);
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );
    }
  }

  // bottomSheet 보여주는 함수
  void _showBottomSheet() {
    // scheduleId null 체크 조건 추가 -> 새 스케줄카드 create시 오류 문제 해결
    if (widget.scheduleId != null) {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return ControlBottomSheet(
            selectedDate: widget.selectedDate,
            scheduleId: widget.scheduleId!,
            onPressedEdit: onPressedEdit,
          );
        },
      );
    } else {
      return;
    }
  }

  // 수정하기 실행 함수
  void onPressedEdit() {
    Navigator.pop(context);
    setState(() {
      editable = true;
    });
    // _focusNode.requestFocus();
  }
}
