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
      this.state == "opened" ||
      this.state == "opening_control" ||
      this.state == "closed";
  bool get isCloseControl => this.state == "closed";
  bool get isClosed => this.state == "closed";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ConfigId'] = this.configId;
    data['ConfigName'] = this.configName;
    data['Name'] = this.name;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['StartAt'] = this.startAt;
    data['StopAt'] = this.stopAt;
    data['State'] = this.state;
    data['ShowState'] = this.showState;
    data['SequenceNumber'] = this.sequenceNumber;
    data['LoginNumber'] = this.loginNumber;
    data['CashControl'] = this.cashControl;
    data['CashRegisterId'] = this.cashRegisterId;
    data['CashRegisterBalanceStart'] = this.cashRegisterBalanceStart;
    data['CashRegisterTotalEntryEncoding'] =
        this.cashRegisterTotalEntryEncoding;
    data['CashRegisterBalanceEnd'] = this.cashRegisterBalanceEnd;
    data['CashRegisterBalanceEndReal'] = this.cashRegisterBalanceEndReal;
    data['CashRegisterDifference'] = this.cashRegisterDifference;
    data['DateCreated'] = this.dateCreated;
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    if (this.config != null) {
      data['Config'] = this.config.toJson();
    }

    return data;
  }
}
