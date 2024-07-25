import 'package:flutter/material.dart';
import 'package:project_studyroom/Homepage.dart';
import 'package:project_studyroom/reservation.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key}); //생성자

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0), //배경 red
        centerTitle: true, //가운데 정렬
        title: const Text(
          //제목
          "경북대 복지관 스터디룸 예약",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), //여백주기
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: "학번",
              ),
            ),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "생년월일",
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomePage(),
                    ),
                  );
                },
                child: const Text('로그인'),
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('회원가입'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReservationScreen(),
                      ),
                    );
                  },
                  child: const Text('비밀번호 찾기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
