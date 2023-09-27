// diary.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Diary extends StatelessWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('운동 기록'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              locale: 'ko_KR',
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
                switch (day.weekday) {
                  case 1:
                    return const Center(
                      child: Text('월'),
                    );
                  case 2:
                    return const Center(
                      child: Text('화'),
                    );
                  case 3:
                    return const Center(
                      child: Text('수'),
                    );
                  case 4:
                    return const Center(
                      child: Text('목'),
                    );
                  case 5:
                    return const Center(
                      child: Text('금'),
                    );
                  case 6:
                    return const Center(
                      child: Text(
                        '토',
                        style: TextStyle(color: Colors.blue),
                      ),
                    );
                  case 7:
                    return const Center(
                      child: Text(
                        '일',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  default:
                    return const Center(child: Text('Error'));
                }
              }, defaultBuilder: (context, date, _) {
                if (date.weekday == 7) {
                  return Center(
                      child: Text(
                    date.day.toString(),
                    style: const TextStyle(color: Colors.red),
                  ));
                }
                return Center(child: Text(date.day.toString()));
              }),
            )));
  }
}
