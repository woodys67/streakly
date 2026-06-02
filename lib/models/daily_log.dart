class DailyLog {
  final String id;
  final String challengeId;
  final int day;
  final String content;
  final DateTime timestamp;

  DailyLog({
    required this.id,
    required this.challengeId,
    required this.day,
    required this.content,
    required this.timestamp,
  });

  DailyLog copyWith({
    String? id,
    String? challengeId,
    int? day,
    String? content,
    DateTime? timestamp,
  }) {
    return DailyLog(
      id: id ?? this.id,
      challengeId: challengeId ?? this.challengeId,
      day: day ?? this.day,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeId': challengeId,
      'day': day,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      id: json['id'] as String,
      challengeId: json['challengeId'] as String,
      day: json['day'] as int,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  factory DailyLog.fromSupabase(Map<String, dynamic> row) {
    return DailyLog(
      id: row['id'] as String,
      challengeId: row['challenge_id'] as String,
      day: row['day_number'] as int,
      content: row['content'] as String,
      timestamp: DateTime.parse(row['created_at'] as String),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'challenge_id': challengeId,
      'day_number': day,
      'content': content,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyLog && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
