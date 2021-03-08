import 'package:facebook_api_client/src/model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class FbChannelState {
  List<CRMTeam> get crmTeams => null;
}

/// Loading trong khi đợi load dữ liệu
class FbChannelLoading extends FbChannelState {}

/// Loading trong khi thao tác
class FbChannelEditLoading extends FbChannelState {}

class FbChannelActionFailure extends FbChannelState {
  FbChannelActionFailure({this.title, this.content});
  final String title;
  final String content;
}

/// Trả về dữ liệu khi load thành công
class FbChannelLoadSuccess extends FbChannelState {
  FbChannelLoadSuccess({
    this.facebookUser,
    this.title,
    this.content,
    this.crmTeams,
    this.token,
    this.isFacebookUserConnected = false,
    this.isFinished = false,
  });
  final List<CRMTeam> crmTeams;
  final FacebookUser facebookUser;
  final bool isFacebookUserConnected;
  final bool isFinished;
  final String title;
  final String content;
  final String token;
}

/// Trả về lỗi khi load thất bại
class FbChannelLoadFailure extends FbChannelState {
  FbChannelLoadFailure({this.title, this.content});
  final String title;
  final String content;
}

///  Connect thành công
class FbChannelConnectSuccess extends FbChannelState {
  FbChannelConnectSuccess({this.title, this.content});
  final String title;
  final String content;
}

///  Disconnect thành công
class FbChannelDisconnectSuccess extends FbChannelState {
  FbChannelDisconnectSuccess({this.crmTeams, this.title, this.content});
  final List<CRMTeam> crmTeams;
  final String title;
  final String content;
}

/// Trả về lỗi khi kết nối thất bại
class FbChannelConnectFailure extends FbChannelState {
  FbChannelConnectFailure({this.title, this.content});
  final String title;
  final String content;
}

class FbChannelRefreshTokenSuccess extends FbChannelState {
  FbChannelRefreshTokenSuccess({this.title, this.content});
  final String title;
  final String content;
}
