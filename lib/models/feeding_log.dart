class FeedingLog {
  final String id;
  final DateTime timestamp;
  final int grams;
  final String triggerType; // "manual" or "scheduled"

  FeedingLog({
    required this.id,
    required this.timestamp,
    required this.grams,
    required this.triggerType,
  });

  factory FeedingLog.fromMap(String id, Map<dynamic, dynamic> map) {
    return FeedingLog(
      id: id,
      timestamp: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
          : DateTime.now(),
      grams: map['grams'] as int? ?? 0,
      triggerType: map['trigger_type'] as String? ?? 'manual',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'grams': grams,
      'trigger_type': triggerType,
    };
  }
}