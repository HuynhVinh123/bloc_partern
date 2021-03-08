import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/add_edit/partner_category_add_edit_bloc.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/add_edit/partner_category_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/add_edit/partner_category_add_edit_state.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/ui/partner_categories_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PartnerCategoryAddEditPage extends StatefulWidget {
  const PartnerCategoryAddEditPage({Key key, this.partnerCategory, this.bloc})
      : super(key: key);

  @override
  _PartnerCategoryAddEditPageState createState() =>
      _PartnerCategoryAddEditPageState();
  final PartnerCategory partnerCategory;
  final PartnerCategoryAddEditBloc bloc;
}

class _PartnerCategoryAddEditPageState
    extends State<PartnerCategoryAddEditPage> {
  PartnerCategory _partnerCategory;

  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _discountController = TextEditingController();
  final FocusNode _discountFocusNode = FocusNode();
  PartnerCategoryAddEditBloc _partnerCategoryAddEditBloc;

  void initState() {
    _partnerCategoryAddEditBloc = widget.bloc ?? PartnerCategoryAddEditBloc();
    if (widget.bloc == null) {
      _partnerCategoryAddEditBloc.add(
        PartnerCategoryAddEditLoaded(partnerCategory: widget.partnerCategory),
      );
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        widget.partnerCategory != null
            ? S
                .of(context)
                .editParam(S.of(context).partnerCategory.toLowerCase())
            : S
                .of(context)
                .addParam(S.of(context).partnerCategory.toLowerCase()),
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      actions: [
        IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              _handleSave();
            })
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
      listener: (BuildContext context, PartnerCategoryAddEditState state) {
        if (state is PartnerCategoryAddEditLoadFailure) {
          App.showDefaultDialog(
              title: S.of(context).error,
              context: context,
              type: AlertDialogType.error,
              content: S.of(context).network_noInternetConnection);
        } else if (state is PartnerCategoryEditSaveSuccess) {
          App.showToast(
            type: AlertDialogType.success,
            title: S.current.success,
            message: S.of(context).successfullyParam(S.of(context).edit),
          );
          _partnerCategory = state.partnerCategory;
          Navigator.of(context).pop(_partnerCategory);
        } else if (state is PartnerCategoryAddSaveSuccess) {
          App.showToast(
            type: AlertDialogType.success,
            title: S.current.success,
            message: S.of(context).successfullyParam(S.of(context).add),
          );
          _partnerCategory = state.partnerCategory;
          Navigator.of(context).pop(_partnerCategory);
        } else if (state is PartnerCategoryAddEditLoadSuccess) {
          if (state is PartnerCategoryAddEditNameError) {
            App.showDefaultDialog(
                title: S.of(context).warning,
                context: context,
                type: AlertDialogType.warning,
                content: S.of(context).pleaseEnterGroupName);
          }
        } else if (state is PartnerCategoryAddEditSaveError) {
          App.showDefaultDialog(
              title: S.of(context).error,
              context: context,
              type: AlertDialogType.error,
              content: state.message);
        }
      },
      builder: (BuildContext context, PartnerCategoryAddEditState state) {
        bool errorName = false;
        if (state is PartnerCategoryAddEditLoadSuccess) {
          _partnerCategory = state.partnerCategory;
          _partnerCategory = state.partnerCategory;
          _nameController.text = _partnerCategory.name;
          _discountController.text = _partnerCategory.discount.toString();
          if (state is PartnerCategoryAddEditNameError) {
            errorName = true;
          }
        }
        return _partnerCategory != null
            ? Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 10, top: 10),
                              child: _buildInputName(error: errorName)),
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: _buildSelectParent(state)),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 10, top: 10),
                              child: _buildInputDiscount()),
                          const SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: _buildButton(),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                        height:
                            50 * (MediaQuery.of(context).size.height / 700)),
                    LoadStatusWidget(
                      statusName: S.of(context).loadDataError,
                      content: S.of(context).canNotGetDataFromServer,
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
    );
  }

  ///Xây dựng giao diện nhập tên
  Widget _buildInputName({bool error = false}) {
    return TextField(
      controller: _nameController,
      focusNode: _nameFocusNode,
      maxLines: 1,
      style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(right: 10, bottom: 10),
        enabledBorder: error
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
        hintText: S.of(context).partnerCategoryName,
        hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
        focusedBorder: error
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff28A745)),
              ),
      ),
    );
  }

  ///Xây dựng giao diện nhập chiết khấu
  Widget _buildInputDiscount({bool error = false}) {
    return TextField(
      onTap: () => _discountController.selection = TextSelection(
          baseOffset: 0, extentOffset: _discountController.value.text.length),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
      ],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: _discountController,
      focusNode: _discountFocusNode,
      maxLines: 1,
      style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(right: 10, bottom: 10),
        enabledBorder: error
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
        hintText: S.of(context).discount,
        hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
        focusedBorder: error
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )
            : const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff28A745)),
              ),
      ),
    );
  }

  ///Giao diện chọn nhóm cha
  Widget _buildSelectParent(state) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return InkWell(
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final PartnerCategory result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PartnerCategoriesPage(
                    isSearchMode: true,
                    isSearch: true,
                    selectedItems: _partnerCategory.parent != null
                        ? [_partnerCategory.parent]
                        : [],
                    current: _partnerCategory,
                  );
                },
              ),
            );

            if (result != null) {
              _partnerCategory.parent = result;
              _partnerCategory.parentId = result.id;
            }
          },
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).rootCategory,
                            style: const TextStyle(
                                color: Color(0xff2C333A), fontSize: 17)),
                        const SizedBox(height: 7),
                        if (_partnerCategory.parent != null)
                          Text(_partnerCategory.parent.name ?? '',
                              style: const TextStyle(
                                  color: Color(0xff929DAA), fontSize: 15))
                        else
                          Text(
                              S.of(context).selectParam(S
                                  .of(context)
                                  .rootProductCategory
                                  .toLowerCase()),
                              style: const TextStyle(
                                  color: Color(0xff929DAA), fontSize: 15)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 15, color: Color(0xff929DAA)),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                  color: Colors.grey.shade200,
                  height: 1,
                  width: double.infinity),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  ///Giao diện nút lưu
  Widget _buildButton() {
    return AppButton(
      width: double.infinity,
      onPressed: () {
        _handleSave();
      },
      background: const Color(0xff28A745),
      child: Text(
        widget.partnerCategory != null ? S.of(context).save : S.of(context).add,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  ///Lưu thông tin
  void _handleSave() {
    if (_partnerCategory != null) {
      _partnerCategory.name = _nameController.text;
      if (_discountController.text != null && _discountController.text != "") {
        _partnerCategory.discount = double.parse(_discountController.text);
      } else {
        _partnerCategory.discount = 0;
      }

      _partnerCategoryAddEditBloc
          .add(PartnerCategoryAddEditSaved(partnerCategory: _partnerCategory));
    } else {
      App.showDefaultDialog(
          title: S.of(context).error,
          context: context,
          type: AlertDialogType.error,
          content: S.of(context).canNotGetData);
    }
  }
}
