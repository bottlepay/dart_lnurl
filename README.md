# dart_lnurl
[![pub package](https://img.shields.io/badge/pub-0.0.1-blueviolet.svg)](https://pub.dev/packages/dart_lnurl)

A Dart implementation of lnurl to decode bech32 lnurl strings. Currently supports the following tags:
* withdrawRequest
* payRequest
* channelRequest
* login

## Features
* ✅ Decode a bech32-encoded lnurl string.
* ✅ Make GET request to the decoded ln service and return the response.


Learn more about the lnurl spec here: https://github.com/btcontract/lnurl-rfc

# API Reference

`Future<LNURLParseResult> getParams(String encodedUrl)`
Use this to parse an encoded bech32 lnurl string, call the decoded URI, and return the parsed response from the lnurl service. The `encodedUrl` can either have `lightning:` in it or not.

`String decryptSuccessActionAesPayload({LNURLPaySuccessAction successAction, String preimage})`

When doing lnurl pay, the success action could contain an encrypted payload using the payment preimage. Use this function to decrypt that payload.