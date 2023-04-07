enum Criterion implements Comparable<Criterion> {
  behaviorRegulation('behavior_regulation'),
  testReliability('reliability'),
  suicideRisk('suicide_risk'),
  communicationPotential('communication_potential'),
  collectedAdaptivityPotential('adaptivity'),
  militaryPredisposition('military_predisposition'),
  deviancy('deviancy'),
  moralNormativity('moral_normativity');

  const Criterion(this.key);

  final String key;

  static Criterion fromString(String value) {
    return values.firstWhere((element) => element.key == value);
  }

  static List<Criterion> get rawCriteria =>
      values.where((c) => c == Criterion.collectedAdaptivityPotential).toList();

  @override
  int compareTo(Criterion other) => key.compareTo(other.key);
}
