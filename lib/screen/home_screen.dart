import 'package:flutter/material.dart';
import 'package:schedule_mate/component/calendar.dart';
import 'package:schedule_mate/component/schedule_card.dart';
import 'package:schedule_mate/const/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    const TextStyle bannerTextStyle = TextStyle(
        color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
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
                    '3개',
                    style: bannerTextStyle,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            // ReorderableListView.builder
            ScheduleCard(isChecked: isChecked, onChanged: onChanged,)
          ],
        ),
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }

  void onChanged(bool? newValue) {
    setState(() {
      isChecked = newValue ?? false; // newValue가 null이면 기본값 false를 사용
    // 만약에 isCheck가 true면 리스트를 맨아래로 보내기
    });
  }
}
