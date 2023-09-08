class GithubAssetsModel {
  final String url;
  final int id;
  final String nodeId;
  final String name;
  //final String label; // is null
  final String contentType;
  final String state;
  final int size;
  final int downloadCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String browserDownloadUrl;

  static String urlStr = "url";
  static String idStr = "id";
  static String nodeIdStr = "node_id";
  static String nameStr = "name";
  static String labelStr = "label";
  static String contentTypeStr = "content_type";
  static String stateStr = "state";
  static String sizeStr = "size";
  static String downloadCountStr = "download_count";
  static String createdAtStr = "created_at";
  static String updatedAtStr = "updated_at";
  static String browserDownloadUrlStr = "browser_download_url";

  GithubAssetsModel._({
    required this.url,
    required this.id,
    required this.nodeId,
    required this.name,
    required this.contentType,
    required this.state,
    required this.size,
    required this.downloadCount,
    required this.createdAt,
    required this.updatedAt,
    required this.browserDownloadUrl,
  });

  static GithubAssetsModel fromJson(Map data) {
    return GithubAssetsModel._(
      url: (data[urlStr] as String?) ?? "",
      id: (data[idStr] as int?) ?? 0,
      nodeId: (data[nodeIdStr] as String?) ?? "",
      name: (data[nameStr] as String?) ?? "",
      contentType: (data[contentTypeStr] as String?) ?? "",
      state: (data[stateStr] as String?) ?? "",
      size: (data[sizeStr] as int?) ?? 0,
      downloadCount: (data[downloadCountStr] as int?) ?? 0,
      createdAt: DateTime.parse(
          (data[createdAtStr] as String?) ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          (data[updatedAtStr] as String?) ?? DateTime.now().toIso8601String()),
      browserDownloadUrl: (data[browserDownloadUrlStr] as String?) ?? "",
    );
  }

  Map toJson() {
    return {
      urlStr: url,
      idStr: id,
      nodeIdStr: nodeId,
      nameStr: name,
      contentTypeStr: contentType,
      stateStr: state,
      sizeStr: size,
      downloadCountStr: downloadCount,
      createdAtStr: createdAt.toIso8601String(),
      updatedAtStr: updatedAt.toIso8601String(),
      browserDownloadUrlStr: browserDownloadUrl,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class GithubReleaseModel {
  final String url;
  final String assetsUrl;
  final String uploadUrl;
  final String htmlUrl;
  final int id;
  final String nodeId;
  final String tagName;
  final String targetCommitish;
  final String name;
  final bool draft;
  final bool prerelease;
  final DateTime createdAt;
  final DateTime publishedAt;
  final List<GithubAssetsModel> assets;
  final String tarballUrl;
  final String zipballUrl;
  final String body;

  static String urlStr = "url";
  static String assetsUrlStr = "assets_url";
  static String uploadUrlStr = "upload_url";
  static String htmlUrlStr = "html_url";
  static String idStr = "id";
  static String nodeIdStr = "node_id";
  static String tagNameStr = "tag_name";
  static String targetCommitishStr = "target_commitish";
  static String nameStr = "name";
  static String draftStr = "draft";
  static String prereleaseStr = "prerelease";
  static String createdAtStr = "created_at";
  static String publishedAtStr = "published_at";
  static String assetsStr = "assets";
  static String tarballUrlStr = "tarball_url";
  static String zipballUrlStr = "zipball_url";
  static String bodyStr = "body";
  GithubReleaseModel._({
    required this.url,
    required this.assetsUrl,
    required this.uploadUrl,
    required this.htmlUrl,
    required this.id,
    required this.nodeId,
    required this.tagName,
    required this.targetCommitish,
    required this.name,
    required this.draft,
    required this.prerelease,
    required this.createdAt,
    required this.publishedAt,
    required this.assets,
    required this.tarballUrl,
    required this.zipballUrl,
    required this.body,
  });

  static GithubReleaseModel fromJson(Map data) {
    List assetList = (data[assetsStr] as List?) ?? List.empty();
    return GithubReleaseModel._(
      url: (data[urlStr] as String?) ?? "",
      assetsUrl: (data[assetsUrlStr] as String?) ?? "",
      uploadUrl: (data[uploadUrlStr] as String?) ?? "",
      htmlUrl: (data[htmlUrlStr] as String?) ?? "",
      id: (data[idStr] as int?) ?? 0,
      nodeId: (data[nodeIdStr] as String?) ?? "",
      tagName: (data[tagNameStr] as String?) ?? "",
      targetCommitish: (data[targetCommitishStr] as String?) ?? "",
      name: (data[nameStr] as String?) ?? "",
      draft: (data[draftStr] as bool?) ?? false,
      prerelease: (data[prereleaseStr] as bool?) ?? false,
      createdAt: DateTime.parse(
          (data[createdAtStr] as String?) ?? DateTime.now().toIso8601String()),
      publishedAt: DateTime.parse((data[publishedAtStr] as String?) ??
          DateTime.now().toIso8601String()),
      assets: assetList.map((e) => GithubAssetsModel.fromJson(e)).toList(),
      tarballUrl: (data[tarballUrlStr] as String?) ?? "",
      zipballUrl: (data[zipballUrlStr] as String?) ?? "",
      body: (data[bodyStr] as String?) ?? "",
    );
  }

  Map toJson() {
    return {
      urlStr: url,
      assetsUrlStr: assetsUrl,
      uploadUrlStr: uploadUrl,
      htmlUrlStr: htmlUrl,
      idStr: id,
      nodeIdStr: nodeId,
      tagNameStr: tagName,
      targetCommitishStr: targetCommitish,
      nameStr: name,
      draftStr: draft,
      prereleaseStr: prerelease,
      createdAtStr: createdAt,
      publishedAtStr: publishedAt,
      assetsStr: assets,
      tarballUrlStr: tarballUrl,
      zipballUrlStr: zipballUrl,
      bodyStr: body,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
