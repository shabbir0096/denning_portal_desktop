
class ChatEntry {
  final String text;
  final DateTime date;
  final bool read;
  final bool sent;

  ChatEntry({
    required this.text,
    required this.date,
    required this.read,
    required this.sent,
  });

}