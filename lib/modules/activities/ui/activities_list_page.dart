import 'package:flutter/material.dart';
import '../../../core/di/iod.dart';
import '../../../core/navigator/app_navigator.dart';
import '../../../core/router.dart';
import 'activities_list_view_model.dart';

class ActivitiesListPage extends StatefulWidget {
  const ActivitiesListPage({super.key});

  @override
  State<ActivitiesListPage> createState() => _ActivitiesListPageState();
}

class _ActivitiesListPageState extends State<ActivitiesListPage> {
  ActivitiesListViewModel viewModel = IoD.instance.get<ActivitiesListViewModel>();
  AppNavigator navigator = IoD.instance.get<AppNavigator>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.state == ActivitiesListState.loading && viewModel.activities.isEmpty) {
        viewModel.fetch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atividades')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (BuildContext context, Widget? child) {
          return switch (viewModel.state) {
            ActivitiesListState.loading => const Center(child: CircularProgressIndicator()),
            ActivitiesListState.empty => const Center(child: Text('Nenhuma atividade cadastrada.')),
            ActivitiesListState.error => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Erro ao carregar as atividades.'),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: viewModel.fetch, child: const Text('Tentar novamente')),
                ],
              ),
            ),
            ActivitiesListState.success => RefreshIndicator(
              onRefresh: viewModel.fetch,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.activities.length,
                itemBuilder: (BuildContext context, int index) {
                  final activity = viewModel.activities[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text('Empresa: ${activity.companyName}'),
                      subtitle: Text('Local: ${activity.location}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              viewModel.setSelectedActivity(activity);
                              await navigator.push(AppRoutes.activityRegister);
                              if (mounted) {
                                viewModel.fetch();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, activity.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          viewModel.setSelectedActivity(null);
          await navigator.push(AppRoutes.activityRegister);
          if (mounted) {
            viewModel.fetch();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Cadastrar'),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Atividade'),
        content: const Text('Tem certeza que deseja excluir esta atividade?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.deleteActivity(id);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
