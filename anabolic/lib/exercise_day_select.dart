// diary.dart
import 'package:anabolic/exercise.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Todo
// 1. 달력 날짜를 클릭하면 해당 날짜에 이벤트를 추가할 수 있어야 함.

class ExerciseDaySelector extends StatefulWidget {
  const ExerciseDaySelector({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<ExerciseDaySelector> {
  DateTime _selectedDate = DateTime.now(); // 사용자가 달력에서 선택한 날짜를 나타냄
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('운동 기록'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 텍스트를 중앙에 정렬
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "운동을 시작해볼까요?\n기록할 날짜를 선택하세요.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TableCalendar(
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                locale: 'ko_KR',
                selectedDayPredicate: (date) => isSameDay(date, _selectedDate),
                // 달력의 날짜를 클릭하면 onDaySelected 콜백이 호출되어
                // _selectedDate와 _focusedDay를 업데이트한다.
                // _selectedDate 값을 다른 페이지로 이동시켜야 함.
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                daysOfWeekHeight: 20,
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
                }, selectedBuilder: (context, date, _) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Text(
                '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
                style: const TextStyle(
                    fontSize: 26,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 30),
              ExerciseStartButton(selectedDate: _selectedDate)
            ],
          ),
        ));
  }
}

class ExerciseStartButton extends StatelessWidget {
  final DateTime selectedDate; // 여기에 selectedDate 변수 추가

  const ExerciseStartButton({Key? key, required this.selectedDate})
      : super(key: key); // constructor에서 selectedDate를 받는다.

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              // ExercizeList 클래스에 selectedDate를 전달함.
              MaterialPageRoute(
                  builder: (context) => ExerciseList(
                        selectedDate: selectedDate,
                      )));
        },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(200, 50)),
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow),
            SizedBox(
              width: 10,
            ),
            Text('시작하기'),
          ],
        ));
  }
}
