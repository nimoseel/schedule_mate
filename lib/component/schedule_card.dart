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

  const ScheduleCard({
    required this.selectedDate,
    required this.isChecked,
    this.content,
    this.scheduleId,
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  final GlobalKey<FormState> formKey = GlobalKey();

  bool _isChecked = false;
  String? _content;
  int? _scheduleId;

  @override
  void initState(){
    super.initState();
    _isChecked = widget.isChecked;
    _content = widget.content;
    _scheduleId = widget.scheduleId;
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
                _content == null
                    ? Form(
                        key: formKey,
                        child: Expanded(
                          child: TextFormField(
                            onSaved: (String? val) {
                              _content = val;
                            },
                            validator: (String? val) {
                              if (val == null || val.isEmpty) {
                                return '값을 입력해주세요';
                              }
                              return null;
                            },
                            autofocus: true,
                            cursorColor: PRIMARY_COLOR,
                            cursorWidth: 1.0,
                            cursorHeight: 20.0,
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
                    : GestureDetector(
                        onTap: () {
                          _showBottomSheet();
                        },
                        child: Text(_content!),
                      ),
              ],
            ),
          ),
          SizedBox(
            width: 45.0,
            child: ElevatedButton(
              onPressed: () {
                print('더보기 버튼 클릭');
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

  void _onChanged(bool? newValue) {
    setState(() {
      _isChecked = newValue ?? false; // newValue가 null이면 기본값 false를 사용

      GetIt.I<LocalDatabase>().updateScheduleById(
        _scheduleId!,
        SchedulesCompanion(
          done: Value(_isChecked),
          content: Value(_content!),
          date: Value(widget.selectedDate),
        ),
      );
      // 만약에 isCheck가 true면 리스트를 맨아래로 보내기
    });
  }

  onFieldSubmitted(String? value) async {
    if (formKey.currentState == null) {
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final key = await GetIt.I<LocalDatabase>().createSchedule(
        SchedulesCompanion(
          done: Value(false),
          content: Value(_content!),
          date: Value(widget.selectedDate),
        ),
      );
      print('save완료 $key');
    } else {
      print('에러있음');
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ControlBottomSheet(
          selectedDate: widget.selectedDate,
          scheduleId: _scheduleId!,
        );
      },
    );
  }
}
