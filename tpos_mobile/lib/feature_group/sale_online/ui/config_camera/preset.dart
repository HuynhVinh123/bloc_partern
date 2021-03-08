import 'package:camera_with_rtmp/camera.dart';

String numberPreset(ResolutionPreset resolutionPreset) {
  switch (resolutionPreset) {
    case ResolutionPreset.max:
      return 'max';
    case ResolutionPreset.ultraHigh:
      return '2160p';
    case ResolutionPreset.veryHigh:
      return '1080p';
    case ResolutionPreset.high:
      return '720p';
    case ResolutionPreset.medium:
      return '480p';
    case ResolutionPreset.low:
      return '240p';
  }
  throw ArgumentError('Unknown ResolutionPreset value');
}

int bitrate(ResolutionPreset resolutionPreset) {
  int bitrate = 720 * 480;
  switch (resolutionPreset) {
    case ResolutionPreset.max:
      bitrate = 720 * 480;
      break;
    case ResolutionPreset.ultraHigh:
      bitrate = 3840 * 2160;
      break;
    case ResolutionPreset.veryHigh:
      bitrate = 1920 * 1080;
      break;
    case ResolutionPreset.high:
      bitrate = 1280 * 720;
      break;
    case ResolutionPreset.medium:
      bitrate = 720 * 480;
      break;
    case ResolutionPreset.low:
      bitrate = 320 * 240;
      break;
  }
  return bitrate;
}
