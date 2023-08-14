import 'package:flutter/material.dart';
import 'package:schedule_mate/const/color.dart';

class ScheduleCard extends StatefulWidget {
  final bool isChecked;
  final Function(bool?)? onChanged;

  ScheduleCard({
    required this.isChecked,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 25.0, 0.0),
      child: Row(
        children: [
          Checkbox(
            value: widget.isChecked,
            onChanged: widget.onChanged,
            activeColor: PRIMARY_COLOR,
            side: BorderSide(
              color: PRIMARY_COLOR,
            ),
          ),
          Form(
            key: formKey,
            child: Expanded(
              child: TextFormField(
                validator: (String? val){
                  if(val == null || val.isEmpty){
                    return '값을 입력해주세요';
                  }
                  return null;
                },
                cursorColor: PRIMARY_COLOR,
                cursorWidth: 1.0,
                cursorHeight: 20.0,
                decoration: InputDecoration(
                  iconColor: Colors.pink,
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.pink,
                    ),
                  ),
                ),
                onFieldSubmitted: (String value) {
                  if(formKey.currentState == null){
                    return;
                  }
                  if(formKey.currentState!.validate()){
                    print('에러없음');
                  }else{
                    print('에러있음');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
