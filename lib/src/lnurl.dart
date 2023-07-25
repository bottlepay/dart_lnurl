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
  Uri parsedUri = Uri.parse(input);
  for (final prefix in lud17prefixes) {
    if (parsedUri.scheme.contains(prefix)) {
      parsedUri = parsedUri.replace(scheme: prefix);
      break;
    }
  }
  if (lud17prefixes.contains(parsedUri.scheme)) {
    /// If the non-bech32 LNURL is a Tor address, the port has to be http instead of https for the clearnet LNURL so check if the host ends with '.onion' or '.onion.'
    parsedUri = parsedUri.replace(
        scheme: parsedUri.host.endsWith('onion') ||
                parsedUri.host.endsWith('onion.')
            ? 'http'
            : 'https');
  }
  return parsedUri.toString();
}

bool isbech32(String input) {
  final match = new RegExp(
    r',*?((lnurl)([0-9]{1,}[a-z0-9]+){1})',
  ).allMatches(input.toLowerCase());
  return match.length == 1 ? true : false;
}
