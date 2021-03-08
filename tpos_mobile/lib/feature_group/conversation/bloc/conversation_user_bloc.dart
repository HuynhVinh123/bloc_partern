import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class ConversationUserEvent {}

class ConversationUserLoaded extends ConversationUserEvent {}

class ConversationUserAdded extends ConversationUserEvent {
  ConversationUserAdded({this.pageId, this.userId, this.facebookId});
  String pageId;
  String userId;
  String facebookId;
}

class ConversationUserState {
  ConversationUserState({this.applicationUser, this.applicationUsers});
  ApplicationUser applicationUser;
  OdataListResult<ApplicationUser> applicationUsers;
}

class ConversationUserSuccess extends ConversationUserState {
  ConversationUserSuccess({ApplicationUser applicationUser})
      : super(applicationUser: applicationUser);
}

class ConversationUserLoad extends ConversationUserState {
  ConversationUserLoad(
      {OdataListResult<ApplicationUser> applicationUsers,
      ApplicationUser applicationUser})
      : super(
            applicationUser: applicationUser,
            applicationUsers: applicationUsers);
}

class ConversationUserFailure extends ConversationUserState {
  ConversationUserFailure({this.message});
  String message;
}

class ConversationUserWaiting extends ConversationUserState {}

class ConversationUserBloc
    extends Bloc<ConversationUserEvent, ConversationUserState> {
  ConversationUserBloc({ConversationApi conservationApi})
      : super(ConversationUserWaiting()) {
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }

  ConversationApi _apiClient;
  @override
  Stream<ConversationUserState> mapEventToState(
      ConversationUserEvent event) async* {
    if (event is ConversationUserLoaded) {
      yield ConversationUserWaiting();
      try {
        final OdataListResult<ApplicationUser> applicationUsers =
            await _apiClient.getApplicationUser();
        yield ConversationUserLoad(applicationUsers: applicationUsers);
      } catch (e) {
        yield ConversationUserFailure(message: e.toString());
      }
    } else if (event is ConversationUserAdded) {
      yield ConversationUserWaiting();
      try {
        final ApplicationUser applicationUser = await _apiClient.changeUser(
            facebookId: event.facebookId,
            pageId: event.pageId,
            userId: event.userId);
        final OdataListResult<ApplicationUser> applicationUsers =
            await _apiClient.getApplicationUser();
        yield ConversationUserLoad(
            applicationUser: applicationUser,
            applicationUsers: applicationUsers);
      } catch (e) {
        yield ConversationUserFailure(message: e.toString());
      }
    }
  }
}
