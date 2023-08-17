import 'package:flutter/material.dart';
import 'package:schedule_mate/const/color.dart';

class ControlBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final int scheduleId;

  const ControlBottomSheet({
    required this.selectedDate,
    required this.scheduleId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomElevatedButton(
              onPressed: () {
                print('$scheduleId 수정하기');
              },
              buttonText: '수정하기',
            ),
            SizedBox(
              width: 20.0,
            ),
            CustomElevatedButton(
              onPressed: () {
                print('$scheduleId 삭제하기');
              },
              buttonText: '삭제하기',
            ),
          ],
        ),
        color: Colors.white,
      ),
    );
  }
}

// 커스텀 버튼 위젯
class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const CustomElevatedButton({
    required this.onPressed,
    required this.buttonText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          side: BorderSide(
            color: PRIMARY_COLOR,
            width: 1.0,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
