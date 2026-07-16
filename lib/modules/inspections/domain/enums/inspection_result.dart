enum InspectionResult { approved, attention, rejected }

extension InspectionResultParsing on InspectionResult {
  static InspectionResult fromApi(String value) => switch (value) {
    'approved' => InspectionResult.approved,
    'attention' => InspectionResult.attention,
    'rejected' => InspectionResult.rejected,
    _ => throw FormatException('Resultado de inspeção inválido: $value'),
  };
}
