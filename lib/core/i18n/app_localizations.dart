import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const List<Locale> supportedLocales = <Locale>[Locale('pt', 'BR'), Locale('en')];
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const Map<String, Map<String, String>> _translations = <String, Map<String, String>>{
    'pt': <String, String>{
      'inspectionsTitle': 'Inspeções',
      'activity': 'Cadastrar atividade',
      'retry': 'Tentar novamente',
      'empty': 'Nenhuma inspeção encontrada.',
      'loadError': 'Não foi possível carregar as inspeções.',
      'cachedData': 'Exibindo os dados salvos no dispositivo.',
      'inspector': 'Inspetor',
      'equipment': 'Equipamento',
      'locationLabel': 'Local',
      'date': 'Data',
      'result': 'Resultado',
      'thermographic': 'Termográfica',
      'ultrasound': 'Ultrassom',
      'approved': 'Aprovado',
      'attention': 'Requer atenção',
      'rejected': 'Reprovado',
      'company': 'Nome da empresa',
      'location': 'Local',
      'register': 'Cadastrar',
      'required': 'Campo obrigatório',
      'success': 'Cadastro realizado com sucesso!',
      'activityTitle': 'Cadastro de atividade',
    },
    'en': <String, String>{
      'inspectionsTitle': 'Inspections',
      'activity': 'Register activity',
      'retry': 'Try again',
      'empty': 'No inspections found.',
      'loadError': 'Unable to load inspections.',
      'cachedData': 'Showing data saved on this device.',
      'inspector': 'Inspector',
      'equipment': 'Equipment',
      'locationLabel': 'Location',
      'date': 'Date',
      'result': 'Result',
      'thermographic': 'Thermographic',
      'ultrasound': 'Ultrasound',
      'approved': 'Approved',
      'attention': 'Requires attention',
      'rejected': 'Rejected',
      'company': 'Company name',
      'location': 'Location',
      'register': 'Register',
      'required': 'Required field',
      'success': 'Registration completed successfully!',
      'activityTitle': 'Activity registration',
    },
  };

  String text(String key) => _translations[locale.languageCode]?[key] ?? _translations['pt']![key] ?? key;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((Locale item) => item.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
