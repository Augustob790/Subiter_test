import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../data_models/inspection_data_model.dart';

abstract interface class InspectionsLocalDataSource {
  Future<List<InspectionDataModel>> getInspections();
  Future<void> replaceInspections(List<InspectionDataModel> inspections);
}

class SqliteInspectionsLocalDataSource implements InspectionsLocalDataSource {
  const SqliteInspectionsLocalDataSource(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<List<InspectionDataModel>> getInspections() async {
    final Database database = await _appDatabase.instance;
    final List<Map<String, Object?>> rows = await database.query('inspections', orderBy: 'updated_at DESC');

    return rows
        .map((Map<String, Object?> row) {
          final Object? decoded = jsonDecode(row['payload']! as String);
          if (decoded is! Map<String, dynamic>) {
            throw const FormatException('Cache de inspeção inválido.');
          }
          return InspectionDataModel.fromJson(decoded);
        })
        .toList(growable: false);
  }

  @override
  Future<void> replaceInspections(List<InspectionDataModel> inspections) async {
    final Database database = await _appDatabase.instance;
    await database.transaction((Transaction transaction) async {
      await transaction.delete('inspections');
      final Batch batch = transaction.batch();
      final int updatedAt = DateTime.now().millisecondsSinceEpoch;
      for (final InspectionDataModel inspection in inspections) {
        batch.insert('inspections', <String, Object?>{
          'id': inspection.id,
          'payload': jsonEncode(inspection.toJson()),
          'updated_at': updatedAt,
        });
      }
      await batch.commit(noResult: true);
    });
  }
}
