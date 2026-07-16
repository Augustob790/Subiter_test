import 'package:flutter_test/flutter_test.dart';
import 'package:subiter_test/modules/inspections/domain/enums/inspection_result.dart';
import 'package:subiter_test/modules/inspections/domain/enums/inspection_type.dart';
import 'package:subiter_test/modules/inspections/infra/data_models/inspection_data_model.dart';

void main() {
  test('mapeia o contrato JSON para o modelo de domínio', () {
    final InspectionDataModel dataModel = InspectionDataModel.fromJson(
      <String, dynamic>{
        'id': 'INS-001',
        'type': 'ultrasound',
        'inspector': 'Carlos Lima',
        'date': '2026-07-10T14:15:00-03:00',
        'result': 'approved',
        'equipment': 'Tubulação TV-12',
        'location': 'Utilidades',
        'summary': 'Espessura normal.',
        'measurement': <String, dynamic>{
          'label': 'Espessura medida',
          'value': 8.25,
          'unit': 'mm',
        },
      },
    );

    final inspection = dataModel.toDomain();

    expect(inspection.type, InspectionType.ultrasound);
    expect(inspection.result, InspectionResult.approved);
    expect(inspection.measurementValue, 8.25);
  });

  test('rejeita payload sem medição obrigatória', () {
    expect(
      () => InspectionDataModel.fromJson(<String, dynamic>{'id': 'INS-001'}),
      throwsA(isA<FormatException>()),
    );
  });
}
