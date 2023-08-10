import 'package:flutter/material.dart';
import 'package:schedule_mate/const/color.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final OnDaySelected? onDaySelected;

  const Calendar({
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoxDecoration defaultBoxStyle = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(17.0),
    );

    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime(2010),
      lastDay: DateTime(2123),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: PRIMARY_COLOR,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: PRIMARY_COLOR,
        ),
      ),
      daysOfWeekHeight: 20.0,
      calendarStyle: CalendarStyle(
        tablePadding: EdgeInsets.symmetric(horizontal: 8.0),
        isTodayHighlighted: false,
        defaultDecoration: defaultBoxStyle,
        weekendDecoration: defaultBoxStyle,
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(17.0),
        ),
        selectedTextStyle: TextStyle(
          color: PRIMARY_COLOR,
          fontWeight: FontWeight.w500,
        ),
        outsideDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
      ),
      onDaySelected: onDaySelected,
      selectedDayPredicate: (DateTime Date) {
        return Date.year == selectedDay.year &&
            Date.month == selectedDay.month &&
            Date.day == selectedDay.day;
      },
    );
  }
}
