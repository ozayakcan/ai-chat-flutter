import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getDateString(BuildContext context, DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final aDate = DateTime(date.year, date.month, date.day);
  return aDate == today
      ? AppLocalizations.of(context).today
      : (aDate == yesterday
          ? AppLocalizations.of(context).yesterday
          : DateFormat(AppLocalizations.of(context).date_format).format(date));
}
