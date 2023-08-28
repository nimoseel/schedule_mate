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

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    isCreate = false;
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
              _ScheduleList(
                selectedDate: selectedDay,
                isCreate: isCreate,
                updateIsCreate: updateIsCreate,
                scrollController: _scrollController,
              ),
            ],
          ),
        ),
        floatingActionButton: renderFloatingActionButton(),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: PRIMARY_COLOR,
      splashColor: PRIMARY_COLOR[600],
      child: Icon(Icons.add),
      onPressed: () {
        setState(() {
          isCreate = true;
        });
      },
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
      isCreate = false;
    });
  }

  void updateIsCreate(bool value) {
    setState(() {
      isCreate = value;
    });
  }
}

// 스케줄 리스트 위젯
class _ScheduleList extends StatelessWidget {
  final DateTime selectedDate;
  final bool isCreate;
  final Function(bool) updateIsCreate;
  final ScrollController scrollController;

  const _ScheduleList({
    required this.selectedDate,
    required this.isCreate,
    required this.updateIsCreate,
    required this.scrollController,
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

          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Scrollbar(
              controller: scrollController,
              child: ListView.builder(
                controller: scrollController,
                itemCount: snapshot.data!.length + (isCreate ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isCreate && index == snapshot.data!.length) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      scrollController
                          .jumpTo(scrollController.position.maxScrollExtent);
                    });
                    return ScheduleCard(
                      selectedDate: selectedDate,
                      isChecked: false,
                      onScheduleAdded: updateIsCreate,
                    );
                  }
                  final schedule = snapshot.data![index];

                  return ScheduleCard(
                    key: ValueKey(schedule.id),
                    selectedDate: schedule.date,
                    isChecked: schedule.done,
                    content: schedule.content,
                    scheduleId: schedule.id,
                    onScheduleAdded: updateIsCreate,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
