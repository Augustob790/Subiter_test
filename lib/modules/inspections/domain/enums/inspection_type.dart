enum InspectionType { thermographic, ultrasound }

extension InspectionTypeParsing on InspectionType {
  static InspectionType fromApi(String value) => switch (value) {
    'thermographic' => InspectionType.thermographic,
    'ultrasound' => InspectionType.ultrasound,
    _ => throw FormatException('Tipo de inspeção inválido: $value'),
  };
}
