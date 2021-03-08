import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

///Event
class AccountCommonPartnerReportEvent {}

class AccountCommonPartnerReportLoaded extends AccountCommonPartnerReportEvent {
  AccountCommonPartnerReportLoaded(
      {this.getReportStaffSummaryQuery, this.limit, this.type});
  GetAccountCommonPartnerReportQuery getReportStaffSummaryQuery;
  final int limit;
  final int type;
}

class AccountCommonPartnerReportLoadMore
    extends AccountCommonPartnerReportEvent {
  AccountCommonPartnerReportLoadMore(
      {this.getReportStaffSummaryQuery, this.limit, this.type});
  GetAccountCommonPartnerReportQuery getReportStaffSummaryQuery;
  final int limit;
  final int type;
}

class CustomerDebDetailReportLoaded extends AccountCommonPartnerReportEvent {
  CustomerDebDetailReportLoaded(
      {this.getReportStaffSummaryQuery, this.limit, this.type});
  GetAccountCommonPartnerReportQuery getReportStaffSummaryQuery;
  final int limit;
  final int type;
}

class CustomerDebDetailReportLoadMore extends AccountCommonPartnerReportEvent {
  CustomerDebDetailReportLoadMore(
      {this.getReportStaffSummaryQuery, this.limit, this.type});
  GetAccountCommonPartnerReportQuery getReportStaffSummaryQuery;
  final int limit;
  final int type;
}

///State
class AccountCommonPartnerReportState {
  AccountCommonPartnerReportState({this.listAccountCommonPartnerReportState});
  List<AccountCommonPartnerReport> listAccountCommonPartnerReportState;
}

class AccountCommonPartnerReportInitial
    extends AccountCommonPartnerReportState {}

class AccountCommonPartnerReportLoading
    extends AccountCommonPartnerReportState {
  AccountCommonPartnerReportLoading(
      {List<AccountCommonPartnerReport> listAccountCommonPartnerReportState})
      : super(
            listAccountCommonPartnerReportState:
                listAccountCommonPartnerReportState);
}

class AccountCommonPartnerReportLoadNoMore
    extends AccountCommonPartnerReportState {
  AccountCommonPartnerReportLoadNoMore(
      {List<AccountCommonPartnerReport> listAccountCommonPartnerReportState})
      : super(
            listAccountCommonPartnerReportState:
                listAccountCommonPartnerReportState);
}

class AccountCommonPartnerReportLoadFailure
    extends AccountCommonPartnerReportState {
  AccountCommonPartnerReportLoadFailure({this.title, this.content});
  final String title;
  final String content;
}

class AccountCommonPartnerReportBloc extends Bloc<
    AccountCommonPartnerReportEvent, AccountCommonPartnerReportState> {
  AccountCommonPartnerReportBloc(
      {AccountCommonPartnerReportApi accountCommonPartnerReportApi})
      : super(AccountCommonPartnerReportInitial()) {
    _apiClient = accountCommonPartnerReportApi ??
        GetIt.instance<AccountCommonPartnerReportApi>();
  }
  AccountCommonPartnerReportApi _apiClient;

  List<AccountCommonPartnerReport> _listAccountCommonPartnerReport;
  double totalReportStaffSummary;
  @override
  Stream<AccountCommonPartnerReportState> mapEventToState(
      AccountCommonPartnerReportEvent event) async* {
    if (event is AccountCommonPartnerReportLoaded) {
      yield AccountCommonPartnerReportInitial();
      yield* _getReportStaffSummaryState(event);
    } else if (event is AccountCommonPartnerReportLoadMore) {
      try {
        if (_listAccountCommonPartnerReport.length < totalReportStaffSummary) {
          final AccountCommonPartnerReportResult reportStaffSummaryResult =
              await _apiClient.getPartnerReports(
                  userId: event.getReportStaffSummaryQuery.userId,
                  companyId: event.getReportStaffSummaryQuery.companyId,
                  partnerId: event.getReportStaffSummaryQuery.partnerId,
                  categId: event.getReportStaffSummaryQuery.categId,
                  dateFrom: event.getReportStaffSummaryQuery.dateFrom,
                  dateTo: event.getReportStaffSummaryQuery.dateTo,
                  skip: _listAccountCommonPartnerReport.length,
                  page: event.getReportStaffSummaryQuery.page,
                  pageSize: event.getReportStaffSummaryQuery.pageSize,
                  resultSelection:
                      event.getReportStaffSummaryQuery.resultSelection,
                  take: event.getReportStaffSummaryQuery.take,
                  display: event.getReportStaffSummaryQuery.display,
                  type: event.type);
          _listAccountCommonPartnerReport.addAll(reportStaffSummaryResult.data);
          yield AccountCommonPartnerReportLoading(
              listAccountCommonPartnerReportState:
                  _listAccountCommonPartnerReport);
        } else {
          yield AccountCommonPartnerReportLoadNoMore(
              listAccountCommonPartnerReportState:
                  _listAccountCommonPartnerReport);
        }
      } catch (e) {
        yield AccountCommonPartnerReportLoadFailure(
            title: S.current.notification, content: e.toString());
      }
    }
    if (event is CustomerDebDetailReportLoaded) {
      yield AccountCommonPartnerReportInitial();
      yield* _getReportStaffDetail(event);
    } else if (event is CustomerDebDetailReportLoadMore) {
      try {
        if (_listAccountCommonPartnerReport.length < totalReportStaffSummary) {
          final AccountCommonPartnerReportResult reportStaffSummaryResult =
              await _apiClient.getReportStaffDetail(
                  partnerId: event.getReportStaffSummaryQuery.partnerId,
                  dateFrom: event.getReportStaffSummaryQuery.dateFrom,
                  dateTo: event.getReportStaffSummaryQuery.dateTo,
                  skip: _listAccountCommonPartnerReport.length,
                  page: event.getReportStaffSummaryQuery.page,
                  pageSize: event.getReportStaffSummaryQuery.pageSize,
                  resultSelection:
                      event.getReportStaffSummaryQuery.resultSelection,
                  take: event.getReportStaffSummaryQuery.take);
          _listAccountCommonPartnerReport.addAll(reportStaffSummaryResult.data);
          yield AccountCommonPartnerReportLoading(
              listAccountCommonPartnerReportState:
                  _listAccountCommonPartnerReport);
        } else {
          yield AccountCommonPartnerReportLoadNoMore(
              listAccountCommonPartnerReportState:
                  _listAccountCommonPartnerReport);
        }
      } catch (e) {
        yield AccountCommonPartnerReportLoadFailure(
            title: S.current.notification, content: e.toString());
      }
    }
  }

  /// Lấy danh sách công nợ
  Stream<AccountCommonPartnerReportState> _getReportStaffSummaryState(
      AccountCommonPartnerReportLoaded event) async* {
    try {
      List<AccountCommonPartnerReport> listReportStaffSummaryState;

      final AccountCommonPartnerReportResult reportStaffSummaryResult =
          await _apiClient.getPartnerReports(
              userId: event.getReportStaffSummaryQuery.userId,
              companyId: event.getReportStaffSummaryQuery.companyId,
              partnerId: event.getReportStaffSummaryQuery.partnerId,
              categId: event.getReportStaffSummaryQuery.categId,
              dateFrom: event.getReportStaffSummaryQuery.dateFrom,
              dateTo: event.getReportStaffSummaryQuery.dateTo,
              skip: event.getReportStaffSummaryQuery.skip,
              page: event.getReportStaffSummaryQuery.page,
              pageSize: event.getReportStaffSummaryQuery.pageSize,
              resultSelection: event.getReportStaffSummaryQuery.resultSelection,
              take: event.getReportStaffSummaryQuery.take,
              display: event.getReportStaffSummaryQuery.display,
              type: event.type);
      listReportStaffSummaryState = reportStaffSummaryResult.data;
      _listAccountCommonPartnerReport = listReportStaffSummaryState;
      totalReportStaffSummary = reportStaffSummaryResult.total;
      yield AccountCommonPartnerReportLoading(
          listAccountCommonPartnerReportState: _listAccountCommonPartnerReport);
    } catch (e) {
      yield AccountCommonPartnerReportLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  /// Get chi tiết danh sách khách hàng
  Stream<AccountCommonPartnerReportState> _getReportStaffDetail(
      CustomerDebDetailReportLoaded event) async* {
    try {
      List<AccountCommonPartnerReport> listReportStaffSummaryState;

      final AccountCommonPartnerReportResult reportStaffSummaryResult =
          await _apiClient.getReportStaffDetail(
              partnerId: event.getReportStaffSummaryQuery.partnerId,
              dateFrom: event.getReportStaffSummaryQuery.dateFrom,
              dateTo: event.getReportStaffSummaryQuery.dateTo,
              skip: event.getReportStaffSummaryQuery.skip,
              page: event.getReportStaffSummaryQuery.page,
              pageSize: event.getReportStaffSummaryQuery.pageSize,
              resultSelection: event.getReportStaffSummaryQuery.resultSelection,
              take: event.getReportStaffSummaryQuery.take,
              type: event.type);
      listReportStaffSummaryState = reportStaffSummaryResult.data;
      _listAccountCommonPartnerReport = listReportStaffSummaryState;
      totalReportStaffSummary = reportStaffSummaryResult.total;
      yield AccountCommonPartnerReportLoading(
          listAccountCommonPartnerReportState: _listAccountCommonPartnerReport);
    } catch (e) {
      yield AccountCommonPartnerReportLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }
}
