enum BadgeEventType {
  checkIn,
  challengeCompleted,
  logWritten,
  logViewed,
  subroutineCreated,
  teamJoined,
  teamCompleted,
}

class BadgeEvent {
  final BadgeEventType type;
  final DateTime timestamp;
  final Map<String, dynamic> payload;

  const BadgeEvent({
    required this.type,
    required this.timestamp,
    this.payload = const {},
  });
}
