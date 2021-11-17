import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:dart_lnurl/src/types.dart';
import 'package:encrypt/encrypt.dart';

/// Given a success action, will return the decrypted AES payload.
/// The preimage is the key to decrypt the data.
decryptSuccessActionAesPayload({
  required LNURLPaySuccessAction successAction,
  required String preimage,
}) {
  if (successAction.tag != 'aes') {
    return '';
  }

  final key = Key.fromBase16(preimage);
  final iv = IV.fromBase16(successAction.iv);
  final encrypter = Encrypter(
    AES(
      key,
      mode: AESMode.cbc,
    ),
  );

  final plainText = encrypter.decrypt(
    Encrypted.fromBase16(successAction.cipherText),
    iv: iv,
  );

  return plainText;
}
