import 'package:flutter/material.dart';
import 'package:schedule_mate/const/color.dart';

class ScheduleCard extends StatelessWidget {
  final bool isChecked;
  final Function(bool?)? onChanged;

  ScheduleCard({
    required this.isChecked,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 25.0, 0.0),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: PRIMARY_COLOR,
            side: BorderSide(
              color: PRIMARY_COLOR,
            ),
          ),
          Expanded(
            child: TextField(
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
                // 포커스 되면 키보드 올리기
              ),
            ),
          ),
        ],
      ),
    );
  }
}
