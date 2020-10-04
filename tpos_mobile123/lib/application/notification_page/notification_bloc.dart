import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'notification_event.dart';
import 'notification_state.dart';

// TODO(namnv): Giảm tải hệ thống. Tối ưu hóa  code chỗ này.Cache data notification để không tải lại liên tục nếu chuyển tab thông báo liên tục. Giảm tải hệ thống
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({initialState})
      : super(
          initialState ?? NotificationUnInitial(),
        ) {
    _logger.i('NotificationBloc Initilize');
  }
  final Logger _logger = Logger();

  final NotificationApi _notificationApi = GetIt.instance<NotificationApi>();

  bool isPopupRead = false;
  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    print(event);
    if (event is NotificationLoaded) {
      // Tải danh sách thông báo
      yield NotificationLoading();
      try {
        final result = await _notificationApi.getNotRead();
        // result.popup = result.items[0];
        yield NotificationLoadSuccess(notificationResult: result);
      } catch (e, s) {
        _logger.e('', e, s);
        yield NotificationLoadFailure(e.toString());
      }
    } else if (event is NotificationMarkRead) {
      try {
        await _notificationApi.markRead(event.notification.id);
        final result = await _notificationApi.getNotRead();
        // result.popup = result.items[0];
        yield NotificationLoadSuccess(
          notificationResult: result,
          popupRead: true,
        );
      } catch (e, s) {
        _logger.e('', e, s);
      }
    }
  }
}
