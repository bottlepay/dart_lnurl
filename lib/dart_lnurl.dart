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
  /// The URL can possibily be already decoded as per LUD-17: Protocol schemes and raw (non bech32-encoded) URLs.
  /// https://github.com/lnurl/luds/blob/luds/17.md
  /// Handle already decoded LNURL if they start with defined prefixes
  var lud17prefixes = ['lnurlw://', 'lnurlc://', 'lnurlp://', 'keyauth://'];
  late final Uri decodedUri;

  /// If the decoded LNURL is a Tor address, the port has to be http instead of https for the clearnet LNURL so check the .onion in URL also
  var protocol = (encodedUrl.contains('.onion') && !encodedUrl.contains('.onion.')) ? 'http://' : 'https://';
  var urlprefix = "";
  for (var prefix in lud17prefixes){
     if (encodedUrl.startsWith(prefix)) {
        urlprefix = prefix;
     }
  }
  if (encodedUrl.startsWith(urlprefix)) {
    /// Already decoded LNURL so just return a string starting with http or https (LUD-17 compatibility)
    decodedUri = Uri.parse(encodedUrl.replaceFirst(urlprefix, protocol));
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
