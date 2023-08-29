import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../database/drift_database.dart';
import 'customButton.dart';

class ControlBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final int scheduleId;
  final VoidCallback onPressedEdit;

  const ControlBottomSheet({
    required this.selectedDate,
    required this.scheduleId,
    required this.onPressedEdit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomElevatedButton(
              onPressed: () async{
                onPressedEdit();
              },
              buttonText: '수정하기',
            ),
            const SizedBox(
              width: 20.0,
            ),
            CustomElevatedButton(
              onPressed: () async{
                await GetIt.I<LocalDatabase>().removeSchedule(scheduleId);
                Navigator.pop(context);
              },
              buttonText: '삭제하기',
            ),
          ],
        ),
      ),
    );
  }
}
