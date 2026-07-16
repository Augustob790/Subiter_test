import '../models/activity.dart';

abstract interface class ActivitiesRepository {
  Future<Activity> save(Activity activity);
  Future<Activity> update(Activity activity);
  Future<void> delete(int id);
  Future<List<Activity>> getActivities();
}
