import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import 'package:schedule_mate/const/color.dart';
import 'package:schedule_mate/database/drift_database.dart';

class ScheduleCard extends StatefulWidget {
  final DateTime selectedDate;
  final bool isChecked;
  final String content;
  final int? scheduleId;

  const ScheduleCard({
    required this.selectedDate,
    required this.isChecked,
    required this.content,
    this.scheduleId,
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  final GlobalKey<FormState> formKey = GlobalKey();

  String? content;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 25.0, 0.0),
      child: Row(
        children: [
          Checkbox(
            value: widget.isChecked ? widget.isChecked : _isChecked,
            onChanged: _onChanged,
            activeColor: PRIMARY_COLOR,
            side: BorderSide(
              color: PRIMARY_COLOR,
            ),
          ),
          widget.content.isEmpty
              ? Form(
                  key: formKey,
                  child: Expanded(
                    child: TextFormField(
                      onSaved: (String? val) {
                        content = val;
                      },
                      validator: (String? val) {
                        if (val == null || val.isEmpty) {
                          return '값을 입력해주세요';
                        }
                        return null;
                      },
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
              : Text(widget.content),
        ],
      ),
    );
  }

  void _onChanged(bool? newValue) {
    setState(() {
      _isChecked = newValue ?? false; // newValue가 null이면 기본값 false를 사용

      GetIt.I<LocalDatabase>().updateScheduleById(
        widget.scheduleId!,
        SchedulesCompanion(
          done: Value(_isChecked),
          content: Value(widget.content),
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
          content: Value(content!),
          date: Value(widget.selectedDate),
        ),
      );
      print('save완료 $key');
    } else {
      print('에러있음');
    }
  }
}
