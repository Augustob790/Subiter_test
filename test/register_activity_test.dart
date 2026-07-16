import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subiter_test/modules/activities/domain/entities/activity.dart';
import 'package:subiter_test/modules/activities/domain/repositories/activities_repository.dart';
import 'package:subiter_test/modules/activities/domain/use_cases/register_activity.dart';

class _ActivitiesRepositoryMock extends Mock implements ActivitiesRepository {}

void main() {
  late _ActivitiesRepositoryMock repository;
  late RegisterActivity useCase;

  setUpAll(() {
    registerFallbackValue(
      Activity(
        companyName: 'fallback',
        location: 'fallback',
        createdAt: DateTime(2026),
      ),
    );
  });

  setUp(() {
    repository = _ActivitiesRepositoryMock();
    useCase = RegisterActivity(repository);
  });

  test('normaliza e persiste o cadastro', () async {
    when(() => repository.save(any())).thenAnswer((
      Invocation invocation,
    ) async {
      final Activity activity =
          invocation.positionalArguments.single as Activity;
      return Activity(
        id: 1,
        companyName: activity.companyName,
        location: activity.location,
        createdAt: activity.createdAt,
      );
    });
    final Activity saved = await useCase(
      companyName: '  ABC Engenharia ',
      location: ' São José dos Campos  ',
    );
    expect(saved.companyName, 'ABC Engenharia');
    expect(saved.location, 'São José dos Campos');
    verify(() => repository.save(any())).called(1);
  });

  test('rejeita campos vazios antes do repositório', () async {
    expect(
      () => useCase(companyName: ' ', location: 'São José dos Campos'),
      throwsA(isA<FormatException>()),
    );
    verifyNever(() => repository.save(any()));
  });
}
