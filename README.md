# aichat

An ai chat for flutter.

## Supported Platforms

| Platform              | Support            |
| --------------------- | ------------------ |
| Android               | :heavy_check_mark: |
| IOS                   | :heavy_check_mark: |
| MacOS                 | :heavy_check_mark: |
| Windows               | :heavy_check_mark: |
| Linux                 | :heavy_check_mark: |
| Web                   | :x:                |

## Getting Started

- Create new brain in (brainshop)[https://brainshop.ai/brain/new]
- Get Brain ID and API key
- Create secrets.dart file in lib/ folder
- secrets.dart content:

```
class Secrets {
  static String get brainShopBrainID => "your_brain_id";
  static String get brainShopApiKey => "your_brain_shop_api_key";


  // For checking updates from github.
  // Your release names should ends with your app version for this. Example release name: v0.3.8
  static String get githubReleaseBranch => "master"; // Your release branch name.
  
  static String get githubToken => "your_github_token";
  // Get token from here: https://github.com/settings/tokens?type=beta

  static String get githubRepoPath => "github-username/github-project-name";
  // Example: static String get githubRepoPath => "ozayakcan/ai-chat-flutter";


  // 16 bit, base64 string
  // You can use this site to generate keys: https://generate.plus/en/base64
  static String get encrpytionKey => "your_16_bit_base64_key";
  static String get encrpytionIV => "your_16_bit_base64_iv";
}
```

### Renaming App

```
// Activate Plugin
flutter pub global activate rename

// Change package
flutter pub global run rename --bundleId your.package.name

// Change app name
flutter pub global run rename --appname "Your App Name"

// For single platform (Same usage with --bundleId)
flutter pub global run rename --appname YourAppName --target ios
flutter pub global run rename --appname YourAppName --target android
flutter pub global run rename --appname YourAppName --target web
flutter pub global run rename --appname YourAppName --target macOS
flutter pub global run rename --appname YourAppName --target windows
```

- App name not changing properly on windows. You should manually change it.
- Open windows/runner/main.cpp
- Find this lines and change "AI Chat" with your app name.

```
  if (!window.Create(L"AI Chat", origin, size)) {
    return EXIT_FAILURE;
  }
```

### Android

- Add this to android/local.properties

```
flutter.minSdkVersion=21
```

- Create android/key.properties file & add this lines & edit it for your keystore.jks properties:

```
releaseStorePassword=your-store-password
releaseKeyPassword=your-key-password
releaseKeyAlias=your-alias
# Copy your keystore.jks file to root-project-folder/android/keystore.jks
releaseStoreFile=../keystore.jks
debugStorePassword=android
debugKeyPassword=android
debugKeyAlias=androiddebugkey
# Replace UserFolder with your user folder name
debugStoreFile=C:\\Users\\UserFolder\\.android\\debug.keystore
```

### Building

- Command (Replace [platform] strings with your build platform without square brackets)

```
flutter build [platform] --release --obfuscate --split-debug-info=build\debug-info-[platform]
```