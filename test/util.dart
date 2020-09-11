import 'package:encrypt/encrypt.dart';

/// Utility function for encrypting data using a given key.
EncryptedResult encrypt(String plainText, String key) {
  final k = Key.fromBase16(key);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(k, mode: AESMode.cbc));
  final cipherText = encrypter.encrypt(plainText, iv: iv);
  return EncryptedResult()
    ..iv = iv.base16
    ..cipherText = cipherText.base16;
}

/// Holds an encryption result
class EncryptedResult {
  String iv;
  String cipherText;
}
