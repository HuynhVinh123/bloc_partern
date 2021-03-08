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
import 'package:tpos_mobile/feature_group/category/partner_category/ui/partner_categories_page.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/blocs/account_common_partner_type_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/report_summary_partner_filter/account_common_partner_type_filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/report_summary_partner_filter/account_common_partner_type_filter_event.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/report_summary_partner_filter/account_common_partner_type_filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/uis/account_common_partner_type.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/company_of_user_list_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/user_report_staff_list_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';
import 'package:tpos_mobile/widgets/alive_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/scroll_tab_view.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class CustomerDebReportPage extends StatefulWidget {
  @override
  _CustomerDebReportPageState createState() => _CustomerDebReportPageState();
}

class _CustomerDebReportPageState extends State<CustomerDebReportPage> {
  final _filterBloc = FilterBloc();
  final Filter _filter = Filter();
  int _groupValue = 0;
  String displayFilter = 'all';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int type = 0;
  List<String> tabs = [
    S.current.filter_filterByCustomer,
    S.current.filter_filterByEmployee
  ];
  bool isFilterByStaff = false;
  bool isFilterByCompany = false;
  bool isFilterByPartner = false;
  bool isFilterByGroupPartner = false;

  final PageController _pageController = PageController(initialPage: 0);
  String valueTab;

  ///Đếm
  int _filterCount = 1;
  int _filterCountBadge = 1;
  int _filterCountDrawer = 1;
  final BehaviorSubject<int> _filterCountSubject = BehaviorSubject<int>();

  final AccountCommonPartnerReportBloc _reportStaffSummaryBloc =
      AccountCommonPartnerReportBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valueTab = 'Theo khách hàng';
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

  void handleChangeFilter({bool isConfirm = false}) {
    _filterBloc.add(FilterChanged(
        filterDateRange: _filter.filterDateRange,
        filterToDate: _filter.dateTo,
        filterFromDate: _filter.dateFrom,
        partner: _filter.partner,
        isFilterByGroupPartner: isFilterByGroupPartner,
        companyOfUser: _filter.companyOfUser,
        userReportStaffOrder: _filter.userReportStaffOrder,
        partnerCategory: _filter.partnerCategory,
        isFilterByCompany: isFilterByCompany,
        isFilterByPartner: isFilterByPartner,
        isFilterByStaff: isFilterByStaff,
        isFilterByInvoiceType: _filter.isFilterByInvoiceType,
        isFilterByDate: true,
        isConfirm: isConfirm));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _filterCountSubject.close();

    super.dispose();
  }

  ///Xây dụng giao diện header tab
  Widget _buildHeaderTab() {
    return Container(
      height: 48,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: 0,
        bottom: 0,
      ),
      child: ScrollTabViewHeader<String>(
        defaultIndex: 0,
        spaceBetweenItem: 0,
        padding: EdgeInsets.zero,
        headerBuilder: (BuildContext context, bool isSelected, String item) {
          return Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                width: 2,
                color:
                    isSelected ? const Color(0xff28A745) : Colors.transparent,
              ),
            )),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Center(
                  child: Text(
                    item,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xff28A745)
                          : const Color(0xff929DAA),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        objects: tabs,
        onSelectedChange: (String value) {
          final int index = tabs.indexOf(value);
          if (_pageController.page != index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
            setState(() {
              valueTab = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildBodyFilterDrawer(FilterLoadSuccess state) {
    return SingleChildScrollView(
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
            builder: (BuildContext context,
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
                title: Text(S.current.employee),
                children: <Widget>[
                  Container(
                    height: 45,
                    margin:
                        const EdgeInsets.only(left: 32, right: 8, bottom: 12),
                    width: MediaQuery.of(context).size.width,
                    child: InkWell(
                      onTap: () async {
                        final UserReportStaff result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UserReportStaffListPage();
                            },
                          ),
                        );
                        if (result != null) {
                          _filter.userReportStaffOrder = result;
                          setState(() {});
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                                _filter.userReportStaffOrder?.text ??
                                    S.current.employee,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 15)),
                          ),
                          Visibility(
                            visible: _filter.userReportStaffOrder?.text != null,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () {
                                _filter.userReportStaffOrder =
                                    UserReportStaff();
                                setState(() {});
                                // handleChangeFilter();
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
          if (_pageController.page == 0)
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
                  //_vm.isFilterByTypeAccountPayment = value,
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
          StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AppFilterPanel(
                isEnable: true,
                isSelected: isFilterByPartner ?? false,
                onSelectedChange: (bool value) {
                  _filter.isFilterByPartner = value;
                  isFilterByPartner = value;
                  if (isFilterByPartner) {
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
                //_vm.isFilterByTypeAccountPayment = value,
                /// Khách hàng
                title: Text(S.current.partner),
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
                              return const PartnerSearchPage();
                            },
                          ),
                        );
                        if (result != null) {
                          _filter.partner = result;
                          setState(() {});
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            /// Khách hàng
                            child: Text(
                                _filter.partner?.name ?? S.current.partner,
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
                isSelected: isFilterByGroupPartner ?? false,
                onSelectedChange: (bool value) {
                  _filter.isFilterByGroupPartner = value;
                  isFilterByGroupPartner = value;
                  if (isFilterByGroupPartner) {
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
                // _vm.isFilterByTypeAccountPayment = value,
                /// Nhóm khách hàng
                // ignore: unnecessary_string_interpolations
                title: Text('${S.current.customerGroups}'),
                children: <Widget>[
                  Container(
                    height: 45,
                    margin:
                        const EdgeInsets.only(left: 32, right: 8, bottom: 12),
                    width: MediaQuery.of(context).size.width,
                    child: InkWell(
                      onTap: () async {
                        final PartnerCategory result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const PartnerCategoriesPage(
                                isSearchMode: true,
                                isSearch: true,
                              );
                            },
                          ),
                        );
                        if (result != null) {
                          _filter.partnerCategory = result;
                          setState(() {});
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            /// Nhóm khách hàng
                            child: Text(
                                _filter.partnerCategory?.name ??
                                    S.current.customerGroups,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 15)),
                          ),
                          Visibility(
                            visible: _filter.partnerCategory?.name != null,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () {
                                _filter.partnerCategory = PartnerCategory();
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
              // ignore: unnecessary_string_interpolations
              '${S.current.display}',
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
                    // ignore: unnecessary_string_interpolations
                    "${S.current.other0Debt}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    return BlocConsumer<FilterBloc, FilterState>(
        listener: (context, state) {
          if (state is FilterLoadSuccess) {}
        },
        cubit: _filterBloc,
        builder: (context, state) {
          if (state is FilterLoadSuccess) {
            _filter.userReportStaffOrder = state.userReportStaffOrder;
            _filter.companyOfUser = state.companyOfUser;
            _filter.partner = state.partner;
            _filter.partnerCategory = state.partnerCategory;
            _filter.dateFrom = state.filterFromDate;
            _filter.dateTo = state.filterToDate;
            _filter.filterDateRange = state.filterDateRange;
            isFilterByStaff = state.isFilterByStaff ?? false;
            isFilterByCompany = state.isFilterByCompany ?? false;
            isFilterByPartner = state.isFilterByPartner ?? false;
            isFilterByGroupPartner = state.isFilterByGroupPartner ?? false;

            _filterCount = 1;
            if (isFilterByStaff) {
              _filterCount += 1;
            }
            if (isFilterByCompany) {
              _filterCount += 1;
            }

            if (isFilterByPartner) {
              _filterCount += 1;
            }
            if (isFilterByGroupPartner) {
              _filterCount += 1;
            }
            _filterCountSubject.sink.add(_filterCount);
            return StreamBuilder<int>(
              stream: _filterCountSubject.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (valueTab == 'Theo nhân viên' && isFilterByCompany) {
                  _filterCountDrawer = _filterCount - 1;
                } else if (valueTab == 'Theo khách hàng' && isFilterByCompany) {
                  _filterCountDrawer = _filterCount;
                } else {
                  _filterCountDrawer = _filterCount;
                }
                return AppFilterDrawerContainer(
                  countFilter: _filterCountDrawer,
                  onRefresh: () {
                    _filter.isFilterByDate = false;
                    _filter.isFilterByStaff = false;
                    _filter.isFilterByPartner = false;
                    _filter.isFilterByCompany = false;
                    _filter.isFilterByGroupPartner = false;
                    _filter.userReportStaffOrder = null;
                    _filter.companyOfUser = null;
                    _filter.partner = null;
                    _filter.partnerCategory = null;
                    isFilterByStaff = false;
                    isFilterByPartner = false;
                    isFilterByCompany = false;
                    isFilterByGroupPartner = false;
                    setState(() {
                      _filterCount = 1;
                      _filterCountBadge = 1;
                    });

                    if (_pageController.page == 0) {
                      type = 0;
                    } else if (_pageController.page == 1) {
                      type = 1;
                    }
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
                                    resultSelection: 'customer',
                                    skip: 0,
                                    take: 20),
                            type: type));
                    handleChangeFilter(isConfirm: true);
                  },
                  closeWhenConfirm: false,
                  onApply: () {
                    if (_pageController.page == 0) {
                      type = 0;
                    } else if (_pageController.page == 1) {
                      type = 1;
                    }
                    if (_groupValue == 0) {
                      displayFilter = 'all';
                    } else {
                      displayFilter = 'not_zero';
                    }
                    setState(() {
                      _filterCountBadge = _filterCount;
                    });
                    _filter.display = displayFilter;
                    handleChangeFilter(isConfirm: true);
                    if (_filter?.userReportStaffOrder?.value == null &&
                        isFilterByStaff) {
                      App.showDefaultDialog(
                        title: S.current.warning,
                        content: S.current.filter_ErrorSelectEmployee,
                        type: AlertDialogType.warning,
                        context: context,
                      );
                    } else if (_filter?.companyOfUser?.value == null &&
                        isFilterByCompany) {
                      App.showDefaultDialog(
                          title: S.current.warning,
                          content: S.current.filter_ErrorSelectCompany,
                          type: AlertDialogType.warning,
                          context: context);
                    } else if (_filter?.partner?.id == null &&
                        isFilterByPartner) {
                      App.showDefaultDialog(
                          title: S.current.warning,
                          content: S.current.filter_ErrorSelectCustomer,
                          type: AlertDialogType.warning,
                          context: context);
                    } else if (_filter?.partnerCategory?.id == null &&
                        isFilterByGroupPartner) {
                      App.showDefaultDialog(
                          title: S.current.warning,
                          content: S.current.pleaseChoosePartnerGroup,
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
                                      userId: isFilterByStaff
                                          ? _filter.userReportStaffOrder?.value
                                          : null,
                                      companyId: isFilterByCompany
                                          ? _filter.companyOfUser?.value
                                          : null,
                                      categId: isFilterByGroupPartner
                                          ? _filter.partnerCategory?.id
                                              ?.toString()
                                          : null,
                                      partnerId: isFilterByPartner
                                          ? _filter.partner?.id?.toString()
                                          : null,
                                      display: displayFilter,
                                      page: 1,
                                      pageSize: 20,
                                      resultSelection: 'customer',
                                      skip: 0,
                                      take: 20),
                              type: type));
                    }
                  },
                  child: _buildBodyFilterDrawer(state),
                );
              },
            );
          }
          return const SizedBox();
        });
  }

  @override
  Widget build(BuildContext context) {
    if (valueTab == 'Theo nhân viên' && isFilterByCompany) {
      _filterCountBadge = _filterCount - 1;
    } else if (valueTab == 'Theo khách hàng' && isFilterByCompany) {
      _filterCountBadge = _filterCount;
    }
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
          title: Text('${S.current.menu_customerDeptReport ?? ''}'),
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
                  _filterCountBadge.toString(),
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
        body: Column(
          children: [
            _buildHeaderTab(),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  AliveState(
                    child: AccountCommonPartnerType(
                      bloc: _reportStaffSummaryBloc,
                      filter: _filter,
                      scaffoldKey: _scaffoldKey,
                      type: 0,
                      resultSelection: 'customer',
                    ),
                  ),
                  AliveState(
                    child: AccountCommonPartnerType(
                      bloc: _reportStaffSummaryBloc,
                      filter: _filter,
                      scaffoldKey: _scaffoldKey,
                      type: 1,
                      resultSelection: 'customer',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
