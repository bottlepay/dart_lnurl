library dart_lnurl;

import 'dart:async';
import 'dart:convert';

import 'package:bech32/bech32.dart';
import 'package:dart_lnurl/src/bech32.dart';
import 'package:dart_lnurl/src/lnurl.dart';
import 'package:dart_lnurl/src/types.dart';
import 'package:http/http.dart' as http;

export 'src/types.dart';
export 'src/success_action.dart';
export 'src/bech32.dart';

/// Get params from a lnurl string. Possible types are:
/// * `LNURLResponse`
/// * `LNURLChannelParams`
/// * `LNURLWithdrawParams`
/// * `LNURLAuthParams`
/// * `LNURLPayParams`
///
/// If [timeout] is provided, then [TimeoutException] is being thrown
/// when request does not complete within specified timeout.
///
/// Throws [ArgumentError] if the provided input is not a valid lnurl.
Future<LNURLParseResult> getParams(String encodedUrl, {Duration? timeout}) async {
  /// Try to parse the input as a lnUrl. Will throw an error if it fails.
  final lnUrl = findLnUrl(encodedUrl);

  /// Decode the lnurl using bech32
  final bech32 = Bech32Codec().decode(lnUrl, lnUrl.length);
  final decodedUri = Uri.parse(utf8.decode(fromWords(bech32.data)));

  try {
    /// Call the lnurl to get a response
    final call = http.get(decodedUri);
    final res = await (timeout == null ? call : call.timeout(timeout));

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
  } on TimeoutException {
    rethrow;
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
