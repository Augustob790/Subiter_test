import '../enums/inspection_result.dart';
import '../enums/inspection_type.dart';

class InspectionModel {
  const InspectionModel({
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
  final InspectionType type;
  final String inspector;
  final DateTime date;
  final InspectionResult result;
  final String equipment;
  final String location;
  final String summary;
  final String measurementLabel;
  final double measurementValue;
  final String measurementUnit;
}
