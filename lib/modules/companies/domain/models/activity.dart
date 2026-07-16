class Activity {
  const Activity({
    this.id,
    required this.companyName,
    required this.location,
    required this.createdAt,
  });

  final int? id;
  final String companyName;
  final String location;
  final DateTime createdAt;
}
