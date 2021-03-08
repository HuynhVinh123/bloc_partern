import 'package:facebook_api_client/facebook_api_client.dart';

class FacebookPageSelectState {}

/// Loading trong khi đợi load dữ liệu
class FacebookPageSelectLoading extends FacebookPageSelectState {}

/// Trả về dữ liệu khi load thành công
class FacebookPageSelectLoadSuccess extends FacebookPageSelectState {
  FacebookPageSelectLoadSuccess({this.fbPages});

  final List<FacebookAccount> fbPages;
}

/// Trả về lỗi khi load thất bại
class FacebookPageSelectLoadFailure extends FacebookPageSelectState {
  FacebookPageSelectLoadFailure({this.hint, this.title, this.content});

  final String title;
  final String content;
  final String hint;
}
