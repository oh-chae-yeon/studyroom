import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReservationProvider with ChangeNotifier {
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isValidTimeRange(DateTime startTime, DateTime endTime) {
    final duration = endTime.difference(startTime);
    return duration.inMinutes >= 30 && duration.inHours <= 3;
  }

  DateTime _parseTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    return DateTime(
        now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  Future<bool> reserveTime({
    required String date,
    required String startTime,
    required String endTime,
    required String purpose,
    required String room,
  }) async {
    if (_isProcessing) return false;

    _isProcessing = true;
    notifyListeners();

    try {
      DateTime start = _parseTime(startTime);
      DateTime end = _parseTime(endTime);

      if (!_isValidTimeRange(start, end)) {
        return false;
      }

      QuerySnapshot existingReservations = await FirebaseFirestore.instance
          .collection('reservations')
          .where('date', isEqualTo: date)
          .where('startTime', isEqualTo: startTime)
          .where('endTime', isEqualTo: endTime)
          .where('room', isEqualTo: room)
          .get();

      if (existingReservations.docs.isNotEmpty) {
        return false;
      }

      await FirebaseFirestore.instance.collection('reservations').add({
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'purpose': purpose,
        'room': room,
        'status': 'booked',
      });

      return true;
    } catch (error) {
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
