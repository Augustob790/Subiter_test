import 'package:flutter/material.dart';
import '../../../core/di/iod.dart';

import '../../../core/i18n/app_localizations.dart';
import 'inspections_viewmodel.dart';
import 'widgets/inspection_card.dart';

class InspectionsScreen extends StatefulWidget {
  const InspectionsScreen({super.key});

  @override
  State<InspectionsScreen> createState() => _InspectionsScreenState();
}

class _InspectionsScreenState extends State<InspectionsScreen> {
  InspectionsViewModel viewModel = IoD.instance.get<InspectionsViewModel>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.state == InspectionsViewState.initial) {
        viewModel.getInspections();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.text('inspectionsTitle'))),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (BuildContext context, Widget? child) {
          return switch (viewModel.state) {
            InspectionsViewState.initial ||
            InspectionsViewState.loading => const Center(child: CircularProgressIndicator()),
            InspectionsViewState.empty => _MessageState(icon: Icons.search_off, message: context.l10n.text('empty')),
            InspectionsViewState.error => _MessageState(
              icon: Icons.error_outline,
              message: context.l10n.text('loadError'),
              actionLabel: context.l10n.text('retry'),
              onAction: viewModel.getInspections,
            ),
            InspectionsViewState.success => RefreshIndicator(
              onRefresh: viewModel.getInspections,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.inspections.length + (viewModel.isFromCache ? 1 : 0),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  if (viewModel.isFromCache && index == 0) {
                    return MaterialBanner(
                      content: Text(context.l10n.text('cachedData')),
                      actions: <Widget>[
                        TextButton(onPressed: viewModel.getInspections, child: Text(context.l10n.text('retry'))),
                      ],
                    );
                  }
                  final int inspectionIndex = index - (viewModel.isFromCache ? 1 : 0);
                  return InspectionCard(inspection: viewModel.inspections[inspectionIndex]);
                },
              ),
            ),
          };
        },
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.icon, required this.message, this.actionLabel, this.onAction});

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 52),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          if (onAction != null) ...<Widget>[
            const SizedBox(height: 12),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    ),
  );
}
