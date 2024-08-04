import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:project_studyroom/providers/login_provider.dart';
import 'package:project_studyroom/providers/reserv_provider.dart';
import 'package:project_studyroom/Loginpage.dart';
import 'package:project_studyroom/Homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<LoginProvider>(
        builder: (context, loginProvider, child) {
          if (loginProvider.user == null) {
            return const Loginpage();
          } else {
            return HomePage(loginProvider.user);
          }
        },
      ),
    );
  }
}
