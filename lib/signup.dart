import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_studyroom/Loginpage.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _studentnumberController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> signUp() async {
    if (_formkey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '비밀번호가 다릅니다.',
            ),
          ),
        );
      }
    }

    // if (!_emailController.text.endsWith('@knu.ac.kr')) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('이메일은 @knu.ac.kr으로 작성해 주세요.'),
    //     ),
    //   );
    //   return;
    // }
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      var db = FirebaseFirestore.instance;

      final user = <String, dynamic>{
        "name": _nameController.text,
        "email": _emailController.text,
        "student number": int.tryParse(_studentnumberController.text) ??
            _studentnumberController.text,
      };

      credential.user?.sendEmailVerification();

      await db
          .collection("users")
          .doc(credential.user!.uid)
          .set(user)
          // ignore: avoid_print
          .onError((e, _) => print("Error writing document: $e"));
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (_) => const Loginpage(),
        ),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '이메일 인증을 하세요.',
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The password provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account already exists for that email.')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0), //배경 red
        centerTitle: true, //가운데 정렬
        title: const Text(
          //제목
          "회원가입",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), //여백주기
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "이메일",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _studentnumberController,
                  decoration: InputDecoration(
                    labelText: "학번",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '학번을 입력해주세요';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "이름",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "비밀번호",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '비밀번호을 입력해주세요';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "비밀번호 재확인",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '비밀번호 재확인을 입력해주세요';
                    }
                    return null;
                  },
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    onPressed: signUp,
                    child: const Text('회원가입'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
