import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:schedule_mate/database/drift_database.dart';
import '../const/color.dart';

class CountBanner extends StatelessWidget {
  final DateTime selectedDay;

  const CountBanner({
    required this.selectedDay,

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
          StreamBuilder<List<Schedule>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDay),
            builder: (context, snapshot) {
              List<Schedule> dataList = snapshot.data!;
              int count = 0;
              int doneCount = 0;

              if(snapshot.hasData){
                count = snapshot.data!.length;
              }

              for(Schedule data in dataList){
                if(data.done == true){
                  doneCount++;
                }
              }

              return Text(
                '${doneCount}/${count}개',
                style: bannerTextStyle,
              );
            }
          ),
        ],
      ),
    );
  }
}
