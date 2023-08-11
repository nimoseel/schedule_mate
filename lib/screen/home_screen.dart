import 'package:flutter/material.dart';
import 'package:schedule_mate/component/calendar.dart';
import 'package:schedule_mate/component/count_banner.dart';
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
            CountBanner(selectedDay: selectedDay),
            SizedBox(
              height: 15.0,
            ),
            // ReorderableListView.builder
            _ScheduleList(
              isChecked: isChecked,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        splashColor: PRIMARY_COLOR[600],
        child: Icon(Icons.add),
        onPressed: () {},
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

class _ScheduleList extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const _ScheduleList({
    required this.isChecked,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ScheduleCard(
              isChecked: isChecked,
              onChanged: onChanged,
            );
          },
        ),
      ),
    );
  }
}
