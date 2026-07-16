import 'package:flutter/foundation.dart';

import '../domain/models/inspection_model.dart';
import '../domain/repositories/inspections_repository.dart';
import '../domain/usecases/get_inspections_usecase.dart';

enum InspectionsViewState { initial, loading, success, empty, error }

class InspectionsViewModel extends ChangeNotifier {
  InspectionsViewModel({required GetInspectionsUseCase getInspectionsUseCase})
    : _getInspectionsUseCase = getInspectionsUseCase;

  final GetInspectionsUseCase _getInspectionsUseCase;

  InspectionsViewState _state = InspectionsViewState.initial;
  List<InspectionModel> _inspections = const <InspectionModel>[];
  bool _isFromCache = false;

  InspectionsViewState get state => _state;
  List<InspectionModel> get inspections => List<InspectionModel>.unmodifiable(_inspections);
  bool get isFromCache => _isFromCache;
  bool get isLoading => _state == InspectionsViewState.loading;

  Future<void> getInspections() async {
    if (isLoading) return;

    _state = InspectionsViewState.loading;
    notifyListeners();

    try {
      final InspectionsResult response = await _getInspectionsUseCase();
      _inspections = response.inspections;
      _isFromCache = response.fromCache;
      _state = _inspections.isEmpty ? InspectionsViewState.empty : InspectionsViewState.success;
    } on Object {
      _state = InspectionsViewState.error;
    }

    notifyListeners();
  }
}
