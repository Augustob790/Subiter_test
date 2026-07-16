import '../../domain/models/inspection_model.dart';
import '../../domain/repositories/inspections_repository.dart';
import '../data_models/inspection_data_model.dart';
import '../data_sources/inspections_local_data_source.dart';
import '../data_sources/inspections_remote_data_source.dart';

class InspectionsRepositoryImpl implements InspectionsRepository {
  const InspectionsRepositoryImpl({
    required InspectionsRemoteDataSource remoteDataSource,
    required InspectionsLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final InspectionsRemoteDataSource _remoteDataSource;
  final InspectionsLocalDataSource _localDataSource;

  @override
  Future<InspectionsResult> getInspections() async {
    try {
      final List<InspectionDataModel> response = await _remoteDataSource.getInspections();
      await _localDataSource.replaceInspections(response);
      return InspectionsResult(_toDomain(response), fromCache: false);
    } on Object {
      final List<InspectionDataModel> cached = await _localDataSource.getInspections();
      if (cached.isEmpty) rethrow;
      return InspectionsResult(_toDomain(cached), fromCache: true);
    }
  }

  List<InspectionModel> _toDomain(List<InspectionDataModel> data) {
    final List<InspectionModel> inspections = data
        .map((InspectionDataModel item) => item.toDomain())
        .toList(growable: false);
    return inspections..sort((InspectionModel a, InspectionModel b) => b.date.compareTo(a.date));
  }
}
