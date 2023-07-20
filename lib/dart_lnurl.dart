library dart_lnurl;

import 'dart:convert';

import 'package:bech32/bech32.dart';
import 'package:dart_lnurl/src/bech32.dart';
import 'package:dart_lnurl/src/lnurl.dart';
import 'package:dart_lnurl/src/types.dart';
import 'package:http/http.dart' as http;

export 'src/types.dart';
export 'src/success_action.dart';
export 'src/bech32.dart';

Uri decodeUri(String encodedUrl) {
  late final Uri decodedUri;

  /// The URL doesn't have to be encoded at all as per LUD-17: Protocol schemes and raw (non bech32-encoded) URLs.
  /// https://github.com/lnurl/luds/blob/luds/17.md
  /// Handle non bech32-encoded LNURL
  final lud17prefixes = ['lnurlw', 'lnurlc', 'lnurlp', 'keyauth'];
  final urifromstring = Uri.parse(encodedUrl);
  if (lud17prefixes.contains(urifromstring.scheme)) {
    /// If the non-bech32 LNURL is a Tor address, the port has to be http instead of https for the clearnet LNURL so check if the host ends with '.onion' or '.onion.'
    final protocol = urifromstring.host.endsWith('onion.') ||
            urifromstring.host.endsWith('onion')
        ? 'http'
        : 'https';

    /// Non-bech32 LNURL so just return a string starting with http or https (LUD-17 compatibility) instead of the lud17 prefix
    decodedUri =
        Uri.parse(encodedUrl.replaceFirst(urifromstring.scheme, protocol));
  } else {
    /// Try to parse the input as a lnUrl. Will throw an error if it fails.
    final lnUrl = findLnUrl(encodedUrl);

    /// Decode the lnurl using bech32
    final bech32 = Bech32Codec().decode(lnUrl, lnUrl.length);
    decodedUri = Uri.parse(utf8.decode(fromWords(bech32.data)));
  }
  return decodedUri;
}

/// Get params from a lnurl string. Possible types are:
/// * `LNURLResponse`
/// * `LNURLChannelParams`
/// * `LNURLWithdrawParams`
/// * `LNURLAuthParams`
/// * `LNURLPayParams`
///
/// Throws [ArgumentError] if the provided input is not a valid lnurl.
Future<LNURLParseResult> getParams(String encodedUrl) async {
  final decodedUri = decodeUri(encodedUrl);
  try {
    /// Call the lnurl to get a response
    final res = await http.get(decodedUri);

    /// If there's an error then throw it
    if (res.statusCode >= 300) {
      throw res.body;
    }

    /// Parse the response body to json
    Map<String, dynamic> parsedJson = json.decode(res.body);

    /// If it contains a callback then add the domain as a key
    if (parsedJson['callback'] != null) {
      parsedJson['domain'] = Uri.parse(parsedJson['callback']).host;
    }

    if (parsedJson['tag'] == null) {
      throw Exception('Response was missing a tag');
    }

    switch (parsedJson['tag']) {
      case 'withdrawRequest':
        return LNURLParseResult(
          withdrawalParams: LNURLWithdrawParams.fromJson(parsedJson),
        );

      case 'payRequest':
        return LNURLParseResult(
          payParams: LNURLPayParams.fromJson(parsedJson),
        );

      case 'channelRequest':
        return LNURLParseResult(
          channelParams: LNURLChannelParams.fromJson(parsedJson),
        );

      case 'login':
        return LNURLParseResult(
          authParams: LNURLAuthParams.fromJson(parsedJson),
        );

      default:
        if (parsedJson['status'] == 'ERROR') {
          return LNURLParseResult(
            error: LNURLErrorResponse.fromJson({
              ...parsedJson,
              ...{
                'domain': decodedUri.host,
                'url': decodedUri.toString(),
              }
            }),
          );
        }

        throw Exception('Unknown tag: ${parsedJson['tag']}');
    }
  } catch (e) {
    return LNURLParseResult(
      error: LNURLErrorResponse.fromJson({
        'status': 'ERROR',
        'reason': '${decodedUri.toString()} returned error: ${e.toString()}',
        'url': decodedUri.toString(),
        'domain': decodedUri.host,
      }),
    );
  }
}
