import 'package:firebase_database/firebase_database.dart';
import '../models/sensor_data.dart';
import '../models/feeding_schedule.dart';
import '../models/feeding_log.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // 1. Stream real-time sensor data (pH, status online, and last updated)
  Stream<SensorData> getSensorDataStream() {
    return _db.child('sensor_data').onValue.map((event) {
      if (event.snapshot.value != null) {
        final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        return SensorData.fromMap(data);
      }
      return SensorData(
        phValue: 0.0,
        isOnline: false,
        lastUpdated: DateTime.now(),
      );
    });
  }

  // 2. Trigger manual feeding command
  Future<void> triggerManualFeeding(int grams) async {
    final newCommandRef = _db.child('commands/manual_feed').push();
    await newCommandRef.set({
      'grams': grams,
      'status': 'pending', // Pending -> Processing -> Success/Failed (handled by ESP32)
      'timestamp': ServerValue.timestamp,
    });
  }

  // 3. Get real-time stream of feeding schedules
  Stream<List<FeedingSchedule>> getSchedulesStream() {
    return _db.child('schedules').onValue.map((event) {
      final List<FeedingSchedule> schedules = [];
      if (event.snapshot.value != null) {
        final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        data.forEach((key, value) {
          schedules.add(FeedingSchedule.fromMap(
            key.toString(),
            Map<dynamic, dynamic>.from(value as Map),
          ));
        });
      }
      return schedules;
    });
  }

  // 4. CRUD operations for feeding schedules
  Future<void> addSchedule(FeedingSchedule schedule) async {
    await _db.child('schedules').push().set(schedule.toMap());
  }

  Future<void> updateSchedule(FeedingSchedule schedule) async {
    await _db.child('schedules/${schedule.id}').update(schedule.toMap());
  }

  Future<void> deleteSchedule(String scheduleId) async {
    await _db.child('schedules/$scheduleId').remove();
  }

  Future<void> toggleScheduleStatus(String scheduleId, bool isActive) async {
    await _db.child('schedules/$scheduleId').update({
      'is_active': isActive,
    });
  }

  // 5. Get real-time stream of feeding history logs
  Stream<List<FeedingLog>> getFeedingLogsStream() {
    return _db.child('feeding_logs').onValue.map((event) {
      final List<FeedingLog> logs = [];
      if (event.snapshot.value != null) {
        final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        data.forEach((key, value) {
          logs.add(FeedingLog.fromMap(
            key.toString(),
            Map<dynamic, dynamic>.from(value as Map),
          ));
        });
        // Sort logs by newest timestamp first
        logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
      return logs;
    });
  }
}