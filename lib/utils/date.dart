import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getDateString(BuildContext context, DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final aDate = DateTime(date.year, date.month, date.day);
  AppLocalizations appLocalizations = AppLocalizations.of(context);
  return aDate == today
      ? appLocalizations.today
      : (aDate == yesterday
          ? appLocalizations.yesterday
          : DateFormat(appLocalizations.date_format).format(date));
}
