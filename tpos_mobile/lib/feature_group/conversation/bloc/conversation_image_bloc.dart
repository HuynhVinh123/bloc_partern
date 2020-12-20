import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class ConversationImageEvent {}

class ConversationImagePickerAdded extends ConversationImageEvent {
  ConversationImagePickerAdded({this.file});
  File file;
}

class ConversationImageState {}

class ConversationImageWaiting extends ConversationImageState {}

class ConversationImageAddSuccess extends ConversationImageState {
  ConversationImageAddSuccess({this.urlImage});
  String urlImage;
}

class ConversationImageailure extends ConversationImageState {
  ConversationImageailure({this.message});
  String message;
}

class ConversationImageBloc
    extends Bloc<ConversationImageEvent, ConversationImageState> {
  ConversationImageBloc(
      {DialogService dialogService, ConversationApi conservationApi})
      : super(ConversationImageWaiting()) {
    _dialog = dialogService ?? locator<DialogService>();
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }

  DialogService _dialog;
  ConversationApi _apiClient;

  @override
  Stream<ConversationImageState> mapEventToState(
      ConversationImageEvent event) async* {
    if (event is ConversationImagePickerAdded) {
      yield ConversationImageWaiting();
      try {
        final response = await _apiClient.convertImage(file: event.file);
        yield ConversationImageAddSuccess(urlImage: response);
      } catch (e) {
        yield ConversationImageailure(message: e.toString());
      }
    }
  }
}
