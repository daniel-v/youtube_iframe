@TestOn('browser')
library youtube_iframe.tests;

import 'dart:html';
import 'dart:js';

import 'package:test/test.dart';

import 'package:youtube_iframe/src/loader.dart';

void main() {
  group('Loading YT API', () {
    // as per the documentation, https://developers.google.com/youtube/iframe_api_reference#Getting_Started
    // it is recommended to load the YT API by adding a script tag
    Loader loader;
    setUp(() {
      loader = new Loader();
    });
    test('creates script element', () {
      loader.addScriptToDom();
      ScriptElement src = document.querySelector('script[src="${Loader.API_ENDPOINT}"]');
      expect(src.async, isTrue);
    });

    test('onYouTubeIframeAPIReady is registered', () {
      loader.registerLoadedCallback();
      var cb = context['onYouTubeIframeAPIReady'];
      expect(cb, const isInstanceOf<JsFunction>());
    }, timeout: new Timeout(new Duration(seconds: 10)));

    test('get notified when API is ready', () async {
      expect(await loader.load(), anything);
      expect(context['YT'], isNotNull);
    });
  });
}