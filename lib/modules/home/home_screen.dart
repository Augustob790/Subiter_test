import 'package:flutter/material.dart';
import '../../../core/di/iod.dart';
import '../../../core/navigator/app_navigator.dart';
import '../inspections/inspections_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = IoD.instance.get<AppNavigator>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                navigator.push(InspectionsRoutes.list);
              },
              child: const Text('Atividade 2'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                navigator.push('/activities');
              },
              child: const Text('Atividade 4'),
            ),
          ],
        ),
      ),
    );
  }
}
