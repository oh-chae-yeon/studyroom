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
          '상세 예약',
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
            const Text(
              '입실 : 여동호(미확인)\n      안영주(미확인)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 예약 취소 버튼 클릭 시 동작 추가
                },
                child: const Text('예약취소'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
