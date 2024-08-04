import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:project_studyroom/Loginpage.dart';
import '../providers/login_provider.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(),
        backgroundColor: Color(0xFF22CC88), // AppBar 색상 설정
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

  Future<Map<String, dynamic>> _getUserData(BuildContext context) async {
    final user = Provider.of<LoginProvider>(context, listen: false).user;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      final reservationsCount = await FirebaseFirestore.instance
          .collection('user_reservations')
          .where('user.uid', isEqualTo: user?.uid)
          .get()
          .then((snapshot) => snapshot.size);
      data['reservationsCount'] = reservationsCount;
      return data;
    } else {
      throw Exception('사용자 데이터를 찾을 수 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('오류가 발생했습니다.'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('데이터를 불러올 수 없습니다.'));
        }

        final userData = snapshot.data!;
        final studentId = userData['student number'] ?? '알 수 없음';
        final name = userData['name'] ?? '알 수 없음';
        final reservationsCount = userData['reservationsCount'] ?? 0;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(0xFF22CC88), // AppBar 색상 설정
                        width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '회원 정보',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        '아이디: $studentId',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        '이름: $name',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        '예약 정보: $reservationsCount건',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.0),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('로그아웃'),
                        onTap: () async {
                          await Provider.of<LoginProvider>(context,
                                  listen: false)
                              .signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Loginpage(),
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('로그아웃되었습니다.'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('회원탈퇴'),
                        onTap: () {
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
                                    onPressed: () async {
                                      await Provider.of<LoginProvider>(context,
                                              listen: false)
                                          .deleteUser();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const Loginpage(),
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('회원탈퇴가 완료되었습니다.'),
                                        ),
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
      },
    );
  }
}
