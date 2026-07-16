import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../domain/enums/inspection_result.dart';
import '../../domain/enums/inspection_type.dart';
import '../../domain/models/inspection_model.dart';

class InspectionCard extends StatelessWidget {
  const InspectionCard({super.key, required this.inspection});

  final InspectionModel inspection;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _statusColor(context, inspection.result);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                  child: Icon(
                    inspection.type == InspectionType.thermographic
                        ? Icons.thermostat
                        : Icons.graphic_eq,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        inspection.equipment,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${inspection.id} • ${_typeLabel(context)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      _resultLabel(context),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(inspection.summary),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: <Widget>[
                _Metadata(
                  icon: Icons.person_outline,
                  label:
                      '${context.l10n.text('inspector')}: '
                      '${inspection.inspector}',
                ),
                _Metadata(
                  icon: Icons.calendar_today_outlined,
                  label: DateFormat('dd/MM/yyyy HH:mm').format(inspection.date),
                ),
                _Metadata(
                  icon: Icons.location_on_outlined,
                  label: inspection.location,
                ),
                _Metadata(
                  icon: Icons.straighten,
                  label:
                      '${inspection.measurementLabel}: '
                      '${inspection.measurementValue.toStringAsFixed(2)} '
                      '${inspection.measurementUnit}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(BuildContext context) =>
      inspection.type == InspectionType.thermographic
      ? context.l10n.text('thermographic')
      : context.l10n.text('ultrasound');

  String _resultLabel(BuildContext context) => switch (inspection.result) {
    InspectionResult.approved => context.l10n.text('approved'),
    InspectionResult.attention => context.l10n.text('attention'),
    InspectionResult.rejected => context.l10n.text('rejected'),
  };

  Color _statusColor(BuildContext context, InspectionResult result) =>
      switch (result) {
        InspectionResult.approved => Theme.of(context).colorScheme.primary,
        InspectionResult.attention => Theme.of(context).colorScheme.tertiary,
        InspectionResult.rejected => Theme.of(context).colorScheme.error,
      };
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Icon(icon, size: 16),
      const SizedBox(width: 5),
      Text(label),
    ],
  );
}
