import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

//동적인 상태를 관리하는 위젯을 의미
class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});
//생성자에서 key를 받아 부모 클래스의 생성자에 전달

//
  @override
  // ignore: library_private_types_in_public_api
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedDate;
  String? selectedStartTime;
  String? selectedEndTime;
  String? selectedPurpose;

  List<String>? get times => null;

  List<String>? get purposes => null;

//위젯의 UI를 구성하는 매서드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 0, 0), //배경 red
        centerTitle: true,
        title: const Text(
          '예약',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '사용안내: 4명까지\n이용시간: 1일 1회, 최소 30분-최대 3시간\n예약부도 시 (제재 5일)',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            _buildDropdownButton(
              context,
              '예약희망 일자',
              ['날짜 선택'],
              selectedDate,
              (value) {
                setState(() {
                  selectedDate = value;
                });
              },
            ),
            _buildDropdownButton(
              context,
              '예약희망 시작시간',
              ['시간 선택'],
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
              ['시간 선택'],
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
              ['용도 선택'],
              selectedPurpose,
              (value) {
                setState(() {
                  selectedPurpose = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // 예약 처리 로직 추가
              },
              icon: const Icon(Icons.person_add),
              label: const Text('예약'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
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
