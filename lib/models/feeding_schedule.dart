class FeedingSchedule {
  final String id;
  final String time; // Format "HH:mm" (e.g., "08:00")
  final List<int> days; // 1 = Monday, 7 = Sunday
  final int grams;
  final bool isActive;

  FeedingSchedule({
    required this.id,
    required this.time,
    required this.days,
    required this.grams,
    this.isActive = true,
  });

  factory FeedingSchedule.fromMap(String id, Map<dynamic, dynamic> map) {
    return FeedingSchedule(
      id: id,
      time: map['time'] as String? ?? '00:00',
      days: List<int>.from(map['days'] as List? ?? []),
      grams: map['grams'] as int? ?? 0,
      isActive: map['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'days': days,
      'grams': grams,
      'is_active': isActive,
    };
  }

  FeedingSchedule copyWith({
    String? id,
    String? time,
    List<int>? days,
    int? grams,
    bool? isActive,
  }) {
    return FeedingSchedule(
      id: id ?? this.id,
      time: time ?? this.time,
      days: days ?? this.days,
      grams: grams ?? this.grams,
      isActive: isActive ?? this.isActive,
    );
  }
}