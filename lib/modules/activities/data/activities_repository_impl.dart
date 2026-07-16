import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../domain/entities/activity.dart';
import '../domain/repositories/activities_repository.dart';

class ActivitiesRepositoryImpl implements ActivitiesRepository {
  const ActivitiesRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<Activity> save(Activity activity) async {
    final Database database = await _database.instance;
    final int id = await database.insert('activities', <String, Object?>{
      'company_name': activity.companyName,
      'location': activity.location,
      'created_at': activity.createdAt.toIso8601String(),
    });
    return Activity(
      id: id,
      companyName: activity.companyName,
      location: activity.location,
      createdAt: activity.createdAt,
    );
  }

  @override
  Future<Activity> update(Activity activity) async {
    final Database database = await _database.instance;
    await database.update(
      'activities',
      <String, Object?>{'company_name': activity.companyName, 'location': activity.location},
      where: 'id = ?',
      whereArgs: [activity.id],
    );
    return activity;
  }

  @override
  Future<void> delete(int id) async {
    final Database database = await _database.instance;
    await database.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Activity>> getActivities() async {
    final Database database = await _database.instance;
    final List<Map<String, Object?>> rows = await database.query('activities', orderBy: 'created_at DESC');

    return rows
        .map((Map<String, Object?> row) {
          return Activity(
            id: row['id'] as int?,
            companyName: row['company_name']! as String,
            location: row['location']! as String,
            createdAt: DateTime.parse(row['created_at']! as String),
          );
        })
        .toList(growable: false);
  }
}
