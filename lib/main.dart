import 'package:flutter/material.dart';
import 'package:project_studyroom/Loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_studyroom/firebase_options.dart';
import 'package:project_studyroom/providers/login_provider.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';
import '../providers/reserv_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        // ReservationProvider 추가
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

//statelesswidget을 상속받아, 불변의 위젯 정의
class MyApp extends StatelessWidget {
  // ignore: use_super_parameters
  const MyApp({super.key});
//생성자로 key를 받아 부모 클래스의 생성자에 전달
//const는 생성자를 상수로 만듦
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loginpage(),
    );
  }
}
//위젯의 UI를 정의하는 메서드 MaterialApp을 반환하여 어플의 기본설정을 제공

