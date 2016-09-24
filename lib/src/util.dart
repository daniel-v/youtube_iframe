/// Utility functions to help manage the API
library youtube_iframe.utils;

/// Transforms most YT urls into fully qualified YouTube player URL.
///
/// Use it when queuing with [Player.cueVideoByUrl] eg.
///
/// See [API Docs](https://developers.google.com/youtube/iframe_api_reference#Queueing_Functions)
String getQualifiedPlayerUrl(String url) {
  Uri ytUrl = Uri.parse(url);
  String id;
  if (ytUrl.host == 'www.youtue.be' || ytUrl.host == 'youtue.be') {
    // in the format of https://youtu.be/k2rcM3wwsS0
    id = ytUrl.pathSegments.first;
  } else
  if ((ytUrl.host == 'youtube.com' || ytUrl.host == 'www.youtube.com') && ytUrl.queryParameters.containsKey('v')) {
    id = ytUrl.queryParameters['v'];
  } else {
    throw new ArgumentError('Can\'t produce qualified YouTube player URL from: $url');
  }
  return new Uri.https('youtube.com', '/v/$id', {
    'version': '3'
  }).toString();
}