import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:project_studyroom/providers/login_provider.dart';
import 'package:project_studyroom/providers/reserv_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_studyroom/studyroomstructure.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? selectedDay;
  Map<String, List<bool>> reservationData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ReservationProvider>(context, listen: false).initializeReservationData();
    });
  }

  Future<void> _fetchReservationData() async {
    if (selectedDay == null) return;
    
    setState(() {
      isLoading = true;
    });
    Map<String, List<bool>> data = await Provider.of<ReservationProvider>(context, listen: false)
        .fetchReservationData(DateFormat('yyyy-MM-dd').format(selectedDay!));
    setState(() {
      reservationData = data;
      isLoading = false;
    });
  }

  List<String> getNextSevenWeekdays() {
    DateTime now = DateTime.now();
    List<DateTime> weekdays = [];
    while (weekdays.length < 7) {
      now = now.add(Duration(days: 1));
      if (now.weekday != DateTime.saturday && now.weekday != DateTime.sunday) {
        weekdays.add(now);
      }
    }
    return weekdays.map((date) => DateFormat('yyyy-MM-dd').format(date)).toList();
  }

  Future<void> _showTimeSelectionDialog(
      BuildContext context, Function(int, int) onTimeSelected) async {
    int _selectedStartTime = 9; // 시작 시간
    int _selectedDuration = 1; // 학습 시간

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('시간 선택'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text('시작시간:'),
                      SizedBox(width: 10),
                      DropdownButton<int>(
                        value: _selectedStartTime,
                        items: List.generate(10, (index) {
                          return DropdownMenuItem<int>(
                            value: index + 9,
                            child: Text('${index + 9}시'), // 9시부터 18시까지의 시간 옵션
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedStartTime = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('학습시간:'),
                      SizedBox(width: 10),
                      DropdownButton<int>(
                        value: _selectedDuration,
                        items: List.generate(3, (index) {
                          return DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text('${index + 1}시간'), // 1시간, 2시간, 3시간 옵션
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedDuration = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 취소 버튼 클릭 시 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                onTimeSelected(_selectedStartTime, _selectedDuration);
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> nextSevenWeekdays = getNextSevenWeekdays();
    String selectedDayStr = selectedDay != null ? DateFormat('yyyy-MM-dd').format(selectedDay!) : '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(),
        title: Text('시설물예약'),
        centerTitle: true,
        backgroundColor: Color(0xFF22CC88),
         actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Studyroomstructure(),
                ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],

      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              '예약희망일자',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: DropdownButton<String>(
              value: selectedDayStr.isNotEmpty ? selectedDayStr : null,
              hint: Text('날짜를 선택하세요'),
              items: nextSevenWeekdays.map((String date) {
                return DropdownMenuItem<String>(
                  value: date,
                  child: Text(
                    date,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) async {
                if (newValue != null) {
                  setState(() {
                    selectedDay = DateFormat('yyyy-MM-dd').parse(newValue);
                  });
                  await _fetchReservationData();
                }
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: selectedDay == null
                ? Center(child: Text('날짜를 선택하세요'))
                : isLoading
                    ? Center(child: CircularProgressIndicator())
                    : reservationData.isEmpty
                        ? Center(child: Text('No data available'))
                        : ListView(
                            children: reservationData.entries.map((entry) {
                              String roomName = entry.key;
                              List<bool> availability = entry.value;
                              return StudyRoomItem(
                                roomName: roomName,
                                capacity: '3명 ~ 8명',
                                availability: availability,
                                selectedDay: selectedDay!,
                                onSelect: (int startTime, int duration) async {
                                  try {
                                    await Provider.of<ReservationProvider>(context, listen: false)
                                        .handleReservation(
                                      DateFormat('yyyy-MM-dd').format(selectedDay!),
                                      roomName,
                                      startTime,
                                      duration,
                                      Provider.of<LoginProvider>(context, listen: false).user!,
                                    );

                                    // 예약 성공 시 알림 표시
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('예약이 완료되었습니다.'),
                                        ),
                                      );
                                    }
                                    await _fetchReservationData();
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('예약 불가'),
                                          content: Text(e.toString()),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('확인'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                onCancel: (int timeIndex) async {
                                  try {
                                    // 예약 취소 처리
                                    User user = Provider.of<LoginProvider>(context, listen: false).user!;
                                    List<Map<String, dynamic>> userReservations =
                                        await Provider.of<ReservationProvider>(context, listen: false)
                                            .fetchUserReservations(user);
                                    Map<String, dynamic>? reservationToCancel;

                                    for (var reservation in userReservations) {
                                      if (reservation['date'] ==
                                              DateFormat('yyyy-MM-dd').format(selectedDay!) &&
                                          reservation['room'] == roomName &&
                                          reservation['startTime'] == timeIndex) {
                                        reservationToCancel = reservation;
                                        break;
                                      }
                                    }

                                    if (reservationToCancel != null) {
                                      await Provider.of<ReservationProvider>(context, listen: false)
                                          .cancelReservation(
                                        reservationToCancel['id'],
                                        DateFormat('yyyy-MM-dd').format(selectedDay!),
                                        roomName,
                                        timeIndex - 9,
                                      );

                                      // 예약 취소 성공 시 알림 표시
                                      if (mounted) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('예약이 취소되었습니다.'),
                                            ),
                                          );
                                        });
                                      }
                                      await _fetchReservationData();
                                    } else {
                                      throw Exception('예약을 찾을 수 없습니다.');
                                    }
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('예약 취소 불가'),
                                          content: Text(e.toString()),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('확인'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              );
                            }).toList(),
                          ),
          ),
        ],
      ),
    );
  }
}


class StudyRoomItem extends StatefulWidget {
  final String roomName;
  final String capacity;
  final List<bool> availability;
  final DateTime selectedDay;
  final Function(int, int) onSelect;
  final Function(int) onCancel;

  StudyRoomItem({
    required this.roomName,
    required this.capacity,
    required this.availability,
    required this.selectedDay,
    required this.onSelect,
    required this.onCancel,
  });

  @override
  _StudyRoomItemState createState() => _StudyRoomItemState();
}

class _StudyRoomItemState extends State<StudyRoomItem> {
  void _showTimeSelectionDialog(BuildContext context, Function(int, int) onTimeSelected) async {
    int _selectedStartTime = 9; // 시작 시간
    int _selectedDuration = 1; // 학습 시간

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('시간 선택'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text('시작시간:'),
                      SizedBox(width: 10),
                      DropdownButton<int>(
                        value: _selectedStartTime,
                        items: List.generate(10, (index) {
                          return DropdownMenuItem<int>(
                            value: index + 9,
                            child: Text('${index + 9}시'), // 9시부터 18시까지의 시간 옵션
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedStartTime = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('학습시간:'),
                      SizedBox(width: 10),
                      DropdownButton<int>(
                        value: _selectedDuration,
                        items: List.generate(3, (index) {
                          return DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text('${index + 1}시간'), // 1시간, 2시간, 3시간 옵션
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedDuration = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 취소 버튼 클릭 시 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                onTimeSelected(_selectedStartTime, _selectedDuration);
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.roomName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('수용인원: ${widget.capacity}'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(9, (index) {
                bool isPastTime = now.isSameDay(widget.selectedDay) && (index + 9) <= currentHour;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!isPastTime && widget.availability[index]) {
                          _showTimeSelectionDialog(context, (int startTime, int duration) {
                            widget.onSelect(startTime, duration);
                          });
                        }
                      },
                      onLongPress: () {
                        if (!isPastTime && !widget.availability[index]) {
                          widget.onCancel(index + 9);
                        }
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        color: isPastTime
                            ? Colors.grey
                            : (widget.availability[index] ? Colors.blue : Colors.grey),
                        margin: EdgeInsets.symmetric(horizontal: 2),
                      ),
                    ),
                    Text('${index + 9}', style: TextStyle(fontSize: 12)), // 시간 텍스트 추가
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

extension DateTimeExtensions on DateTime {
  bool isSameDay(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}
