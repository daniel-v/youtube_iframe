@JS('YT')
library youtube_iframe.player;

import 'dart:async';
import 'dart:html';
import 'dart:js' as js;
import 'dart:math' as math;

import 'package:js/js.dart';
import 'js_wrapper.dart';

const int INT_MAX = 2147483647;

class PlayerEvent {
  final Player target;
  final dynamic data;

  PlayerEvent(this.target, this.data);
}

/// Dart adapter class for [NativePlayer]
class Player implements NativePlayer {

  final NativePlayer _nativePlayer;

  Completer<bool> _isReadyCompleter;

  Player(Element placeholder, Config config)
      : _nativePlayer = new NativePlayer(placeholder, config) {
    _onReadyController = new StreamController<PlayerEvent>.broadcast(onListen: _registerNativeOnReady);
  }

  Future<bool> get isReady {
    if (_isReadyCompleter != null && _isReadyCompleter.isCompleted) {
      return new Future<bool>.value(true);
    } else {
      if (_isReadyCompleter == null) {
        _isReadyCompleter = new Completer<bool>();
        onReady.listen((_) {
          _isReadyCompleter.complete(true);
        });
      }
      return _isReadyCompleter.future;
    }
  }

  loadVideoByUrl(LoadByUrlConfig config) => _nativePlayer.loadVideoByUrl(config);

  @override
  NativePlayer addEventListener(String event, String listener) {
    throw new StateError('Use specific class properties to subscrive to events such as ${event}');
  }

  @override
  Player cueVideoByUrl(LoadByUrlConfig config) {
    _nativePlayer.cueVideoByUrl(config);
    return this;
  }

  @override
  void destroy() {
    _nativePlayer.destroy();
  }

  @override
  IFrameElement getIframe() {
    return _nativePlayer.getIframe();
  }

  @override
  int getPlayerState() {
    return _nativePlayer.getPlayerState();
  }

  @override
  String getVideoUrl() {
    return _nativePlayer.getVideoUrl();
  }

  @override
  Player playVideo() {
    _nativePlayer.playVideo();
    return this;
  }

  @override
  num getCurrentTime() {
    return _nativePlayer.getCurrentTime();
  }

  Stream at(Duration time) {
    var streamController;
    if (!_controllerByTime.containsKey(time.inSeconds)) {
      streamController = new StreamController.broadcast();
      _controllerByTime[time.inSeconds] = streamController;
    } else {
      streamController = _controllerByTime[time.inSeconds];
    }
    _startPollingElapsedTime();
    return streamController.stream;
  }

  void _startPollingElapsedTime() {
    if (_elapsedTimer == null || !_elapsedTimer.isActive) {
      _elapsedTimer = new Timer.periodic(new Duration(milliseconds: 500), (Timer t) {
        num elapsedTime = getCurrentTime().round();
        print(elapsedTime);
        _controllerByTime[elapsedTime]?.add(null);
      });
    }
  }

  Timer _elapsedTimer;

  Map<int, StreamController> _controllerByTime = {};

  StreamController<PlayerEvent> _onReadyController;

  Stream<PlayerEvent> get onReady => _onReadyController.stream;

  void _registerNativeOnReady() {
    String randomName = _getRandomString('yt_cb_');
    js.context[randomName] = allowInterop(([ev]) {
      _onReadyController.add(new PlayerEvent(this, null));
    });
    _nativePlayer.addEventListener('onReady', randomName);
  }

  static String _getRandomString([String prefix = '']) {
    math.Random rnd = new math.Random.secure();
    String randomName = rnd.nextInt(INT_MAX).toRadixString(36);
    return '${prefix}$randomName';
  }
}

/// See [https://developers.google.com/youtube/iframe_api_reference#setPlaybackQuality](API Documentation)
abstract class PlaybackQuality {
  /// Player height is 240px, and player dimensions are at least 320px by 240px for 4:3 aspect ratio.
  static const String small = 'small';

  ///  Player height is 360px, and player dimensions are 640px by 360px (for 16:9 aspect ratio) or 480px by 360px (for 4:3 aspect ratio).
  static const String medium = 'medium';

  /// Player height is 480px, and player dimensions are 853px by 480px (for 16:9 aspect ratio) or 640px by 480px (for 4:3 aspect ratio).
  static const String large = 'large';

  /// Player height is 720px, and player dimensions are 1280px by 720px (for 16:9 aspect ratio) or 960px by 720px (for 4:3 aspect ratio).
  static const String hd720 = 'hd720';

  /// Player height is 1080px, and player dimensions are 1920px by 1080px (for 16:9 aspect ratio) or 1440px by 1080px (for 4:3 aspect ratio).
  static const String hd1080 = 'hd1080';

  /// Player height is greater than 1080px, which means that the player's aspect ratio is greater than 1920px by 1080px.
  static const String highres = 'highres';

  /// YouTube selects the appropriate playback quality.
  static const String def = 'default';
}

/// State of the player
/// Can be queried with [NativePlayer.getPlayerSate]
abstract class PlayerState {
  static const int UNSTARTED = -1;
  static const int ENDED = 0;
  static const int PLAYING = 1;
  static const int PAUSED = 2;
  static const int BUFFERING = 3;
  static const int CUED = 5;

}

class ConfigBuilder {

  int height;
  int width;
  String videoId;

  Config build() {
    return new Config(height: height.toString(), width: width.toString(), videoId: videoId);
  }
}