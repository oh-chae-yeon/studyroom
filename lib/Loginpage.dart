import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_studyroom/Homepage.dart';
import 'package:project_studyroom/providers/login_provider.dart';
import 'package:project_studyroom/signup.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});
  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  //생성자
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      await Provider.of<LoginProvider>(context, listen: false)
          .signInWithEmailAndPassword(
              _emailController.text, _passwordController.text);

      User? user = Provider.of<LoginProvider>(context, listen: false).user;

      if (user != null && user.emailVerified) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(null),
          ),
        );
      } else {
        await user?.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('인증 메일을 확인하세요.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(),
        backgroundColor: Color(0xFF22CC88), //배경 red
        centerTitle: true, //가운데 정렬
        title: const Text(
          //제목
          "경북대 복지관 스터디룸 예약",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), //여백주기
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "이메일",
                ),
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '이메일을 입력하세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "비밀번호",
                ),
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '이메일을 입력하세요.';
                  }
                  return null;
                },
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text('로그인'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Signup(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  //backgroundColor: Colors.white, // 텍스트 색상
                  foregroundColor:
                      Color.fromARGB(255, 0, 13, 8), // 배경 색상 // 배경 색상
                ),
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
