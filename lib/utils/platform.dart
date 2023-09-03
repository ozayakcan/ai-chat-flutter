import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

enum Platforms {
  none,
  mobile,
  desktop,
  web,
}

class ThisPlatform {
  static Platforms get get {
    bool isMobile = (Platform.isAndroid || Platform.isIOS);
    bool isDesktop =
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
    return kIsWeb
        ? Platforms.web
        : (isMobile
            ? Platforms.mobile
            : (isDesktop ? Platforms.desktop : Platforms.none));
  }
}
