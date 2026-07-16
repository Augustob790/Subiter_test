import 'package:flutter/material.dart';
import 'package:subiter_test/core/navigator/app_navigator.dart';

import '../../../core/di/iod.dart';
import '../../../core/i18n/app_localizations.dart';
import 'activities_list_view_model.dart';
import 'activity_registration_view_model.dart';

class ActivityRegistrationPage extends StatefulWidget {
  const ActivityRegistrationPage({super.key});

  @override
  State<ActivityRegistrationPage> createState() => _ActivityRegistrationPageState();
}

class _ActivityRegistrationPageState extends State<ActivityRegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final ActivityRegistrationViewModel _activityRegistrationViewModel = IoD.instance
      .get<ActivityRegistrationViewModel>();
  AppNavigator navigator = IoD.instance.get<AppNavigator>();
  late final ActivitiesListViewModel _listViewModel;
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _listViewModel = IoD.instance.get<ActivitiesListViewModel>();
    final selectedActivity = _listViewModel.selectedActivity;
    if (selectedActivity != null) {
      _editingId = selectedActivity.id;
      _companyController.text = selectedActivity.companyName;
      _locationController.text = selectedActivity.location;
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingId != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Empresa' : 'Cadastro de Empresa')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              TextFormField(
                key: const Key('companyField'),
                controller: _companyController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: context.l10n.text('company')),
                validator: _required,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('locationField'),
                controller: _locationController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: context.l10n.text('location')),
                validator: _required,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              ListenableBuilder(
                listenable: _activityRegistrationViewModel,
                builder: (BuildContext context, Widget? child) {
                  return FilledButton.icon(
                    key: const Key('registerButton'),
                    onPressed: _activityRegistrationViewModel.isSaving ? null : _submit,
                    icon: _activityRegistrationViewModel.isSaving
                        ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.save),
                    label: Text(isEditing ? 'Atualizar' : context.l10n.text('register')),
                  );
                },
              ),
              const SizedBox(height: 24),
              ListenableBuilder(
                listenable: _activityRegistrationViewModel,
                builder: (BuildContext context, Widget? child) {
                  final ActivityRegistrationViewModel viewModel = _activityRegistrationViewModel;
                  if (viewModel.status == ActivityRegistrationStatus.failure) {
                    return const Card(
                      child: Padding(padding: EdgeInsets.all(16), child: Text('Não foi possível salvar o cadastro.')),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) => value == null || value.trim().isEmpty ? context.l10n.text('required') : null;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await _activityRegistrationViewModel.submit(
      id: _editingId,
      companyName: _companyController.text,
      location: _locationController.text,
    );
    if (!mounted) return;
    if (_activityRegistrationViewModel.status == ActivityRegistrationStatus.success) {
      navigator.pop(result: true);
    }
  }
}
