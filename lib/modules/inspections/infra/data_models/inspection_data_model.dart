import '../../domain/enums/inspection_result.dart';
import '../../domain/enums/inspection_type.dart';
import '../../domain/models/inspection_model.dart';

class InspectionDataModel {
  const InspectionDataModel({
    required this.id,
    required this.type,
    required this.inspector,
    required this.date,
    required this.result,
    required this.equipment,
    required this.location,
    required this.summary,
    required this.measurementLabel,
    required this.measurementValue,
    required this.measurementUnit,
  });

  final String id;
  final String type;
  final String inspector;
  final String date;
  final String result;
  final String equipment;
  final String location;
  final String summary;
  final String measurementLabel;
  final double measurementValue;
  final String measurementUnit;

  factory InspectionDataModel.fromJson(Map<String, dynamic> json) {
    final Object? measurementValue = json['measurement'];
    if (measurementValue is! Map<String, dynamic>) {
      throw const FormatException('Medição da inspeção inválida.');
    }

    return InspectionDataModel(
      id: _requiredString(json, 'id'),
      type: _requiredString(json, 'type'),
      inspector: _requiredString(json, 'inspector'),
      date: _requiredString(json, 'date'),
      result: _requiredString(json, 'result'),
      equipment: _requiredString(json, 'equipment'),
      location: _requiredString(json, 'location'),
      summary: _requiredString(json, 'summary'),
      measurementLabel: _requiredString(measurementValue, 'label'),
      measurementValue: _requiredDouble(measurementValue, 'value'),
      measurementUnit: _requiredString(measurementValue, 'unit'),
    );
  }

  InspectionModel toDomain() => InspectionModel(
    id: id,
    type: InspectionTypeParsing.fromApi(type),
    inspector: inspector,
    date: DateTime.parse(date),
    result: InspectionResultParsing.fromApi(result),
    equipment: equipment,
    location: location,
    summary: summary,
    measurementLabel: measurementLabel,
    measurementValue: measurementValue,
    measurementUnit: measurementUnit,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'type': type,
    'inspector': inspector,
    'date': date,
    'result': result,
    'equipment': equipment,
    'location': location,
    'summary': summary,
    'measurement': <String, dynamic>{
      'label': measurementLabel,
      'value': measurementValue,
      'unit': measurementUnit,
    },
  };

  static String _requiredString(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Campo obrigatório inválido: $key');
    }
    return value.trim();
  }

  static double _requiredDouble(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is! num) throw FormatException('Número inválido: $key');
    return value.toDouble();
  }
}
