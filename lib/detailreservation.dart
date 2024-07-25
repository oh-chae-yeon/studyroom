import 'package:flutter/material.dart';

class Detailreservation extends StatelessWidget {
  const Detailreservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0), //배경 red
        centerTitle: true,
        title: const Text(
          '나의 예약',
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '공간명 : 복지관 1F 스터디룸 1',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '용도 : 학습',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '동반이용자 : 안영주(2020114132) 1명',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '신청일시 : 2024-07-09 18:28:54',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '예약일시 : 2024-07-10 / 12:00~15:00',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '상태 : 예약됨',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('여동호(미확인)'),
                Text('안영주(미확인)'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('입실확인'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showCancelDialog(context);
                  },
                  child: const Text('예약취소'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showCancelDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('예약 취소'),
        content: const Text('정말로 예약을 취소하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              // 예약 취소 로직 추가
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('예약이 취소되었습니다.'),
                ),
              );
            },
            child: const Text('예'),
          ),
        ],
      );
    },
  );
}
