import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/category/partner/partner_category_page.dart';
import 'package:tpos_mobile/feature_group/category/partner/partner_search_page.dart';
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
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class CustomerDebReportPage extends StatefulWidget {
  @override
  _CustomerDebReportPageState createState() => _CustomerDebReportPageState();
}

class _CustomerDebReportPageState extends State<CustomerDebReportPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  final _filterBloc = FilterBloc();
  final Filter _filter = Filter();
  int _groupValue = 0;
  String displayFilter = 'all';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int type = 0;
  int count = 0;
  final AccountCommonPartnerReportBloc _reportStaffSummaryBloc =
      AccountCommonPartnerReportBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _filter.filterDateRange = getTodayDateFilter();
    _filter.dateFrom = _filter.filterDateRange.fromDate;
    _filter.dateTo = _filter.filterDateRange.toDate;
    _filter.userReportStaffOrder = UserReportStaff();
    _filter.companyOfUser = CompanyOfUser();
    _filter.partner = Partner();
    _filter.partnerCategory = PartnerCategory();
    _filterBloc.add(FilterLoaded());
  }

  int countValueFilter(bool isValue) {
    if (isValue) {
      count++;
    } else {
      count--;
      if (count < 0) {
        count = 0;
      }
    }
    return count;
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
        isFilterByCompany: _filter.isFilterByCompany,
        isFilterByPartner: _filter.isFilterByPartner,
        isFilterByStaff: _filter.isFilterByStaff,
        isFilterByInvoiceType: _filter.isFilterByInvoiceType,
        isFilterByDate: _filter.isFilterByDate,
        isConfirm: isConfirm));
  }

  Widget _buildBodyFilterDrawer(FilterLoadSuccess state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppFilterDateTime(
            isSelected: state.isFilterByDate ?? false,
            initDateRange: _filter.filterDateRange,
            onSelectChange: (value) {
              _filter.isFilterByDate = value;
              countValueFilter(_filter.isFilterByDate);
              handleChangeFilter();
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
          ),
          AppFilterPanel(
            isEnable: true,
            isSelected: state.isFilterByStaff ?? false,
            onSelectedChange: (bool value) {
              _filter.isFilterByStaff = value;
              countValueFilter(_filter.isFilterByStaff);
              handleChangeFilter();
            },
            title: Text(S.current.employee),
            children: <Widget>[
              Container(
                height: 45,
                margin: const EdgeInsets.only(left: 32, right: 8, bottom: 12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[400]))),
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
                      handleChangeFilter();
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
                            _filter.userReportStaffOrder = UserReportStaff();
                            handleChangeFilter();
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
          ),
          AppFilterPanel(
            isEnable: true,
            isSelected: state.isFilterByCompany ?? false,
            onSelectedChange: (bool value) {
              _filter.isFilterByCompany = value;
              countValueFilter(_filter.isFilterByCompany);
              handleChangeFilter();
            },
            //_vm.isFilterByTypeAccountPayment = value,
            /// Công ty
            title: Text(S.current.company),
            children: <Widget>[
              Container(
                height: 45,
                margin: const EdgeInsets.only(left: 32, right: 8, bottom: 12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[400]))),
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
                      handleChangeFilter();
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                            _filter.companyOfUser?.text ?? S.current.company,
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
                            handleChangeFilter();
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
          ),
          AppFilterPanel(
            isEnable: true,
            isSelected: state.isFilterByPartner ?? false,
            onSelectedChange: (bool value) {
              _filter.isFilterByPartner = value;
              countValueFilter(_filter.isFilterByPartner);
              handleChangeFilter();
            },
            //_vm.isFilterByTypeAccountPayment = value,
            /// Khách hàng
            title: Text(S.current.partner),
            children: <Widget>[
              Container(
                height: 45,
                margin: const EdgeInsets.only(left: 32, right: 8, bottom: 12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[400]))),
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
                      handleChangeFilter();
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        /// Khách hàng
                        child: Text(_filter.partner.name ?? S.current.partner,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 15)),
                      ),
                      Visibility(
                        visible: _filter.partner.name != null,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            _filter.partner = Partner();
                            handleChangeFilter();
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
          ),
          AppFilterPanel(
            isEnable: true,
            isSelected: state.isFilterByGroupPartner ?? false,
            onSelectedChange: (bool value) {
              print(value);
              _filter.isFilterByGroupPartner = value;
              countValueFilter(_filter.isFilterByGroupPartner);
              handleChangeFilter();
            },
            // _vm.isFilterByTypeAccountPayment = value,
            /// Nhóm khách hàng
            title: const Text('Nhóm khách hàng'),
            children: <Widget>[
              Container(
                height: 45,
                margin: const EdgeInsets.only(left: 32, right: 8, bottom: 12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[400]))),
                child: InkWell(
                  onTap: () async {
                    final PartnerCategory result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const PartnerCategoryPage();
                        },
                      ),
                    );
                    if (result != null) {
                      _filter.partnerCategory = result;
                      handleChangeFilter();
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        /// Nhóm khách hàng
                        child: Text(
                            _filter.partnerCategory.name ?? 'Nhóm khách hàng',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 15)),
                      ),
                      Visibility(
                        visible: _filter.partnerCategory.name != null,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            _filter.partnerCategory = PartnerCategory();
                            handleChangeFilter();
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
          ),
          const Padding(
            padding: EdgeInsets.only(left: 17, top: 10),
            child: Text(
              "Hiển thị",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Row(
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
              const Text(
                "Tất cả",
                style: TextStyle(fontSize: 14),
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
              const Text(
                "Nợ khác 0",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
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
            return AppFilterDrawerContainer(
              countFilter: count,
              onRefresh: () {
                _filter.isFilterByDate = false;
                _filter.isFilterByStaff = false;
                _filter.isFilterByPartner = false;
                _filter.isFilterByCompany = false;
                _filter.isFilterByGroupPartner = false;
                count = 0;
                handleChangeFilter(isConfirm: true);
              },
              closeWhenConfirm: true,
              onApply: () {
                handleChangeFilter(isConfirm: true);
                if (_controller.index == 0) {
                  type = 0;
                } else if (_controller.index == 1) {
                  type = 1;
                }
                if (_groupValue == 0) {
                  displayFilter = 'all';
                } else {
                  displayFilter = 'not_zero';
                }
                _filter.display = displayFilter;
                _reportStaffSummaryBloc.add(AccountCommonPartnerReportLoaded(
                    getReportStaffSummaryQuery:
                        GetAccountCommonPartnerReportQuery(
                            dateTo: _filter.dateTo,
                            dateFrom: _filter.dateFrom,
                            userId: _filter.userReportStaffOrder.value,
                            companyId: _filter.companyOfUser.value,
                            categId: _filter.partnerCategory.id.toString(),
                            partnerId: _filter.partner.id.toString(),
                            display: displayFilter,
                            page: 1,
                            pageSize: 20,
                            resultSelection: 'customer',
                            skip: 0,
                            take: 20),
                    type: type));
              },
              child: _buildBodyFilterDrawer(state),
            );
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
          title: const Text('Công nợ khách hàng'),
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
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: const Color(0xFF28A745),
              labelColor: const Color(0xFF28A745),
              unselectedLabelColor: Colors.black54,
              dragStartBehavior: DragStartBehavior.down,
              controller: _controller,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const <Tab>[
                Tab(text: 'Theo khách hàng'),
                Tab(text: 'Theo nhân viên'),
              ],
            ),
            Expanded(
                child: TabBarView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                AccountCommonPartnerType(
                  bloc: _reportStaffSummaryBloc,
                  filter: _filter,
                  scaffoldKey: _scaffoldKey,
                  type: 0,
                  resultSelection: 'customer',
                ),
                AccountCommonPartnerType(
                  bloc: _reportStaffSummaryBloc,
                  filter: _filter,
                  scaffoldKey: _scaffoldKey,
                  resultSelection: 'customer',
                  type: 1,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
