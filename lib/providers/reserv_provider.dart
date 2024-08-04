import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  Future<void> initializeReservationData() async {
    List<DateTime> dates = getNextSevenWeekdays();
    DateTime today = DateTime.now();

    // 이전 날짜 데이터 삭제
    await _deleteOldReservations(today);

    // 새로운 7일 데이터 설정
    for (DateTime date in dates) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('reservations').doc(formattedDate).get();

      if (!snapshot.exists) {
        Map<String, List<bool>> reservationData = {
          'Study Room 1': List<bool>.filled(9, true),
          'Study Room 2': List<bool>.filled(9, true),
          'Study Room 3': List<bool>.filled(9, true),
          'Study Room 4': List<bool>.filled(9, true),
          'Study Room 5': List<bool>.filled(9, true),
        };
        await _firestore.collection('reservations').doc(formattedDate).set(reservationData);
      }
    }
  }

  Future<void> _deleteOldReservations(DateTime today) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('reservations').get();

    for (var doc in snapshot.docs) {
      DateTime docDate = DateFormat('yyyy-MM-dd').parse(doc.id);
      if (docDate.isBefore(today)) {
        await _firestore.collection('reservations').doc(doc.id).delete();
      }
    }
  }

  List<DateTime> getNextSevenWeekdays() {
    DateTime now = DateTime.now();
    List<DateTime> weekdays = [];
    while (weekdays.length < 7) {
      now = now.add(Duration(days: 1));
      if (now.weekday != DateTime.saturday && now.weekday != DateTime.sunday) {
        weekdays.add(now);
      }
    }
    return weekdays;
  }

  Future<Map<String, List<bool>>> fetchReservationData(String date) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('reservations').doc(date).get();
      Map<String, List<bool>> reservationData = {};
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data()!;
        data.forEach((room, times) {
          reservationData[room] = List<bool>.from(times);
        });
      } else {
        reservationData = {
          'Study Room 1': List<bool>.filled(9, true),
          'Study Room 2': List<bool>.filled(9, true),
          'Study Room 3': List<bool>.filled(9, true),
          'Study Room 4': List<bool>.filled(9, true),
          'Study Room 5': List<bool>.filled(9, true),
        };
        await _firestore.collection('reservations').doc(date).set(reservationData);
      }
      return reservationData;
    } catch (e) {
      return {};
    }
  }

  Future<void> updateReservation(
      String date, String room, int timeIndex, bool isAvailable) async {
    await _firestore.collection('reservations').doc(date).update({
      '$room.$timeIndex': isAvailable,
    });
    notifyListeners();
  }

  Future<void> handleReservation(
      String date, String room, int startTime, int duration, User user) async {
    _isProcessing = true;
    notifyListeners();

    bool hasAlreadyReserved = await checkUserReservation(date, user);
    if (hasAlreadyReserved) {
      _isProcessing = false;
      notifyListeners();
      throw Exception('당일 예약은 한 번만 가능합니다.');
    }

    Map<String, List<bool>> reservationData = await fetchReservationData(date);

    for (int i = 0; i < duration; i++) {
      if (reservationData[room]![startTime - 9 + i] == false) {
        _isProcessing = false;
        notifyListeners();
        throw Exception('이미 예약된 시간입니다.');
      }
    }

    for (int i = 0; i < duration; i++) {
      reservationData[room]![startTime - 9 + i] = false;
    }
    await _firestore.collection('reservations').doc(date).update({
      room: reservationData[room]!,
    });

    await saveReservation(date, room, startTime, duration, user);

    _isProcessing = false;
    notifyListeners();
  }

  Future<bool> checkUserReservation(String date, User user) async {
    QuerySnapshot snapshot = await _firestore
        .collection('user_reservations')
        .where('date', isEqualTo: date)
        .where('user.uid', isEqualTo: user.uid)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> saveReservation(
      String date, String room, int startTime, int duration, User user) async {
    await _firestore.collection('user_reservations').add({
      'date': date,
      'room': room,
      'startTime': startTime,
      'duration': duration,
      'user': {
        'uid': user.uid,
        'email': user.email,
      },
    });
  }

  Future<List<Map<String, dynamic>>> fetchUserReservations(User user) async {
    QuerySnapshot snapshot = await _firestore
        .collection('user_reservations')
        .where('user.uid', isEqualTo: user.uid)
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<int> getUserReservationCount(User user) async {
    QuerySnapshot snapshot = await _firestore
        .collection('user_reservations')
        .where('user.uid', isEqualTo: user.uid)
        .get();
    return snapshot.docs.length;
  }

  Future<void> cancelReservation(
      String reservationId, String date, String room, int timeIndex) async {
    await _firestore.collection('user_reservations').doc(reservationId).delete();
    await updateReservation(date, room, timeIndex, true); // 예약 취소 시 해당 시간대 다시 사용 가능하도록 업데이트
    notifyListeners();
  }
}
