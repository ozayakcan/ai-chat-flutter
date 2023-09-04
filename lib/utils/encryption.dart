import 'package:encrypt/encrypt.dart';

import '../secrets.dart';

class Encryption {
  static String encrypt(String text) {
    var key = Key.fromBase64(Secrets.encrpytionKey);
    var iv = IV.fromBase64(Secrets.encrpytionIV);
    final encrypter = Encrypter(AES(key));

    return encrypter.encrypt(text, iv: iv).base64;
  }

  static String decrypt(String encryptedTex) {
    var key = Key.fromBase64(Secrets.encrpytionKey);
    var iv = IV.fromBase64(Secrets.encrpytionIV);
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(Encrypted.fromBase64(encryptedTex), iv: iv);
  }
}
