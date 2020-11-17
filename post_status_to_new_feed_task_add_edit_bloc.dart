import 'package:fbpro_api/fbpro_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../locator.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

abstract class PostStatusToNewFeedAddEditEvent {}

class PostStatusToNewFeedLoaded extends PostStatusToNewFeedAddEditEvent {
  PostStatusToNewFeedLoaded(this.taskId);
  final String taskId;
}

class PostStatusToNewFeedSave extends PostStatusToNewFeedAddEditEvent {
  PostStatusToNewFeedSave(
      {this.facebookAccount,
      this.actionTime,
      this.statusPrivacyType,
      this.message,
      this.link,
      this.photos});
  final FacebookAccount facebookAccount;
  final DateTime actionTime;
  final StatusPrivacyType statusPrivacyType;
  final String message;
  final String link;
  final List<String> photos;
}

abstract class PostStatusToNewFeedAddEditState {}

class PostStatusToNewFeedInitial extends PostStatusToNewFeedAddEditState {}

class PostStatusToNewFeedLoadSuccess extends PostStatusToNewFeedAddEditState {}

class PostStatusToNewFeedLoadFailure extends PostStatusToNewFeedAddEditState {}

class PostStatusToNewFeedSaveSuccess extends PostStatusToNewFeedAddEditState {}

class PostStatusToNewFeedSaveFailure extends PostStatusToNewFeedAddEditState {}

class PostStatusToNewFeedBusy extends PostStatusToNewFeedAddEditState {}

class PostSatusToNewFeedAddEditBloc extends Bloc<
    PostStatusToNewFeedAddEditEvent, PostStatusToNewFeedAddEditState> {
  PostSatusToNewFeedAddEditBloc({FacebookTaskApi facebookTaskApi})
      : super(PostStatusToNewFeedInitial()) {
    _facebookTaskApi = facebookTaskApi ?? locator<FacebookTaskApi>();
  }

  final Logger _logger = Logger();
  FacebookTaskApi _facebookTaskApi;

  @override
  Stream<PostStatusToNewFeedAddEditState> mapEventToState(
      PostStatusToNewFeedAddEditEvent event) async* {
    if (event is PostStatusToNewFeedLoaded) {
      if (event.taskId != null) {
        // update
        // var task = await _facebookTaskApi.get
      } else {
        // insert
        yield PostStatusToNewFeedLoadSuccess();
      }
    } else if (event is PostStatusToNewFeedSave) {
      // validate data

      yield PostStatusToNewFeedBusy();
      // save
      final PostStatusToNewFeedTask task = PostStatusToNewFeedTask(
        facebookAccountId: event.facebookAccount?.id,
        clientId: event.facebookAccount?.clientNodeId,
        actionTime: event.actionTime,
        content: event.message,
        link: event.link,
        addPhoto: event.photos != null && event.photos.isNotEmpty,
        photos: event.photos,
      );

      try {
        final PostStatusToNewFeedTask savedTask =
            await _facebookTaskApi.insertPostStatusToNewFeedTask(task);
        yield PostStatusToNewFeedSaveSuccess();
      } catch (e, s) {
        _logger.e('', e, s);
        yield PostStatusToNewFeedSaveFailure();
      }
    }
  }
}
