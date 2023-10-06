// diary.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'database.dart';
import 'package:collection/collection.dart';
import 'exercise_detail_view.dart';

class ExerciseCalendar extends StatefulWidget {
  const ExerciseCalendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<ExerciseCalendar> {
  DateTime _selectedDate = DateTime.now(); // 사용자가 달력에서 선택한 날짜를 나타냄
  DateTime _focusedDay = DateTime.now();

  // 운동 기록을 저장할 상태 변수
  List<Map<String, dynamic>> completedExercises = [];

  void updateCalendar() {
    fetchCompletedExercises().then((records) {
      setState(() {
        completedExercises = records;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // 비동기 메서드를 호출하여 운동 기록을 불러옴
    fetchCompletedExercises().then((records) {
      setState(() {
        // 상태 변수에 불러온 운동 기록을 저장
        completedExercises = records;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateCalendar();
  }

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
                "기록을 확인할\n날짜를 선택해주세요.",
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
                eventLoader: (day) {
                  // 해당 날짜에 대한 운동 기록을 찾아봄
                  var exerciseRecord = completedExercises.firstWhereOrNull(
                    (record) => isSameDay(DateTime.parse(record['date']), day),
                  );
                  if (exerciseRecord != null) {
                    return [exerciseRecord]; // 이 배열의 길이가 마커의 개수를 결정.
                  }
                  return [];
                },
                focusedDay: _focusedDay,
                locale: 'ko_KR',
                selectedDayPredicate: (date) => isSameDay(date, _selectedDate),
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
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
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
                  },
                  defaultBuilder: (context, date, _) {
                    if (date.weekday == 7) {
                      return Center(
                          child: Text(
                        date.day.toString(),
                        style: const TextStyle(color: Colors.red),
                      ));
                    }
                    return Center(child: Text(date.day.toString()));
                  },
                  selectedBuilder: (context, date, _) {
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
                  },
                  markerBuilder: (context, date, events) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: events.isNotEmpty ? Colors.blue[500] : null),
                      child: events.isNotEmpty
                          ? const Icon(
                              Icons.fitness_center, // 체크 아이콘
                              color: Colors.white,
                            )
                          : Text(
                              date.day.toString(),
                              style: const TextStyle()
                                  .copyWith(color: Colors.black),
                            ),
                    );
                  },
                ),
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
              ExerciseSearchButton(selectedDate: _selectedDate)
            ],
          ),
        ));
  }
}

class ExerciseSearchButton extends StatelessWidget {
  final DateTime selectedDate; // 여기에 selectedDate 변수 추가

  const ExerciseSearchButton({Key? key, required this.selectedDate})
      : super(key: key); // constructor에서 selectedDate를 받는다.

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              // ExerciseDetailView 클래스에 selectedDate를 전달함.
              MaterialPageRoute(
                  builder: (context) => ExerciseDetailView(
                        selectedDate: selectedDate,
                      )));
          if (result == 'update') {
            // StatefulWidget의 상태를 업데이트하는 방법을 찾아야 합니다.
          }
        },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(200, 50)),
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('확인'),
          ],
        ));
  }
}
