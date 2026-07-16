import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subiter_test/modules/inspections/domain/enums/inspection_result.dart';
import 'package:subiter_test/modules/inspections/domain/enums/inspection_type.dart';
import 'package:subiter_test/modules/inspections/domain/models/inspection_model.dart';
import 'package:subiter_test/modules/inspections/domain/repositories/inspections_repository.dart';
import 'package:subiter_test/modules/inspections/domain/usecases/get_inspections_usecase.dart';
import 'package:subiter_test/modules/inspections/ui/inspections_viewmodel.dart';

class _InspectionsRepositoryMock extends Mock
    implements InspectionsRepository {}

void main() {
  late _InspectionsRepositoryMock repository;
  late InspectionsViewModel viewModel;

  final InspectionModel inspection = InspectionModel(
    id: 'INS-001',
    type: InspectionType.thermographic,
    inspector: 'Ana Souza',
    date: DateTime(2026, 7, 10),
    result: InspectionResult.attention,
    equipment: 'Painel QGBT-01',
    location: 'Planta A',
    summary: 'Ponto quente identificado.',
    measurementLabel: 'Temperatura máxima',
    measurementValue: 87.4,
    measurementUnit: '°C',
  );

  setUp(() {
    repository = _InspectionsRepositoryMock();
    viewModel = InspectionsViewModel(
      getInspectionsUseCase: GetInspectionsUseCase(repository),
    );
  });

  test('expõe sucesso e dados do cache', () async {
    when(repository.getInspections).thenAnswer(
      (_) async =>
          InspectionsResult(<InspectionModel>[inspection], fromCache: true),
    );

    await viewModel.getInspections();

    expect(viewModel.state, InspectionsViewState.success);
    expect(viewModel.inspections.single.id, 'INS-001');
    expect(viewModel.isFromCache, isTrue);
  });

  test('expõe estado vazio quando a API não retorna itens', () async {
    when(repository.getInspections).thenAnswer(
      (_) async =>
          const InspectionsResult(<InspectionModel>[], fromCache: false),
    );

    await viewModel.getInspections();

    expect(viewModel.state, InspectionsViewState.empty);
  });

  test('converte exceção em estado de erro para a interface', () async {
    when(repository.getInspections).thenThrow(Exception('JSON inválido'));

    await viewModel.getInspections();

    expect(viewModel.state, InspectionsViewState.error);
    expect(viewModel.inspections, isEmpty);
  });
}
