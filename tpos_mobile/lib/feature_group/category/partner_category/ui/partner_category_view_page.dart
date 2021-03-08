import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/add_edit/partner_category_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/add_edit/partner_category_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/add_edit/partner_category_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/ui/partner_category_add_edit_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PartnerCategoryViewPage extends StatefulWidget {
  const PartnerCategoryViewPage({Key key, this.partnerCategory})
      : super(key: key);

  @override
  _PartnerCategoryViewPageState createState() =>
      _PartnerCategoryViewPageState();
  final PartnerCategory partnerCategory;
}

class _PartnerCategoryViewPageState extends State<PartnerCategoryViewPage> {
  bool _change = false;
  PartnerCategoryAddEditBloc _partnerCategoryAddEditBloc;
  PartnerCategory _partnerCategory;

  @override
  void initState() {
    _partnerCategoryAddEditBloc = PartnerCategoryAddEditBloc();
    _partnerCategoryAddEditBloc.add(
        PartnerCategoryAddEditLoaded(partnerCategory: widget.partnerCategory));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _partnerCategoryAddEditBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_change) {
          Navigator.of(context).pop(_partnerCategory);
        } else {
          Navigator.of(context).pop();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        S.of(context).partnerCategory,
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_change) {
              Navigator.of(context).pop(_partnerCategory);
            } else {
              Navigator.of(context).pop();
            }
          }),
      actions: [
        IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () async {
              final PartnerCategory partnerCategory = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PartnerCategoryAddEditPage(
                      partnerCategory: widget.partnerCategory,
                      bloc: _partnerCategoryAddEditBloc,
                    );
                  },
                ),
              );

              if (partnerCategory != null) {
                _change = true;
              }
            }),
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<PartnerCategoryAddEditBloc,
        PartnerCategoryAddEditState>(
      bloc: _partnerCategoryAddEditBloc,
      loadingState: PartnerCategoryAddEditLoading,
      busyState: PartnerCategoryAddEditBusy,
      errorState: PartnerCategoryAddEditLoadFailure,
      errorBuilder: (BuildContext context, PartnerCategoryAddEditState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is PartnerCategoryAddEditLoadFailure) {
          error = state.message ?? S.of(context).canNotGetDataFromServer;
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.of(context).loadDataError,
                content: error,
                statusIcon: SvgPicture.asset('assets/icon/error.svg',
                    width: 170, height: 130),
                action: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AppButton(
                    onPressed: () {
                      _partnerCategoryAddEditBloc.add(
                          PartnerCategoryAddEditLoaded(
                              partnerCategory: widget.partnerCategory));
                    },
                    width: null,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 40, 167, 69),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FontAwesomeIcons.sync,
                            color: Colors.white,
                            size: 23,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            S.of(context).refreshPage,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      builder: (BuildContext context, PartnerCategoryAddEditState state) {
        if (state is PartnerCategoryAddEditLoadSuccess) {
          _partnerCategory = state.partnerCategory;
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(_partnerCategory),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(
                      title: S.of(context).rootCategory,
                      value: _partnerCategory.parent != null
                          ? _partnerCategory.parent.name ?? ''
                          : '')),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: _buildFieldRow(
                      title: S.of(context).discount,
                      value: _partnerCategory.discount.toString() ?? "0")),
            ],
          ),
        );
      },
    );
  }

  ///Xây dựng giao diện hiện thị trường dữ liệu theo dạng hàng
  Widget _buildFieldRow({String title, String value}) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(title,
                      style: const TextStyle(
                          color: Color(0xff2C333A), fontSize: 17))),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(value,
                    style: const TextStyle(
                        color: Color(0xff6B7280), fontSize: 17)),
              )),
            ],
          ),
          const SizedBox(height: 10),
          Container(
              color: Colors.grey.shade200, height: 1, width: double.infinity),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  ///Xây dựng tên của nhóm sản phẩm đứng đầu
  Widget _buildHeader(PartnerCategory partnerCategory) {
    return Container(
      color: const Color(0xffF8F9FB),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).partnerCategory.toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xff929DAA), fontSize: 15)),
                Text(partnerCategory.name,
                    style: const TextStyle(
                        color: Color(0xff2C333A), fontSize: 21)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SvgPicture.asset('assets/icon/product_category.svg'),
        ],
      ),
    );
  }
}
