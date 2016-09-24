import 'package:youtube_iframe/youtube_iframe.dart' as YT;

import 'dart:html';

main() async {
  await YT.loadAPI();
  var placeholder = document.querySelector('span');
  var config = new YT.ConfigBuilder()
    ..width = 640
    ..height = 390;
  var player = new YT.Player(placeholder, config.build());
  // until this point it's the same as simple example
  // wait for the player to be 'ready'
  await player.isReady;
  var cueConfig = new YT.LoadByUrlConfig(
      mediaContentUrl: YT.getQualifiedPlayerUrl('https://www.youtube.com/watch?v=M7lc1UVf-VE'),
      suggestedQuality: YT.PlaybackQuality.hd720);
  player
    ..cueVideoByUrl(cueConfig)
    // add some action to be executed at 3 seconds into the video - this is experimental
    ..at(new Duration(seconds: 3)).listen((_) {
      window.alert('Elapsed');
    })
    // and start the video
    ..playVideo();
}
