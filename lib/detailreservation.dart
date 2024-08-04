import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_studyroom/providers/reserv_provider.dart';

class Detailreservation extends StatelessWidget {
  const Detailreservation({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Container(),
        backgroundColor: Color(0xFF22CC88),
        centerTitle: true,
        title: const Text(
          '나의 예약',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: user != null
          ? FutureBuilder<List<Map<String, dynamic>>>(
              future: Provider.of<ReservationProvider>(context, listen: false)
                  .fetchUserReservations(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No reservations found.'));
                }

                List<Map<String, dynamic>> reservations = snapshot.data!;

                return ListView(
                  children: reservations.map((reservation) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '공간명 : ${reservation['room']}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            SizedBox(height: 8),
                            Text(
                              '신청일시 : ${reservation['date']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '예약일시 : ${reservation['startTime']} ~ ${reservation['startTime'] + reservation['duration']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showCancelDialog(
                                        context, reservation['id'], reservation['date'], reservation['room'], reservation['startTime'] - 9);
                                  },
                                  child: const Text('예약취소'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            )
          : Center(child: Text('User not logged in')),
    );
  }

  void _showCancelDialog(BuildContext context, String reservationId, String date, String room, int timeIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('예약 취소'),
          content: const Text('정말로 예약을 취소하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('아니오'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // 예약 취소 로직 추가
                await Provider.of<ReservationProvider>(context, listen: false)
                    .cancelReservation(reservationId, date, room, timeIndex);
                // 다음 프레임에서 ScaffoldMessenger 호출
               
              },
              child: const Text('예'),
            ),
          ],
        );
      },
    );
  }
}
