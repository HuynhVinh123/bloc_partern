import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class ConversationFacebookAcountEvent {}

class FacebookLoaded extends ConversationFacebookAcountEvent {}

class ConversationFacebookAcountState {}

class FacebookWaiting extends ConversationFacebookAcountState {}

class FacebookLoading extends ConversationFacebookAcountState {
  FacebookLoading({this.facebookAccounts});
  GetListFacebookResult facebookAccounts;
}

class FacebookFailure extends ConversationFacebookAcountState {
  FacebookFailure({this.error});
  String error;
}

class ConversationFacebookBloc extends Bloc<ConversationFacebookAcountEvent,
    ConversationFacebookAcountState> {
  ConversationFacebookBloc(
      {DialogService dialogService, ConversationApi conservationApi})
      : super(FacebookWaiting()) {
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }

  DialogService _dialog;
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
