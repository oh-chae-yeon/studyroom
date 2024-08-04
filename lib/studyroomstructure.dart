import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_studyroom/reservation.dart';

class Studyroomstructure extends StatelessWidget {
  const Studyroomstructure({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스터디룸 구조'),
        backgroundColor: Color(0xFF22CC88),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReservationScreen(),
                ),
              );
            },
            icon:
                const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Image.asset(
          'assets/structure.png',
          width: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }
}
