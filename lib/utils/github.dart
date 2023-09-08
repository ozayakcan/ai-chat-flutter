import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/github.dart';
import '../secrets.dart';
import '../widgets/dialogs.dart';
import '../widgets/widgets.dart';

class Github {
  static String get _apiUrl => "https://api.github.com";
  static String get _repoUrl => "$_apiUrl/repos/${Secrets.githubRepoPath}";
  static String get _releaseUrl => "$_repoUrl/releases";

  static Future<List<GithubReleaseModel>?> listReleases() async {
    var dio = Dio();
    var response = await dio.get(
      _releaseUrl,
      options: Options(
        contentType: "application/json; charset=UTF-8",
        headers: {
          "Authorization": "Bearer ${Secrets.githubToken}",
          "Accept": "application/vnd.github+json",
          "X-GitHub-Api-Version": "2022-11-28",
        },
      ),
    );
    if (response.statusCode == 200) {
      List<GithubReleaseModel> releases = (response.data as List)
          .map((e) => GithubReleaseModel.fromJson(e))
          .where((element) =>
              !element.prerelease &&
              element.targetCommitish == Secrets.githubReleaseBranch)
          .toList();
      return releases;
    } else {
      return null;
    }
  }

  static Future checkUpdates(
    BuildContext context, {
    required String version,
  }) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    MyAlertDialog myAlertDialog = MyAlertDialog.of(context);
    ScaffoldSnackbar scaffoldSnackbar = ScaffoldSnackbar.of(context);
    List<GithubReleaseModel> gitReleases =
        await Github.listReleases() ?? List.empty();
    if (gitReleases.isNotEmpty) {
      GithubReleaseModel currentRelease =
          gitReleases.where((element) => element.name.endsWith(version)).first;
      GithubReleaseModel latestRelease = gitReleases.reduce((curr, next) =>
          curr.publishedAt.microsecondsSinceEpoch >
                  next.publishedAt.microsecondsSinceEpoch
              ? curr
              : next);
      if (currentRelease.name != latestRelease.name) {
        myAlertDialog.show(
            title: appLocalizations.update_available,
            description: appLocalizations.update_available_desc,
            descriptionWidgetTopMargin: 10,
            descriptionWidget: RichText(
              text: TextSpan(
                children: [
                  for (var rlAsset in latestRelease.assets)
                    TextSpan(
                      text: appLocalizations.text_new_line(rlAsset.name),
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          if (!await launchUrl(
                              Uri.parse(rlAsset.browserDownloadUrl))) {
                            if (kDebugMode) {
                              print(
                                  "Could not launch url: ${rlAsset.browserDownloadUrl}");
                            }
                            await Clipboard.setData(
                              ClipboardData(
                                text: rlAsset.browserDownloadUrl,
                              ),
                            );
                            scaffoldSnackbar.show(appLocalizations.link_copied);
                          }
                        },
                    )
                ],
              ),
            ),
            barrierDismissible: false,
            actions: [
              TextButton(
                onPressed: () async {
                  if (!await launchUrl(Uri.parse(latestRelease.htmlUrl))) {
                    if (kDebugMode) {
                      print("Could not launch url: ${latestRelease.htmlUrl}");
                    }
                    await Clipboard.setData(
                      ClipboardData(
                        text: latestRelease.htmlUrl,
                      ),
                    );
                    scaffoldSnackbar.show(appLocalizations.link_copied);
                  }
                },
                child: Text(appLocalizations.go_release_page),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(appLocalizations.close),
              ),
            ]);
      }
    }
  }
}
