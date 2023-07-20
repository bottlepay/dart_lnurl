class LNURLErrorResponse {
  LNURLErrorResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        reason = json['reason'],
        domain = json['domain'],
        url = json['url'];
  final String status;
  final String reason;
  final String domain;
  final String url;
}

class LNURLChannelParams {
  LNURLChannelParams.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        callback = json['callback'],
        domain = json['domain'],
        k1 = json['k1'],
        url = json['url'];
  final String tag;
  final String callback;
  final String domain;
  final String k1;
  final String url;
}

class LNURLWithdrawParams {
  LNURLWithdrawParams.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        k1 = json['k1'],
        callback = json['callback'],
        domain = json['domain'],
        minWithdrawable = json['minWithdrawable'],
        maxWithdrawable = json['maxWithdrawable'],
        defaultDescription = json['defaultDescription'];
  final String tag;
  final String k1;
  final String callback;
  final String domain;
  final int minWithdrawable;
  final int maxWithdrawable;
  final String defaultDescription;
}

class LNURLAuthParams {
  LNURLAuthParams.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        k1 = json['k1'],
        callback = json['callback'],
        domain = json['domain'];
  final String tag;
  final String k1;
  final String callback;
  final String domain;
}

class LNURLPayParams {
  LNURLPayParams.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        callback = json['callback'],
        minSendable = json['minSendable'],
        maxSendable = json['maxSendable'],
        metadata = json['metadata'];
  final String tag;
  final String callback;
  final int minSendable;
  final int maxSendable;
  final String metadata;
}

/// A success action will be returned when making a call to the lnUrl callback url.
class LNURLPaySuccessAction {
  LNURLPaySuccessAction.fromJson(Map<String, dynamic> json)
      : tag = json['tag'] ?? '',
        description = json['description'] ?? '',
        url = json['url'] ?? '',
        message = json['message'] ?? '',
        cipherText = json['cipherText'] ?? '',
        iv = json['iv'] ?? '';
  final String tag;
  final String description;
  final String url;
  final String message;
  final String cipherText;
  final String iv;
}

class LNURLPayResult {
  LNURLPayResult.fromJson(Map<String, dynamic> json)
      : pr = json['pr'],
        successAction = json['successAction'],
        disposable = json['disposable'],
        routes = json['routes'];
  final String pr;
  final LNURLPaySuccessAction successAction;
  final bool disposable;
  final List<List<Object>> routes;
}

/// The result returned when you call getParams. The correct response
/// item will be non-null and the rest will be null.
///
/// If error is non-null then an error occurred while calling the lnurl service.
class LNURLParseResult {
  LNURLParseResult({
    this.withdrawalParams,
    this.payParams,
    this.authParams,
    this.channelParams,
    this.error,
  });
  final LNURLWithdrawParams? withdrawalParams;
  final LNURLPayParams? payParams;
  final LNURLAuthParams? authParams;
  final LNURLChannelParams? channelParams;
  final LNURLErrorResponse? error;
}
