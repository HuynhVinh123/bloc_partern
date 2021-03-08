import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/category/partner/partner_search_page.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/blocs/account_common_partner_type_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/report_summary_partner_filter/account_common_partner_type_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/report_summary_partner_filter/account_common_partner_type_filter_event.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/report_summary_partner_filter/account_common_partner_type_filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/uis/account_common_partner_type.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/company_of_user_list_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class ReportSupplierPage extends StatefulWidget {
  @override
  _ReportSupplierPageState createState() => _ReportSupplierPageState();
}

class _ReportSupplierPageState extends State<ReportSupplierPage> {
  final _filterBloc = FilterBloc();
  final Filter _filter = Filter();
  int _groupValue = 0;
  String displayFilter = 'all';

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final AccountCommonPartnerReportBloc _reportStaffSummaryBloc =
      AccountCommonPartnerReportBloc();

  int count = 0;
  // bool isFilterByDate = false;
  bool isFilterByStaff = false;
  bool isFilterByCompany = false;

  ///Đếm
  int _filterCount = 1;
  int _counterBadge = 1;
  final BehaviorSubject<int> _filterCountSubject = BehaviorSubject<int>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filterCountSubject.sink.add(_filterCount);
    _filter.filterDateRange = getTodayDateFilter();
    _filter.dateFrom = _filter.filterDateRange.fromDate;
    _filter.dateTo = _filter.filterDateRange.toDate;
    _filter.userReportStaffOrder = UserReportStaff();
    _filter.companyOfUser = CompanyOfUser();
    _filter.partner = Partner();
    _filter.partnerCategory = PartnerCategory();
    _filterBloc.add(FilterLoaded());
  }

  @override
  void dispose() {
    _filterCountSubject.close();
    super.dispose();
  }

  void handleChangeFilter({bool isConfirm = false}) {
    _filterBloc.add(FilterChanged(
        filterDateRange: _filter.filterDateRange,
        filterToDate: _filter.dateTo,
        filterFromDate: _filter.dateFrom,
        partner: _filter.partner,
        isFilterByGroupPartner: _filter.isFilterByGroupPartner,
        companyOfUser: _filter.companyOfUser,
        userReportStaffOrder: _filter.userReportStaffOrder,
        isFilterByCompany: isFilterByCompany,
        isFilterByPartner: _filter.isFilterByPartner,
        isFilterByStaff: isFilterByStaff,
        isFilterByInvoiceType: _filter.isFilterByInvoiceType,
        isFilterByDate: true,
        isConfirm: isConfirm));
  }

  Widget _buildBodyFilterDrawer(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return AppFilterDateTime(
                  isSelected: true,
                  initDateRange: _filter.filterDateRange,
                  onSelectChange: (value) {
                    _filter.isFilterByDate = value;
                    setState(() {});
                  },
                  toDate: _filter.dateTo,
                  fromDate: _filter.dateFrom,
                  dateRangeChanged: (value) {
                    _filter.filterDateRange = value;
                    handleChangeFilter();
                  },
                  onFromDateChanged: (value) {
                    _filter.dateFrom = value;
                    handleChangeFilter();
                  },
                  onToDateChanged: (value) {
                    _filter.dateTo = value;
                    handleChangeFilter();
                  },
                );
              },
            ),
            StatefulBuilder(
              builder: (BuildContext context1,
                  void Function(void Function()) setState) {
                return AppFilterPanel(
                  isEnable: true,
                  isSelected: isFilterByStaff ?? false,
                  onSelectedChange: (bool value) {
                    _filter.isFilterByStaff = value;
                    isFilterByStaff = value;

                    if (isFilterByStaff) {
                      _filterCount += 1;
                      _filterCountSubject.sink.add(_filterCount);
                    } else {
                      _filterCount -= 1;
                      if (_filterCount < 0) {
                        _filterCount = 0;
                      }
                      _filterCountSubject.sink.add(_filterCount);
                    }
                    setState(() {});
                  },
                  // ignore: unnecessary_string_interpolations
                  title: Text('${S.current.supplier}'),
                  children: <Widget>[
                    Container(
                      height: 45,
                      margin:
                          const EdgeInsets.only(left: 32, right: 8, bottom: 12),
                      width: MediaQuery.of(context).size.width,
                      child: InkWell(
                        onTap: () async {
                          final Partner result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const PartnerSearchPage(
                                  isSupplier: true,
                                  isCustomer: false,
                                );
                              },
                            ),
                          );
                          if (result != null) {
                            _filter.partner = result;
                            // isFilterByStaff = true;
                            // handleChangeFilter();
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  _filter.partner?.name ?? S.current.supplier,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 15)),
                            ),
                            Visibility(
                              visible: _filter.partner?.name != null,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _filter.partner = Partner();
                                  setState(() {});
                                },
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
            StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return AppFilterPanel(
                  isEnable: true,
                  isSelected: isFilterByCompany ?? false,
                  onSelectedChange: (bool value) {
                    _filter.isFilterByCompany = value;
                    isFilterByCompany = value;
                    if (isFilterByCompany) {
                      _filterCount += 1;
                      _filterCountSubject.sink.add(_filterCount);
                    } else {
                      _filterCount -= 1;
                      if (_filterCount < 0) {
                        _filterCount = 0;
                      }
                      _filterCountSubject.sink.add(_filterCount);
                    }
                    setState(() {});
                  },

                  /// Công ty
                  title: Text(S.current.company),
                  children: <Widget>[
                    Container(
                      height: 45,
                      margin:
                          const EdgeInsets.only(left: 32, right: 8, bottom: 12),
                      width: MediaQuery.of(context).size.width,
                      child: InkWell(
                        onTap: () async {
                          final CompanyOfUser result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CompanyOfUserListPage();
                              },
                            ),
                          );
                          if (result != null) {
                            _filter.companyOfUser = result;
                            // isFilterByCompany = true;
                            // handleChangeFilter();
                            setState(() {});
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  _filter.companyOfUser?.text ??
                                      S.current.company,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 15)),
                            ),
                            Visibility(
                              visible: _filter.companyOfUser?.text != null,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _filter.companyOfUser = CompanyOfUser();
                                  setState(() {});
                                },
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17, top: 10),
              child: Text(
                S.current.display,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return Row(
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: _groupValue,
                      onChanged: (value) {
                        setState(() {
                          _groupValue = value;
                        });
                      },
                    ),
                    Text(
                      // ignore: unnecessary_string_interpolations
                      "${S.current.all}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Radio(
                      value: 1,
                      groupValue: _groupValue,
                      onChanged: (value) {
                        setState(() {
                          _groupValue = value;
                        });
                      },
                    ),
                    Text(
                      S.current.other0Debt,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return BlocBuilder<FilterBloc, FilterState>(
        cubit: _filterBloc,
        builder: (context, state) {
          if (state is FilterLoadSuccess) {
            _filter.dateFrom = state.filterFromDate;
            _filter.dateTo = state.filterToDate;
            _filter.filterDateRange = state.filterDateRange;
            // isFilterByDate = state.isFilterByDate ?? false;
            isFilterByStaff = state.isFilterByStaff ?? false;
            isFilterByCompany = state.isFilterByCompany ?? false;
            _filter.partner = state.partner;
            _filter.companyOfUser = state.companyOfUser;

            ///
            _filterCount = 1;
            if (isFilterByStaff ?? false) {
              _filterCount += 1;
            }
            if (isFilterByCompany ?? false) {
              _filterCount += 1;
            }
            _filterCountSubject.sink.add(_filterCount);

            return StreamBuilder<int>(
                stream: _filterCountSubject.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return AppFilterDrawerContainer(
                    countFilter: _filterCount,
                    onRefresh: () {
                      _filter.isFilterByDate = false;
                      _filter.isFilterByStaff = false;
                      _filter.isFilterByPartner = false;
                      _filter.isFilterByCompany = false;
                      _filter.isFilterByGroupPartner = false;
                      // isFilterByDate = false;
                      isFilterByStaff = false;
                      isFilterByCompany = false;

                      setState(() {
                        _counterBadge = 1;
                        _filterCount = 1;
                      });
                      _filter.partner = null;
                      _filter.companyOfUser = null;
                      handleChangeFilter(isConfirm: true);
                      Navigator.pop(context);
                      _reportStaffSummaryBloc.add(
                          AccountCommonPartnerReportLoaded(
                              getReportStaffSummaryQuery:
                                  GetAccountCommonPartnerReportQuery(
                                      dateTo: _filter.dateTo,
                                      dateFrom: _filter.dateFrom,
                                      userId: null,
                                      companyId: null,
                                      categId: null,
                                      partnerId: null,
                                      display: 'all',
                                      page: 1,
                                      pageSize: 20,
                                      resultSelection: 'supplier',
                                      skip: 0,
                                      take: 20),
                              type: 0));
                    },
                    closeWhenConfirm: false,
                    onApply: () {
                      handleChangeFilter(isConfirm: false);

                      if (_groupValue == 0) {
                        displayFilter = 'all';
                      } else {
                        displayFilter = 'not_zero';
                      }
                      setState(() {
                        _counterBadge = _filterCount;
                      });
                      _filter.display = displayFilter;
                      if (_filter?.partner?.id == null && isFilterByStaff) {
                        App.showDefaultDialog(
                            title: S.current.warning,
                            content: S.current.pleaseChooseSupplier,
                            type: AlertDialogType.warning,
                            context: context);
                      } else if (_filter?.companyOfUser?.value == null &&
                          isFilterByCompany) {
                        App.showDefaultDialog(
                            title: S.current.warning,
                            content: S.current.filter_ErrorSelectCompany,
                            type: AlertDialogType.warning,
                            context: context);
                      } else {
                        Navigator.pop(context);
                        _reportStaffSummaryBloc.add(
                            AccountCommonPartnerReportLoaded(
                                getReportStaffSummaryQuery:
                                    GetAccountCommonPartnerReportQuery(
                                        dateTo: _filter.dateTo,
                                        dateFrom: _filter.dateFrom,
                                        userId:
                                            _filter.userReportStaffOrder?.value,
                                        companyId: isFilterByCompany
                                            ? _filter.companyOfUser?.value
                                            : null,
                                        categId: _filter.partnerCategory?.id
                                            ?.toString(),
                                        partnerId: isFilterByStaff
                                            ? _filter.partner?.id?.toString()
                                            : null,
                                        display: displayFilter,
                                        page: 1,
                                        pageSize: 20,
                                        resultSelection: 'supplier',
                                        skip: 0,
                                        take: 20),
                                type: 0));
                      }
                    },
                    child: _buildBodyFilterDrawer(context),
                  );
                });
          }
          return const SizedBox();
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<AccountCommonPartnerReportBloc>(
      bloc: _reportStaffSummaryBloc,
      listen: (state) {
        if (state is AccountCommonPartnerReportLoadFailure) {
          showError(
              title: state.title, message: state.content, context: context);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: _buildFilterPanel(),
        appBar: AppBar(
          backgroundColor: const Color(0xFF008E30),
          // ignore: unnecessary_string_interpolations
          title: Text('${S.current.menu_supplierDeptReport}'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            InkWell(
              onTap: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
              child: Badge(
                position: const BadgePosition(top: 4, end: -4),
                padding: const EdgeInsets.all(4),
                badgeColor: Colors.redAccent,
                badgeContent: Text(
                  '$_counterBadge',
                  style: const TextStyle(color: Colors.white),
                ),
                child: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: AccountCommonPartnerType(
          bloc: _reportStaffSummaryBloc,
          filter: _filter,
          scaffoldKey: _scaffoldKey,
          type: 0,
          resultSelection: 'supplier',
        ),
      ),
    );
  }
}
