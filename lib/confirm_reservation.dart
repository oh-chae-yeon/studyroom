import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Confirmreservation extends StatelessWidget {
  const Confirmreservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0), //배경 red
        centerTitle: true, //가운데 정렬
        title: const Text(
          //제목
          "예약현왕",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '스터디룸1',
            ),
            const Text(
              '예약위치: 복지관 스터디룸 A',
            ),
            const Text(
              '예약일시 2024-07-10',
            ),
            const Text(
              '상태 예약됨',
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('예약취소하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
