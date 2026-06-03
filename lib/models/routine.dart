class SubRoutine {
  final String id;
  final String name;
  final String time;
  final bool alertEnabled;

  SubRoutine({
    required this.id,
    required this.name,
    required this.time,
    this.alertEnabled = true,
  });

  SubRoutine copyWith({
    String? id,
    String? name,
    String? time,
    bool? alertEnabled,
  }) {
    return SubRoutine(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      alertEnabled: alertEnabled ?? this.alertEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'alertEnabled': alertEnabled,
    };
  }

  factory SubRoutine.fromJson(Map<String, dynamic> json) {
    return SubRoutine(
      id: json['id'] as String,
      name: json['name'] as String,
      time: json['time'] as String,
      alertEnabled: json['alertEnabled'] as bool? ?? true,
    );
  }

  factory SubRoutine.fromSupabase(Map<String, dynamic> row) {
    return SubRoutine(
      id: row['id'] as String,
      name: row['name'] as String,
      time: row['alert_time'] as String? ?? '',
      alertEnabled: row['alert_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toSupabase(String challengeId, int sortOrder) {
    return {
      'id': id,
      'challenge_id': challengeId,
      'name': name,
      'alert_time': time,
      'alert_enabled': alertEnabled && time.isNotEmpty,
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
