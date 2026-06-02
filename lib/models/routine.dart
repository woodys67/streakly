class SubRoutine {
  final String id;
  final String name;
  final String time;

  SubRoutine({
    required this.id,
    required this.name,
    required this.time,
  });

  SubRoutine copyWith({
    String? id,
    String? name,
    String? time,
  }) {
    return SubRoutine(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': time,
    };
  }

  factory SubRoutine.fromJson(Map<String, dynamic> json) {
    return SubRoutine(
      id: json['id'] as String,
      name: json['name'] as String,
      time: json['time'] as String,
    );
  }

  factory SubRoutine.fromSupabase(Map<String, dynamic> row) {
    return SubRoutine(
      id: row['id'] as String,
      name: row['name'] as String,
      time: row['alert_time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toSupabase(String challengeId, int sortOrder) {
    return {
      'id': id,
      'challenge_id': challengeId,
      'name': name,
      'alert_time': time,
      'alert_enabled': time.isNotEmpty,
      'sort_order': sortOrder,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubRoutine && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
