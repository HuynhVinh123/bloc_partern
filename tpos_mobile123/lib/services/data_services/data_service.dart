import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile/locator.dart';
import '../log_services/log_service.dart';

/// Dịch vụ làm cầu nối thông bao thay đổi dữ liệu trong phần mềm
/// Ví dụ: Như sự kiện thêm, sửa ,xóa dữ liệu nhằm thông báo cho những đối tượng có nhu cầu lắng nghe
class DataService {
  LogService _log;

  DataService({LogService logService}) {
    _log = logService ?? locator<LogService>();
    _dataSubject.listen(
      (data) {
        //log
        _log.info(
            "[DATA SERVICE NOTIFY] New data update notify from ${data.sender}, type: ${data.type}, valueType: ${data.value.runtimeType}, valueTargetType: ${data.valueTargetType}");
      },
    );
  }
  PublishSubject<DataMessage> _dataSubject = new PublishSubject<DataMessage>();

  PublishSubject<DataMessage> get dataSubject => _dataSubject;

  void addDataNotify(
      {DataMessage message,
      DataMessageType type,
      Object sender,
      Object value,
      Type valueTargetType}) {
    if (_dataSubject != null && _dataSubject.isClosed == false) {
      _dataSubject.add(
        message ??
            new DataMessage(
              type: type,
              sender: sender,
              value: value,
              dateCreated: DateTime.now(),
              valueTargetType: valueTargetType,
            ),
      );
    }
  }

  @mustCallSuper
  void dispose() {
    _dataSubject.close();
  }
}

/// clas data message
/// Chứa thông tin về các đối tượng thêm ,sửa, xóa sử dụng cho DataService
class DataMessage {
  /// Kiểu thay đổi nội dung (Thêm , xóa, sửa)
  DataMessageType type;

  /// Nguồn thông báo
  Object sender;

  /// Nội dung thay đổi
  Object value;

  /// Kiêu nội dung ID or OBJECT
  DataValueType valueType;

  /// Ngày tạo
  DateTime dateCreated;

  /// Nguồn
  Object source;

  /// Kiểu dữ liệu nhận thay đổi
  Type valueTargetType;

  DataMessage(
      {this.type,
      this.sender,
      this.value,
      this.dateCreated,
      this.valueTargetType,
      this.valueType});
}

/// Kiểu của dữ liệu trong DataService
enum DataMessageType {
  INSERT,
  UPDATE,
  DELETE,
}
// Kiểu đối tượng param trong DataService
enum DataValueType {
  OBJECT,
  ID,
}
