@JS('YT')
library youtube_iframe.wrapper;

import 'dart:html';

import 'package:js/js.dart';

/// YT.Player JS instance
///
/// [Player] provides a more idiomatic Dart implementation to manage the YT API
@JS('Player')
class NativePlayer {
  external NativePlayer(Element placeholder, Config config);

  /// Gets the state of this player.
  ///
  /// Some constants are defined in [PlayerState]
  ///
  /// Docs: [Event API Docs](https://developers.google.com/youtube/iframe_api_reference#Events)
  external int getPlayerState();

  /// Queues a video specified by [config] to be played
  ///
  /// Docs: [API Docs](https://developers.google.com/youtube/iframe_api_reference#Queueing_Functions)
  external cueVideoByUrl(LoadByUrlConfig config);

  /// Loads and plays the video specified by [config]
  ///
  /// Docs: [API Docs](https://developers.google.com/youtube/iframe_api_reference#Queueing_Functions)
  external NativePlayer loadVideoByUrl(LoadByUrlConfig config);

  /// This method returns the DOM node for the embedded <iframe>.
  external IFrameElement getIframe();

  /// Returns the YouTube.com URL for the currently loaded/playing video.
  external String getVideoUrl();

  /// Removes the <iframe> containing the player.
  external void destroy();

  external NativePlayer playVideo();

  external NativePlayer addEventListener(String event, String listener);

  external num getCurrentTime();
}

@JS()
@anonymous
class LoadByUrlConfig {
  external String get mediaContentUrl;

  external num get startSeconds;

  external num get endSeconds;

  external String get suggestedQuality;

  /// Specifies a video to load by [mediaContentUrl] to be played from [startSeconds] until [endSeconds].
  /// YT will attempt to load the video with [suggestedQuality]. Please see [PlaybackQuality] for possible values;
  external factory LoadByUrlConfig({String mediaContentUrl, int startSeconds, int endSeconds, String suggestedQuality});
}


/// Config properties for [NativePlayer]
/// For convenience, use [ConfigBuilder]
@JS()
@anonymous
class Config {

  external String get height;

  external String get width;

  external String get videoId;

  external factory Config({String height, String width, String videoId});
}