import 'package:tpos_api_client/tpos_api_client.dart';

class FbChannelEvent {}

/// Thực hiện load danh sách
class FbChannelLoaded extends FbChannelEvent {}

// Connect
class FbChannelConnected extends FbChannelEvent {
  FbChannelConnected({this.crmTeam});
  CRMTeam crmTeam;
}

// Disconnect
class FbChannelDisconnected extends FbChannelEvent {
  FbChannelDisconnected({this.crmTeam});
  CRMTeam crmTeam;
}

// Refresh Token
class FbChannelTokenRefreshed extends FbChannelEvent {
  FbChannelTokenRefreshed({this.crmTeam});
  CRMTeam crmTeam;
}

// connect with fb
class FbChannelAccountLogged extends FbChannelEvent {
  FbChannelAccountLogged();
}

// logout with fb
class FbChannelAccountLogout extends FbChannelEvent {
  FbChannelAccountLogout();
}
