# aichat

An ai chat for flutter.

## Getting Started

- Create new brain in (brainshop)[https://brainshop.ai/brain/new]
- Get Brain ID and API key
- Create secrets.dart file in lib/ folder
- secrets.dart content:

```
class Secrets {
  static String get brainShopBrainID => "your_brain_id";
  static String get brainShopApiKey => "your_brain_shop_api_key";
}
```