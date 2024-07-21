import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key}); //생성자

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
        centerTitle: true,
        title: Text(
          "KNU & coop_studyroom reservation",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "학번",
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "생년월일",
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: () {},
                child: Text('로그인'),
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('회원가입'),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('비밀번호 찾기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
