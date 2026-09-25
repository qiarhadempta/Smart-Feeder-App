class SensorData {
  final double phValue;
  final bool isOnline;
  final DateTime lastUpdated;

  SensorData({
    required this.phValue,
    required this.isOnline,
    required this.lastUpdated,
  });

  // Check if pH value is within safe range for Tilapia (Nila) fish (6.5 - 8.5)
  bool get isPhSafe => phValue >= 6.5 && phValue <= 8.5;

  factory SensorData.fromMap(Map<dynamic, dynamic> map) {
    return SensorData(
      phValue: (map['ph_value'] as num?)?.toDouble() ?? 0.0,
      isOnline: map['is_online'] as bool? ?? false,
      lastUpdated: map['last_updated'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_updated'] as int)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ph_value': phValue,
      'is_online': isOnline,
      'last_updated': lastUpdated.millisecondsSinceEpoch,
    };
  }
}