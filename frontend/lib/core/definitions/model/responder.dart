class Responder {
  final String name;
  final String surname;
  final String fathersName;
  final String rank;
  final String position;

  Responder({
    required this.name,
    required this.surname,
    required this.fathersName,
    required this.rank,
    required this.position,
  });

  String get fullName {
    final sb = StringBuffer();
    sb.write('$surname $name');
    if (fathersName.isNotEmpty) sb.write(' $fathersName');
    return sb.toString();
  }
}
