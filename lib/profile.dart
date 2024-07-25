import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0), //배경 red
        centerTitle: true,
        title: const Text(
          '내 정보',
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: const Center(
        child: MemberInfoScreen(),
      ),
    );
  }
}

class MemberInfoScreen extends StatelessWidget {
  const MemberInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '회원 정보',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text('아이디: 2021110283', style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 16.0),
                  Text('예약 정보: 1건', style: TextStyle(fontSize: 16.0)),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('로그아웃'),
                    onTap: () {
                      // 로그아웃 처리
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('로그아웃되었습니다.')),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('회원탈퇴'),
                    onTap: () {
                      // 회원탈퇴 처리
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('회원탈퇴'),
                            content: Text('정말로 회원탈퇴하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // 회원탈퇴 처리
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('회원탈퇴가 완료되었습니다.')),
                                  );
                                },
                                child: Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
