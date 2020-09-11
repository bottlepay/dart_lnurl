import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:dart_lnurl/src/lnurl.dart';
import 'package:dart_lnurl/src/types.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

void main() {
  test('should match lnurl without lightning:', () {
    final lnurl =
        'lnurl1dp68gurn8ghj7mrww4exctt5dahkccn00qhxget8wfjk2um0veax2un09e3k7mf0w5lhz0t9xcekzv34vgcx2vfkvcurxwphvgcrwefjvgcnqwrpxqmkxven89skgvp3vs6nwvpjvy6njdfsx5ekgephvcurxdf5xcerwvecvyunsf32lqq';
    expect(findLnUrl(lnurl),
        'lnurl1dp68gurn8ghj7mrww4exctt5dahkccn00qhxget8wfjk2um0veax2un09e3k7mf0w5lhz0t9xcekzv34vgcx2vfkvcurxwphvgcrwefjvgcnqwrpxqmkxven89skgvp3vs6nwvpjvy6njdfsx5ekgephvcurxdf5xcerwvecvyunsf32lqq');
  });

  test('should match lnurl with lightning:', () {
    final lnurl =
        'lightning:lnurl1dp68gurn8ghj7mrww4exctt5dahkccn00qhxget8wfjk2um0veax2un09e3k7mf0w5lhz0t9xcekzv34vgcx2vfkvcurxwphvgcrwefjvgcnqwrpxqmkxven89skgvp3vs6nwvpjvy6njdfsx5ekgephvcurxdf5xcerwvecvyunsf32lqq';
    expect(findLnUrl(lnurl),
        'lnurl1dp68gurn8ghj7mrww4exctt5dahkccn00qhxget8wfjk2um0veax2un09e3k7mf0w5lhz0t9xcekzv34vgcx2vfkvcurxwphvgcrwefjvgcnqwrpxqmkxven89skgvp3vs6nwvpjvy6njdfsx5ekgephvcurxdf5xcerwvecvyunsf32lqq');
  });

  test('should fail matching lnurl on invalid string', () {
    expect(() => findLnUrl('invalid string'), throwsArgumentError);
  });

  test('should decipher preimage', () {
    final plainText = 'Secret message here';

    final preimage =
        '43aa9346163deada83ec49fa670b8a3541c9ef469d942cd2c7f81206e535e031';

    /// Encrypt some data using the preimage as the key
    final data = encrypt(plainText, preimage);

    final decrypted = decryptSuccessActionAesPayload(
      preimage: preimage,
      successAction: LNURLPaySuccessAction.fromJson({
        'cipherText': data.cipherText,
        'iv': data.iv,
        'tag': 'aes',
      }),
    );
    expect(decrypted, plainText);
  });

  test('should decode lnurl-pay', () async {
    final url =
        'lightning:LNURL1DP68GURN8GHJ7MRWW4EXCTNZD9NHXATW9EU8J730D3H82UNV94CXZ7FLWDJHXUMFDAHR6C3NXGCNGCEE8YEX2CFHXCCRYCNXXUENVEFHXQCR2EF5XS6R2D35XUERSEFC8YCKGDF5XAJNGCTX8PJRYVP4XDJNVD3CX3NRVEFCX4SSWRA86F';
    final res = await getParams(url);
    expect(res.payParams, isNotNull);
  });
}
