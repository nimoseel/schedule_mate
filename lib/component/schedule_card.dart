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

  final TextEditingController _textEditingController = TextEditingController();

  bool _isChecked = false;
  String? _content;
  bool editable = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
    _content = widget.content;
    editable = _content == null;

    _textEditingController.text = widget.content ?? '';
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
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
                  side: const BorderSide(
                    color: PRIMARY_COLOR,
                  ),
                ),
                Form(
                  key: formKey,
                  child: Expanded(
                    child: renderTextFormField(),
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
                padding: const EdgeInsets.only(right: 5.0),
              ),
              child: const Icon(
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
    _textEditingController.dispose();
    super.dispose();
  }

  TextFormField renderTextFormField() {
    return TextFormField(
      controller: _textEditingController,
      focusNode: _focusNode,
      enabled: editable,
      autofocus: editable,
      autocorrect: false,
      maxLength: 20,
      textInputAction: TextInputAction.done,
      onSaved: (String? val) {
        if (val != null) {
          String trimmedVal = val.replaceAll(RegExp(r'\s+'), '');
          if (trimmedVal.isNotEmpty) {
            _content = val;
          } else {
            _content = null;
          }
        }
      },
      cursorColor: PRIMARY_COLOR,
      cursorWidth: 1.0,
      cursorHeight: 20.0,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        iconColor: PRIMARY_COLOR,
        border: InputBorder.none,
        hintText: '최대 20글자 입력 가능',
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }

  // checkbox onChange시 실행되는 함수
  void _onChanged(bool? newValue) async {
    setState(() {
      _isChecked = newValue ?? false;
    });

    await GetIt.I<LocalDatabase>().updateScheduleById(
      widget.scheduleId!,
      SchedulesCompanion(
        done: Value(_isChecked),
        content: Value(_content!),
        date: Value(widget.selectedDate),
      ),
    );
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _handleSubmitted();
    }
  }

  void _handleSubmitted() async {
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
            done: const Value(false),
            content: Value(_content!),
            date: Value(widget.selectedDate),
          ),
        );
        widget.onScheduleAdded(false);
      } else {
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
    } else {
      if (widget.scheduleId != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "스케줄을 삭제하시겠습니까?",
                style: TextStyle(fontSize: 18.0),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: PRIMARY_COLOR,
                  ),
                  onPressed: () {
                    setState(() {
                      _textEditingController.text = widget.content!;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "취소",
                    style: TextStyle(color: PRIMARY_COLOR),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: PRIMARY_COLOR,
                  ),
                  onPressed: () async {
                    await GetIt.I<LocalDatabase>()
                        .removeSchedule(widget.scheduleId!);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "확인",
                    style: TextStyle(color: PRIMARY_COLOR),
                  ),
                ),
              ],
            );
          },
        );
      }
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }
}
