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

  // 16 bit, base64 string
  // You can use this site to generate keys: https://generate.plus/en/base64
  static String get encrpytionKey => "your_16_bit_base64_key";
  static String get encrpytionIV => "your_16_bit_base64_iv";
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
debugStoreFile=C:\\Users\\OzayAkcan\\.android\\debug.keystore
```

### Building

- Command (Replace [platform] strings with your build platform without square brackets)

```
flutter build [platform] --release --obfuscate --split-debug-info=build\debug-info-[platform]
```