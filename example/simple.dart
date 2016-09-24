import 'package:youtube_iframe/youtube_iframe.dart' as YT;
import 'dart:html';

main() async {
  await YT.loadAPI();
  // at this point the API is ready, we can create our player
  var placeholder = document.querySelector('span');

  // Weird enough, YT expects certain non-string values passed as
  // strings. That does not make much sense in Dart, so wrapped it
  // in a builder.
  var config = new YT.ConfigBuilder()
    ..width = 640
    ..height = 390
    ..videoId = 'M7lc1UVf-VE';
  // create the player
  new YT.Player(placeholder, config.build());
}
