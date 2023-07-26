import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:dart_lnurl/src/lnurl.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  test('should handle bolt card lnurlw:// ', () async {
    final url =
        'lnurlw://lnbits.btcslovnik.cz/boltcards/api/v1/scan/wpyeilzhasqu8rgsmfqbv9?p=D13EFAAEC499E07F611B279BA3EE982C&c=DF6C74D375DF8300';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'https://lnbits.btcslovnik.cz/boltcards/api/v1/scan/wpyeilzhasqu8rgsmfqbv9?p=D13EFAAEC499E07F611B279BA3EE982C&c=DF6C74D375DF8300'));
  });
  test('should handle onion bolt card lnurlw:// ', () async {
    final url =
        'lnurlw://lnbits.btcslovnikxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/boltcards/api/v1/scan/wpyeilzhasqu8rgsmfqbv9?p=D13EFAAEC499E07F611B279BA3EE982C&c=DF6C74D375DF8300';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbits.btcslovnikxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/boltcards/api/v1/scan/wpyeilzhasqu8rgsmfqbv9?p=D13EFAAEC499E07F611B279BA3EE982C&c=DF6C74D375DF8300'));
  });
  test('should handle bolt card lnurlw:// with additional non-related prefix',
      () async {
    final url =
        'enlnurlw://lnbits.btcslovnik.cz/boltcards/api/v1/scan/wpyeilzhasqu8rgsmfqbv9?p=D13EFAAEC499E07F611B279BA3EE982C&c=DF6C74D375DF8300';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'https://lnbits.btcslovnik.cz/boltcards/api/v1/scan/wpyeilzhasqu8rgsmfqbv9?p=D13EFAAEC499E07F611B279BA3EE982C&c=DF6C74D375DF8300'));
  });
  test(
      'should handle onion bolt card lnurlw:// with additional non-related prefix',
      () async {
    final url =
        'enlnurlw://lnbits.btcslovnikxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/boltcards/api/v1/scan/wpyeilzhasqu8rgsmfqbv9?p=D13EFAAEC499E07F611B279BA3EE982C&c=DF6C74D375DF8300';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbits.btcslovnikxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/boltcards/api/v1/scan/wpyeilzhasqu8rgsmfqbv9?p=D13EFAAEC499E07F611B279BA3EE982C&c=DF6C74D375DF8300'));
  });

  test('should handle static lnurlw://', () async {
    final url = 'lnurlw://lnbits.cz/lnurlw/357';
    final res = parseLnUri(url);
    expect(res, Uri.parse('https://lnbits.cz/lnurlw/357'));
  });
  test('should handle static lnurlw with lightning:', () async {
    final url =
        'lightning:LNURL1DP68GURN8GHJ7MRWVF5HGUEWVF6XXURVV96XY7FWVDAZ7AMFW35XGUNPWUHKZURF9AMRZTMVDE6HYMP0GF8Y5V63FFX9WKT5FDTHXD3CVF9XG42DW9VSN09NNG';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'https://lnbits.btcplatby.cz/withdraw/api/v1/lnurl/BNJ3QJLWYtKWs68bJdUMqY'));
  });

  test(
      'should handle static lnurlw with lightning: and with additional non-related prefix',
      () async {
    final url =
        'enlightning:LNURL1DP68GURN8GHJ7MRWVF5HGUEWVF6XXURVV96XY7FWVDAZ7AMFW35XGUNPWUHKZURF9AMRZTMVDE6HYMP0GF8Y5V63FFX9WKT5FDTHXD3CVF9XG42DW9VSN09NNG';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'https://lnbits.btcplatby.cz/withdraw/api/v1/lnurl/BNJ3QJLWYtKWs68bJdUMqY'));
  });

  test('should handle static onion lnurlw with lightning:', () async {
    final url =
        'lightning:LNURL1DP68GUP69UHKCMNZD968XTNZW33HQMRPW338J7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC9EHKU6T0DCHHW6T5DPJ8YCTH9ASHQ6F0WCCJ7MRWW4EXCT6ZFE9RX522F3T4JAZT2AENVWRZFFJ92NT3TYXRL2DG';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbits.btcplatbyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/withdraw/api/v1/lnurl/BNJ3QJLWYtKWs68bJdUMqY'));
  });

  test(
      'should handle static onion lnurlw with lightning:  and with additional non-related prefix',
      () async {
    final url =
        'enlightning:LNURL1DP68GUP69UHKCMNZD968XTNZW33HQMRPW338J7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC0PU8S7RC9EHKU6T0DCHHW6T5DPJ8YCTH9ASHQ6F0WCCJ7MRWW4EXCT6ZFE9RX522F3T4JAZT2AENVWRZFFJ92NT3TYXRL2DG';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbits.btcplatbyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/withdraw/api/v1/lnurl/BNJ3QJLWYtKWs68bJdUMqY'));
  });

  test('should handle static onion lowercase lnurlw with lightning:', () async {
    final url =
        'lightning:lnurl1dp68gup69uhkcmnzd968xtnzw33hqmrpw338j7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc9ehku6t0dchhw6t5dpj8ycth9ashq6f0wccj7mrww4exct6zfe9rx522f3t4jazt2aenvwrzffj92nt3tyxrl2dg';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbits.btcplatbyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/withdraw/api/v1/lnurl/BNJ3QJLWYtKWs68bJdUMqY'));
  });

  test(
      'should handle static onion lowercase lnurlw with lightning and other non-related prefix:',
      () async {
    final url =
        'enlightning:lnurl1dp68gup69uhkcmnzd968xtnzw33hqmrpw338j7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc0pu8s7rc9ehku6t0dchhw6t5dpj8ycth9ashq6f0wccj7mrww4exct6zfe9rx522f3t4jazt2aenvwrzffj92nt3tyxrl2dg';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbits.btcplatbyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/withdraw/api/v1/lnurl/BNJ3QJLWYtKWs68bJdUMqY'));
  });

  test('should handle static lnurlw:// with additional non-related prefix',
      () async {
    final url = 'enlnurlw://lnbits.cz/lnurlw/357';
    final res = await parseLnUri(url);
    //expect(res.payParams?.tag, 'payRequest');
    expect(res, Uri.parse('https://lnbits.cz/lnurlw/357'));
  });
  test('should handle static onion lnurlw://', () async {
    final url =
        'lnurlw://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlw/357';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlw/357'));
  });
  test(
      'should handle static onion lnurlw:// with additional non-related prefix',
      () async {
    final url =
        'enlnurlw://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlw/357';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlw/357'));
  });

  test('should handle lnurlp://', () async {
    final url = 'lnurlp://lnbits.cz/lnurlp/357';
    final res = parseLnUri(url);
    expect(res, Uri.parse('https://lnbits.cz/lnurlp/357'));
  });
  test('should handle lnurlp:// with additional non-related prefix', () async {
    final url = 'enlnurlp://lnbits.cz/lnurlp/357';
    final res = await parseLnUri(url);
    //expect(res.payParams?.tag, 'payRequest');
    expect(res, Uri.parse('https://lnbits.cz/lnurlp/357'));
  });
  test('should handle onion lnurlp://', () async {
    final url =
        'lnurlp://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlp/357';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlp/357'));
  });
  test('should handle onion lnurlp:// with additional non-related prefix',
      () async {
    final url =
        'enlnurlp://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlp/357';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlp/357'));
  });

  test('should handle lnurlc://', () async {
    final url = 'lnurlc://lnbits.cz/lnurlc/357';
    final res = parseLnUri(url);
    expect(res, Uri.parse('https://lnbits.cz/lnurlc/357'));
  });
  test('should handle lnurlc:// with additional non-related prefix', () async {
    final url = 'enlnurlc://lnbits.cz/lnurlc/357';
    final res = await parseLnUri(url);
    //expect(res.payParams?.tag, 'payRequest');
    expect(res, Uri.parse('https://lnbits.cz/lnurlc/357'));
  });
  test('should handle onion lnurlc://', () async {
    final url =
        'lnurlc://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlc/357';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlc/357'));
  });
  test('should handle onion lnurlc:// with additional non-related prefix',
      () async {
    final url =
        'enlnurlc://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlc/357';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/lnurlc/357'));
  });

  test('should handle keyauth://', () async {
    final url = 'keyauth://lnbits.cz/keyauth/357';
    final res = parseLnUri(url);
    expect(res, Uri.parse('https://lnbits.cz/keyauth/357'));
  });
  test('should handle keyauth:// with additional non-related prefix', () async {
    final url = 'enkeyauth://lnbits.cz/keyauth/357';
    final res = await parseLnUri(url);
    //expect(res.payParams?.tag, 'payRequest');
    expect(res, Uri.parse('https://lnbits.cz/keyauth/357'));
  });
  test('should handle onion keyauth://', () async {
    final url =
        'keyauth://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/keyauth/357';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/keyauth/357'));
  });
  test('should handle onion keyauth:// with additional non-related prefix',
      () async {
    final url =
        'enkeyauth://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/keyauth/357';
    final res = parseLnUri(url);
    expect(
        res,
        Uri.parse(
            'http://lnbitsxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.onion/keyauth/357'));
  });

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

  test('should parse lnurl-pay', () async {
    final url =
        'lightning:LNURL1DP68GURN8GHJ7MRWW4EXCTNZD9NHXATW9EU8J730D3H82UNV94CXZ7FLWDJHXUMFDAHR6C3NXGCNGCEE8YEX2CFHXCCRYCNXXUENVEFHXQCR2EF5XS6R2D35XUERSEFC8YCKGDF5XAJNGCTX8PJRYVP4XDJNVD3CX3NRVEFCX4SSWRA86F';
    final res = parseLnUri(url);
    expect(res, isNotNull);
  });

  test('should parse lnurl without lightning:', () {
    final lnurl =
        'lnurl1dp68gurn8ghj7mrww4exctt5dahkccn00qhxget8wfjk2um0veax2un09e3k7mf0w5lhz0t9xcekzv34vgcx2vfkvcurxwphvgcrwefjvgcnqwrpxqmkxven89skgvp3vs6nwvpjvy6njdfsx5ekgephvcurxdf5xcerwvecvyunsf32lqq';
    expect(
        parseLnUri(lnurl),
        Uri.parse(
            'https://lnurl-toolbox.degreesofzero.com/u?q=e63a25b0e16f8387b07e2b108a07c339ad01d5702a595053dd7f835462738a98'));
  });

  test('should parse lnurl with lightning:', () {
    final lnurl =
        'lightning:lnurl1dp68gurn8ghj7mrww4exctt5dahkccn00qhxget8wfjk2um0veax2un09e3k7mf0w5lhz0t9xcekzv34vgcx2vfkvcurxwphvgcrwefjvgcnqwrpxqmkxven89skgvp3vs6nwvpjvy6njdfsx5ekgephvcurxdf5xcerwvecvyunsf32lqq';
    expect(
        parseLnUri(lnurl),
        Uri.parse(
            'https://lnurl-toolbox.degreesofzero.com/u?q=e63a25b0e16f8387b07e2b108a07c339ad01d5702a595053dd7f835462738a98'));
  });

  test('should parse LNURL without lightning:', () {
    final lnurl =
        'lightning:LNURL1DP68GURN8GHJ7MRWW4EXCTT5DAHKCCN00QHXGET8WFJK2UM0VEAX2UN09E3K7MF0W5LHZ0T9XCEKZV34VGCX2VFKVCURXWPHVGCRWEFJVGCNQWRPXQMKXVEN89SKGVP3VS6NWVPJVY6NJDFSX5EKGEPHVCURXDF5XCERWVECVYUNSF32LQQ';
    expect(
        parseLnUri(lnurl),
        Uri.parse(
            'https://lnurl-toolbox.degreesofzero.com/u?q=e63a25b0e16f8387b07e2b108a07c339ad01d5702a595053dd7f835462738a98'));
  });

  test('should parse LNURL with lightning:', () {
    final lnurl =
        'lightning:LNURL1DP68GURN8GHJ7MRWW4EXCTT5DAHKCCN00QHXGET8WFJK2UM0VEAX2UN09E3K7MF0W5LHZ0T9XCEKZV34VGCX2VFKVCURXWPHVGCRWEFJVGCNQWRPXQMKXVEN89SKGVP3VS6NWVPJVY6NJDFSX5EKGEPHVCURXDF5XCERWVECVYUNSF32LQQ';
    expect(
        parseLnUri(lnurl),
        Uri.parse(
            'https://lnurl-toolbox.degreesofzero.com/u?q=e63a25b0e16f8387b07e2b108a07c339ad01d5702a595053dd7f835462738a98'));
  });
}
