import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:dart_lnurl/src/lnurl.dart';
import 'package:flutter_test/flutter_test.dart';

import 'util.dart';

void main() async {
  group('Tests for "findLnUrl"', () {
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
        'description': '', //test fails without it
        'url': '', //test fails without it
        'message': '', //test fails without it
      }),
    );
    expect(decrypted, plainText);
  });

  group('Tests for "getParams"', () {
    test('should decode lnurl-pay', () async {
      final url =
          'lightning:LNURL1DP68GURN8GHJ7MRWW4EXCTNZD9NHXATW9EU8J730D3H82UNV94CXZ7FLWDJHXUMFDAHR6C3NXGCNGCEE8YEX2CFHXCCRYCNXXUENVEFHXQCR2EF5XS6R2D35XUERSEFC8YCKGDF5XAJNGCTX8PJRYVP4XDJNVD3CX3NRVEFCX4SSWRA86F';
      final res = await getParams(url);
      expect(res.payParams, isNotNull);
    }, skip: true); //domain https://lnurl.bigsun.xyz/lnurl-pay?session=b3214c992ea7602bf736e7005e444564728e891d547e4af8d2053e6684f6e85a can not be found

    test('should interrupt after timeout', () async {
      final notExistingUrl = 'lnurl1dp68gurn8ghj7etcv9khqmr99e3k7mf0d3h82unvq257ls';
      final res = await getParams(notExistingUrl, timeout: Duration(milliseconds: 10));

      expect(res.error, isNotNull);
      expect(res.error?.reason, 'https://example.com/lnurl returned error: TimeoutException after 0:00:00.010000: Future not completed');
    });
  });
}
