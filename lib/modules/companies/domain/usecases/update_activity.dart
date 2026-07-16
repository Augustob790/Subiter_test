import '../models/activity.dart';
import '../repositories/activities_repository.dart';

class UpdateActivity {
  const UpdateActivity(this._repository);

  final ActivitiesRepository _repository;

  Future<Activity> call({
    required int id,
    required String companyName,
    required String location,
    required DateTime createdAt,
  }) {
    return _repository.update(Activity(id: id, companyName: companyName, location: location, createdAt: createdAt));
  }
}
