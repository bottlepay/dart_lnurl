import 'package:bech32/bech32.dart';

/// Parse and return a given lnurl string if it's valid. Will remove
/// `lightning:` from the beginning of it if present.
String findLnUrl(String input) {
  final res = new RegExp(
    r',*?((lnurl)([0-9]{1,}[a-z0-9]+){1})',
  ).allMatches(input.toLowerCase());

  if (res.length == 1) {
    return res.first.group(0)!;
  } else {
    throw ArgumentError('Not a valid lnurl string');
  }
}

String findLnUrlNonBech32(String input) {
  /// The URL doesn't have to be encoded at all as per LUD-17: Protocol schemes and raw (non bech32-encoded) URLs.
  /// https://github.com/lnurl/luds/blob/luds/17.md
  /// Handle non bech32-encoded LNURL

  final lud17prefixes = ['lnurlw', 'lnurlp', 'keyauth', 'lnurlc'];
  Uri decodedUri = Uri.parse(input);
  for (final prefix in lud17prefixes) {
    if (decodedUri.scheme.contains(prefix)) {
      decodedUri = decodedUri.replace(scheme: prefix);
      break;
    }
  }
  if (lud17prefixes.contains(decodedUri.scheme)) {
    /// If the non-bech32 LNURL is a Tor address, the port has to be http instead of https for the clearnet LNURL so check if the host ends with '.onion' or '.onion.'
    decodedUri = decodedUri.replace(
        scheme: decodedUri.host.endsWith('onion') ||
                decodedUri.host.endsWith('onion.')
            ? 'http'
            : 'https');
  }
  return decodedUri.toString();
}

bool isbech32(String input) {
  final match = new RegExp(
    r',*?((lnurl)([0-9]{1,}[a-z0-9]+){1})',
  ).allMatches(input.toLowerCase());
  if (match.length == 1) {
    print(match.first.group(0));
    // get the lnurl string from the regex
    String lnurlBech32 = match.first.group(0)!;
    String lnurlDecoded = '';
    try {
      // try to decode lowercased bech32 and store it to
      lnurlDecoded = Bech32Codec()
          .decode(lnurlBech32.toLowerCase(), lnurlBech32.length)
          .toString();
    } catch (e) {
      throw ArgumentError('Error when decoding bech32 lnurl');
    }
    if (!lnurlDecoded.isNotEmpty) {
      return true;
    }
  }
  return false;
}
