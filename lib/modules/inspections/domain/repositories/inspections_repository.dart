import '../models/inspection_model.dart';

class InspectionsResult {
  const InspectionsResult(this.inspections, {required this.fromCache});

  final List<InspectionModel> inspections;
  final bool fromCache;
}

abstract interface class InspectionsRepository {
  Future<InspectionsResult> getInspections();
}
