import 'package:flutter/material.dart';
import '../const/color.dart';

class CountBanner extends StatelessWidget {
  final DateTime selectedDay;
  final int count;

  const CountBanner({
    required this.selectedDay,
    required this.count,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle bannerTextStyle = TextStyle(
        color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
      color: PRIMARY_COLOR,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일',
            style: bannerTextStyle,
          ),
          Text(
            '$count개',
            style: bannerTextStyle,
          ),
        ],
      ),
    );
  }
}
