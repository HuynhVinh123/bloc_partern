import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ConversationMailTemplateEvent {}

///Danh sách tin nhắn nhanh
class ConversationMailTemplateLoaded extends ConversationMailTemplateEvent {}

abstract class ConversationMailTemplateState {
  ConversationMailTemplateState({this.mailTemplates});
  List<MailTemplate> mailTemplates;
}

///Chờ
class ConversationMailTemplateWating extends ConversationMailTemplateState {}

///Danh sách rỗng
class ConversationMailTemplateEmpty extends ConversationMailTemplateState {}

///Tải
class ConversationMailTemplateLoading extends ConversationMailTemplateState {
  ConversationMailTemplateLoading({List<MailTemplate> mailTemplates})
      : super(mailTemplates: mailTemplates);
}

///Lỗi
class ConversationMailTemplateFailure extends ConversationMailTemplateState {
  ConversationMailTemplateFailure({this.error});
  String error;
}

class ConversationMailTemplateBloc
    extends Bloc<ConversationMailTemplateEvent, ConversationMailTemplateState> {
  ConversationMailTemplateBloc({MailTemplateApi mailTemplateApi})
      : super(ConversationMailTemplateWating()) {
    _apiClient = mailTemplateApi ?? GetIt.instance<MailTemplateApi>();
  }
  MailTemplateApi _apiClient;
  final Logger _logger = Logger();
  @override
  Stream<ConversationMailTemplateState> mapEventToState(
      ConversationMailTemplateEvent event) async* {
    if (event is ConversationMailTemplateLoaded) {
      yield ConversationMailTemplateWating();
      try {
        final List<MailTemplate> mailTemplates =
            await _apiClient.getMailTemplateTPage();
        if (mailTemplates.isEmpty) {
          yield ConversationMailTemplateEmpty();
        } else {
          yield ConversationMailTemplateLoading(mailTemplates: mailTemplates);
        }
      } catch (e, stack) {
        _logger.e('GetMailTemplatesFailure', e, stack);
        yield ConversationMailTemplateFailure(error: e.toString());
      }
    }
  }
}
