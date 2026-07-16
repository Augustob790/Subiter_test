import '../repositories/inspections_repository.dart';

class GetInspectionsUseCase {
  const GetInspectionsUseCase(this._repository);

  final InspectionsRepository _repository;

  Future<InspectionsResult> call() => _repository.getInspections();
}
