import 'dart:async';
import 'dart:js';
import 'dart:html';

/// Loads the YT API
class Loader {
  /// Loads the API
  ///
  /// Returns a future that completes when `onYouTubeIframeAPIReady` is invoked
  /// by the YT API
  Future load() {
    if (context['YT'] != null) {
      print('asdasd');
    }
    registerLoadedCallback();
    addScriptToDom();
    return _loadedCompleter.future;
  }

  void addScriptToDom() {
    ScriptElement script = new ScriptElement()
      ..async = true
      ..src = API_ENDPOINT;
    document.head.append(script);
  }

  void registerLoadedCallback() {
    context['onYouTubeIframeAPIReady'] = allowInterop(loadedCallback);
  }

  void loadedCallback() {
    _loadedCompleter.complete();
  }

  Completer _loadedCompleter = new Completer();

  static const String API_ENDPOINT = 'https://www.youtube.com/iframe_api';
}

/// Loads the YT API
///
/// Returns a future that completes when `onYouTubeIframeAPIReady` is invoked
Future loadAPI() => new Loader().load();