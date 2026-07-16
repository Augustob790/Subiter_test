import 'package:flutter/foundation.dart';

import '../domain/models/activity.dart';
import '../domain/usecases/register_activity.dart';
import '../domain/usecases/update_activity.dart';

enum ActivityRegistrationStatus { initial, saving, success, failure }

class ActivityRegistrationViewModel extends ChangeNotifier {
  ActivityRegistrationViewModel(this._registerActivity, this._updateActivity);

  final RegisterActivity _registerActivity;
  final UpdateActivity _updateActivity;

  ActivityRegistrationStatus _status = ActivityRegistrationStatus.initial;
  Activity? _activity;

  ActivityRegistrationStatus get status => _status;
  Activity? get activity => _activity;
  bool get isSaving => _status == ActivityRegistrationStatus.saving;

  Future<void> submit({int? id, required String companyName, required String location}) async {
    if (isSaving) return;
    _status = ActivityRegistrationStatus.saving;
    notifyListeners();
    try {
      if (id != null) {
        _activity = await _updateActivity(
          id: id,
          companyName: companyName,
          location: location,
          createdAt: DateTime.now(),
        );
      } else {
        _activity = await _registerActivity(companyName: companyName, location: location);
      }
      _status = ActivityRegistrationStatus.success;
    } on Object {
      _status = ActivityRegistrationStatus.failure;
    }
    notifyListeners();
  }
}
