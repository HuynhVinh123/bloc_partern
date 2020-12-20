import 'package:tpos_api_client/src/models/entities/pos_session/pos_session_config.dart';
import 'package:tpos_api_client/src/models/entities/pos_session/pos_session_user.dart';

class PosSession {
  PosSession(
      {this.id,
      this.configId,
      this.configName,
      this.name,
      this.userId,
      this.userName,
      this.startAt,
      this.stopAt,
      this.state,
      this.showState,
      this.sequenceNumber,
      this.loginNumber,
      this.cashControl,
      this.cashRegisterId,
      this.cashRegisterBalanceStart,
      this.cashRegisterTotalEntryEncoding,
      this.cashRegisterBalanceEnd,
      this.cashRegisterBalanceEndReal,
      this.cashRegisterDifference,
      this.dateCreated,
      this.user,
      this.config});

  PosSession.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    configId = json['ConfigId'];

    configName = json['ConfigName'];
    name = json['Name'];
    userId = json['UserId'];

    userName = json['UserName'];
    startAt = json['StartAt'];
    stopAt = json['StopAt'];
    state = json['State'];
    showState = json['ShowState'];
    sequenceNumber = json['SequenceNumber'];
    loginNumber = json['LoginNumber'];
    cashControl = json['CashControl'];
    cashRegisterId = json['CashRegisterId'];
    cashRegisterBalanceStart = json['CashRegisterBalanceStart'];
    cashRegisterTotalEntryEncoding = json['CashRegisterTotalEntryEncoding'];
    cashRegisterBalanceEnd = json['CashRegisterBalanceEnd'];
    cashRegisterBalanceEndReal = json['CashRegisterBalanceEndReal'];
    cashRegisterDifference = json['CashRegisterDifference'];
    dateCreated = json['DateCreated'];
    user = json['User'] != null ? PosSessionUser.fromJson(json['User']) : null;
    config = json['Config'] != null
        ? PosSessionConfig.fromJson(json['Config'])
        : null;
  }

  int id;
  int configId;
  String configName;
  String name;
  String userId;
  String userName;
  String startAt;
  String stopAt;
  String state;
  String showState;
  int sequenceNumber;
  int loginNumber;
  bool cashControl;
  int cashRegisterId;
  double cashRegisterBalanceStart;
  double cashRegisterTotalEntryEncoding;
  double cashRegisterBalanceEnd;
  double cashRegisterBalanceEndReal;
  double cashRegisterDifference;
  String dateCreated;
  PosSessionUser user;
  PosSessionConfig config;

  bool get isOpeningControl => true;
  bool get isOpened =>
      state == "opened" || state == "opening_control" || state == "closed";
  bool get isCloseControl => state == "closed";
  bool get isClosed => state == "closed";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ConfigId'] = configId;
    data['ConfigName'] = configName;
    data['Name'] = name;
    data['UserId'] = userId;
    data['UserName'] = userName;
    data['StartAt'] = startAt;
    data['StopAt'] = stopAt;
    data['State'] = state;
    data['ShowState'] = showState;
    data['SequenceNumber'] = sequenceNumber;
    data['LoginNumber'] = loginNumber;
    data['CashControl'] = cashControl;
    data['CashRegisterId'] = cashRegisterId;
    data['CashRegisterBalanceStart'] = cashRegisterBalanceStart;
    data['CashRegisterTotalEntryEncoding'] = cashRegisterTotalEntryEncoding;
    data['CashRegisterBalanceEnd'] = cashRegisterBalanceEnd;
    data['CashRegisterBalanceEndReal'] = cashRegisterBalanceEndReal;
    data['CashRegisterDifference'] = cashRegisterDifference;
    data['DateCreated'] = dateCreated;
    if (user != null) {
      data['User'] = user.toJson();
    }
    if (config != null) {
      data['Config'] = config.toJson();
    }

    return data;
  }
}
