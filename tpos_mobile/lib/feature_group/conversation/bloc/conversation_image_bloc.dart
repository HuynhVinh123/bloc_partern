import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

///Sự kiện gửi hình
class ConversationImageEvent {}

///Chọn hình
class ConversationImagePickerAdded extends ConversationImageEvent {
  ConversationImagePickerAdded({this.file, this.listUrl});
  File file;
  List<File> listUrl;
}

///Trạng thái
class ConversationImageState {}

///Chờ
class ConversationImageWaiting extends ConversationImageState {}

///Chọn hình thành công
class ConversationImageLoadAddSuccess extends ConversationImageState {
  ConversationImageLoadAddSuccess({this.urlImage});
  String urlImage;
}

///Lỗi
class ConversationImageFailure extends ConversationImageState {
  ConversationImageFailure({this.message});
  String message;
}

class ConversationImageBloc
    extends Bloc<ConversationImageEvent, ConversationImageState> {
  ConversationImageBloc({ConversationApi conservationApi})
      : super(ConversationImageWaiting()) {
    _apiClient = conservationApi ?? GetIt.instance<ConversationApi>();
  }
  ConversationApi _apiClient;

  @override
  Stream<ConversationImageState> mapEventToState(
      ConversationImageEvent event) async* {
    if (event is ConversationImagePickerAdded) {
      yield ConversationImageWaiting();
      try {
        final response = await _apiClient.convertImage(file: event.file);
        yield ConversationImageLoadAddSuccess(urlImage: response);
      } catch (e) {
        yield ConversationImageFailure(message: e.toString());
      }
    }
  }
}
