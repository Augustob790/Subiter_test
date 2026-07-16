import 'package:flutter/foundation.dart';
import '../domain/models/activity.dart';
import '../domain/usecases/delete_activity.dart';
import '../domain/usecases/get_activities.dart';

enum ActivitiesListState { loading, success, error, empty }

class ActivitiesListViewModel extends ChangeNotifier {
  ActivitiesListViewModel(this._getActivities, this._deleteActivity);

  final GetActivities _getActivities;
  final DeleteActivity _deleteActivity;

  ActivitiesListState _state = ActivitiesListState.loading;
  List<Activity> _activities = const <Activity>[];
  Activity? _selectedActivity;

  ActivitiesListState get state => _state;
  List<Activity> get activities => _activities;
  Activity? get selectedActivity => _selectedActivity;

  void setSelectedActivity(Activity? activity) {
    _selectedActivity = activity;
  }

  Future<void> fetch() async {
    _state = ActivitiesListState.loading;
    notifyListeners();
    try {
      _activities = await _getActivities();
      _state = _activities.isEmpty ? ActivitiesListState.empty : ActivitiesListState.success;
    } on Object {
      _state = ActivitiesListState.error;
    }
    notifyListeners();
  }

  Future<void> deleteActivity(int id) async {
    try {
      await _deleteActivity(id);
      await fetch();
    } on Object {
      // Could show error state, but for now just let it fail silently or log
    }
  }
}
