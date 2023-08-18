import 'package:flutter/material.dart';
import 'package:schedule_mate/component/calendar.dart';
import 'package:schedule_mate/component/count_banner.dart';
import 'package:schedule_mate/component/schedule_card.dart';
import 'package:schedule_mate/const/color.dart';
import 'package:schedule_mate/database/drift_database.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  bool isCreate = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
              CountBanner(
                selectedDay: selectedDay,
              ),
              SizedBox(
                height: 15.0,
              ),
              isCreate
                  ? ScheduleCard(
                    selectedDate: selectedDay,
                    isChecked: false,
                  )
                  : Container(),
              _ScheduleList(
                selectedDate: selectedDay,
                isCreate: isCreate,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: PRIMARY_COLOR,
          splashColor: PRIMARY_COLOR[600],
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              isCreate = true;
            });
          },
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
}

class _ScheduleList extends StatelessWidget {
  final DateTime selectedDate;
  final bool isCreate;

  const _ScheduleList({
    required this.selectedDate,
    required this.isCreate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Schedule>>(
          stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData && snapshot.data!.isEmpty && !isCreate) {
              return Center(
                child: Text('스케줄이 없습니다.'),
              );
            }

            return ListView.builder(
              // ReorderableListView.builder
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // print(snapshot.data);
                final schedule = snapshot.data![index];

                return ScheduleCard(
                  selectedDate: schedule.date,
                  isChecked: schedule.done,
                  content: schedule.content,
                  scheduleId: schedule.id,
                );
              },
            );
          }),
    );
  }
}
