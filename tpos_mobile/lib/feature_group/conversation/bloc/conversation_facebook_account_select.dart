import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class ConversationFacebookAcountEvent {}

///Tải danh sách tải khoản facebook
class FacebookLoaded extends ConversationFacebookAcountEvent {}

class ConversationFacebookAcountState {}

///Chờ
class FacebookWaiting extends ConversationFacebookAcountState {}

///Tải
class FacebookLoading extends ConversationFacebookAcountState {
  FacebookLoading({this.facebookAccounts});
  GetListFacebookResult facebookAccounts;
}

///Tải thất bại
class FacebookFailure extends ConversationFacebookAcountState {
  FacebookFailure({this.error});
  String error;
}

class ConversationFacebookBloc extends Bloc<ConversationFacebookAcountEvent,
    ConversationFacebookAcountState> {
  ConversationFacebookBloc({ConversationApi conservationApi})
      : super(FacebookWaiting()) {
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }
  ConversationApi _apiClient;

  @override
  Stream<ConversationFacebookAcountState> mapEventToState(
      ConversationFacebookAcountEvent event) async* {
    if (event is FacebookLoaded) {
      yield FacebookWaiting();
      try {
        final GetListFacebookResult facebookAccounts =
            await _apiClient.getAllFacebook();
        yield FacebookLoading(facebookAccounts: facebookAccounts);
      } catch (e) {
        yield FacebookFailure(error: e.toString());
      }
    }
  }
}
