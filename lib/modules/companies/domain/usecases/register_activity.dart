import '../models/activity.dart';
import '../repositories/activities_repository.dart';

class RegisterActivity {
  const RegisterActivity(this._repository);

  final ActivitiesRepository _repository;

  Future<Activity> call({
    required String companyName,
    required String location,
  }) {
    final String normalizedCompany = companyName.trim();
    final String normalizedLocation = location.trim();
    if (normalizedCompany.isEmpty || normalizedLocation.isEmpty) {
      throw const FormatException('Campos obrigatórios não informados.');
    }
    return _repository.save(
      Activity(
        companyName: normalizedCompany,
        location: normalizedLocation,
        createdAt: DateTime.now(),
      ),
    );
  }
}
