import '../entities/activity.dart';
import '../repositories/activities_repository.dart';

class GetActivities {
  const GetActivities(this._repository);

  final ActivitiesRepository _repository;

  Future<List<Activity>> call() => _repository.getActivities();
}
