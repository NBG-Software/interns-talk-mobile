import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String LANGUAGE_CODE = 'languageCode';
const String ENGLISH = 'en';
const String BURMESE = 'my';

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}
