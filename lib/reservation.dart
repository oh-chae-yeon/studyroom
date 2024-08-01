import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:project_studyroom/providers/reserv_provider.dart';
import 'package:project_studyroom/studyroomstructure.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? selectedRoom;
  String? selectedStartTime;
  String? selectedEndTime;
  String? selectedPurpose;

  List<String> rooms = ['스터디룸 1', '스터디룸 2', '스터디룸 3', '스터디룸 4', '스터디룸 5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(),
        backgroundColor: const Color.fromARGB(255, 154, 249, 159),
        centerTitle: true,
        title: const Text(
          '예약',
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
      body: Consumer<ReservationProvider>(
        builder: (context, reservationProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '이용시간: 1일 1회, 최소 30분-최대 3시간\n예약부도 시 (제재 5일)',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdownButton(
                  context,
                  '스터디룸 선택',
                  rooms,
                  selectedRoom,
                  (value) {
                    setState(() {
                      selectedRoom = value;
                    });
                  },
                ),
                _buildDropdownButton(
                  context,
                  '예약희망 시작시간',
                  [
                    '09:00',
                    '10:00',
                    '11:00',
                    '12:00',
                    '13:00',
                    '14:00',
                    '15:00',
                    '16:00',
                    '17:00'
                  ],
                  selectedStartTime,
                  (value) {
                    setState(() {
                      selectedStartTime = value;
                    });
                  },
                ),
                _buildDropdownButton(
                  context,
                  '예약희망 종료시간',
                  [
                    '09:30',
                    '10:00',
                    '10:30',
                    '11:00',
                    '11:30',
                    '12:00',
                    '12:30',
                    '13:00',
                    '13:30',
                    '14:00',
                    '14:30',
                    '15:00',
                    '15:30',
                    '16:00',
                    '16:30',
                    '17:00',
                    '17:30',
                    '18:00'
                  ],
                  selectedEndTime,
                  (value) {
                    setState(() {
                      selectedEndTime = value;
                    });
                  },
                ),
                _buildDropdownButton(
                  context,
                  '용도',
                  ['스터디', '회의', '기타'],
                  selectedPurpose,
                  (value) {
                    setState(() {
                      selectedPurpose = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (selectedRoom != null &&
                        selectedStartTime != null &&
                        selectedEndTime != null &&
                        selectedPurpose != null) {
                      final success = await context
                          .read<ReservationProvider>()
                          .reserveTime(
                            date: _selectedDay.toIso8601String().split('T')[0],
                            startTime: selectedStartTime!,
                            endTime: selectedEndTime!,
                            purpose: selectedPurpose!,
                            room: selectedRoom!,
                          );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('예약이 완료되었습니다.')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('예약.')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('모든 필드를 선택해 주세요.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('예약'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdownButton(
    BuildContext context,
    String hint,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
        ),
        value: selectedValue,
        onChanged: onChanged,
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
      ),
    );
  }
}
