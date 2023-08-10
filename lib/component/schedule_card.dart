import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final bool isChecked;
  final Function(bool?)? onChanged;

  ScheduleCard({
    required this.isChecked,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 5.0,
      ),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
          ),
          Expanded(
            child: Text(
              '내용은 최대 2줄까지만 입력할 수 있습니다.',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
