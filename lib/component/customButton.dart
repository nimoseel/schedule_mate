import 'package:flutter/material.dart';
import '../const/color.dart';

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
          foregroundColor: PRIMARY_COLOR[200],
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