enum Criterion implements Comparable<Criterion> {
  collectedAdaptivityPotential('ОАП'),
  testReliability('Д'),
  behaviorRegulation('ПР'),
  suicideRisk('СР'),
  communicationPotential('КП'),
  militaryPredisposition('ВПС'),
  deviancy('ДАП'),
  moralNormativity('МН');

  const Criterion(this.key);

  final String key;

  static Criterion fromString(String value) {
    return values.firstWhere((element) => element.key == value);
  }

  static List<Criterion> get rawCriteria =>
      values.where((c) => c != Criterion.collectedAdaptivityPotential).toList();

  @override
  int compareTo(Criterion other) => key.compareTo(other.key);
}
