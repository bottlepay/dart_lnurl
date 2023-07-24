# dart_lnurl
[![pub package](https://img.shields.io/badge/pub-0.0.1-blueviolet.svg)](https://pub.dev/packages/dart_lnurl)

A Dart implementation of lnurl to decode and bech32 lnurl strings. Currently supports the following tags:
* withdrawRequest
* payRequest
* channelRequest
* login

## Features
* ✅ Decode a bech32-encoded lnurl string.
* ✅ Handles LUD-17 non-bech32 lnurl string (lnurlw, lnurlp, lnurlc, keyauth).
* ✅ Make GET request to the ln service and return the response.



Learn more about the lnurl spec here: https://github.com/btcontract/lnurl-rfc

# API Reference

`Future<LNURLParseResult> getParams(String url)`
Use this to parse a lnurl string, call the (decoded if needed) URI, and return the parsed response from the lnurl service. The bech32-encoded `url` can either have `lightning:` in it or not and non-bech32 `url` can either have `lnurlw:`,`lnurlp:`,`lnurlc:` or `keyauth:`.

`String decryptSuccessActionAesPayload({LNURLPaySuccessAction successAction, String preimage})`

When doing lnurl pay, the success action could contain an encrypted payload using the payment preimage. Use this function to decrypt that payload.