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

Uri parseLnUri(String input) {
  Uri parsedUri;
  //Handle the cases when Uri doesn't have to be bech32 encoded, as per LUD-17
  if (!isbech32(input)) {
    /// Non-Bech32 encoded URL
    final String lnUrl = findLnUrlNonBech32(input);
    parsedUri = Uri.parse(lnUrl);
  } else {
    /// Bech32 encoded URL
    /// Try to parse the input as a lnUrl. Will throw an error if it fails.
    final lnUrl = findLnUrl(input);

    /// Decode the lnurl using bech32
    final bech32 = Bech32Codec().decode(lnUrl, lnUrl.length);
    parsedUri = Uri.parse(utf8.decode(fromWords(bech32.data)));
  }
  return parsedUri;
}

/// Get params from a lnurl string. Possible types are:
/// * `LNURLResponse`
/// * `LNURLChannelParams`
/// * `LNURLWithdrawParams`
/// * `LNURLAuthParams`
/// * `LNURLPayParams`
///
/// Throws [ArgumentError] if the provided input is not a valid lnurl.
Future<LNURLParseResult> getParams(String url) async {
  final parsedUri = parseLnUri(url);
  try {
    /// Call the lnurl to get a response
    final res = await http.get(parsedUri);

    /// If there's an error then throw it
    if (res.statusCode >= 300) {
      throw res.body;
    }

    /// Parse the response body to json
    Map<String, dynamic> parsedJson = json.decode(res.body);

    if (parsedJson['status'] == 'ERROR') {
      return LNURLParseResult(
        error: LNURLErrorResponse.fromJson({
          ...parsedJson,
          ...{
            'domain': parsedUri.host,
            'url': parsedUri.toString(),
          }
        }),
      );
    }

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
                'domain': parsedUri.host,
                'url': parsedUri.toString(),
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
        'reason': '${parsedUri.toString()} returned error: ${e.toString()}',
        'url': parsedUri.toString(),
        'domain': parsedUri.host,
      }),
    );
  }
}
