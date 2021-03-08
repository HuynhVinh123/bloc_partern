import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/ui/partner_category_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/partner/partner_category/bloc/partner_category_select_state.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/search_app_bar_custom.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:tpos_mobile/widgets/button/bottom_single_button.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/partner_category_select_bloc.dart';
import 'bloc/partner_category_select_event.dart';
import 'bloc/partner_category_select_state.dart';

class PartnerCategorySelectPage extends StatefulWidget {
  const PartnerCategorySelectPage({
    Key key,
    @required this.selectedIds,
  }) : super(key: key);

  final List<int> selectedIds;

  @override
  _PartnerCategorySelectPageState createState() =>
      _PartnerCategorySelectPageState();
}

class _PartnerCategorySelectPageState extends State<PartnerCategorySelectPage> {
  PartnerCategorySelectBloc _partnerCategorySelectBloc;
  final List<int> _selectedIds = <int>[];
  final List<PartnerCategory> _partnerCategories = <PartnerCategory>[];
  bool _isSearch = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadListIdSelected();
    _partnerCategorySelectBloc = PartnerCategorySelectBloc();
    _partnerCategorySelectBloc.add(PartnerCategorySelectLoaded());
  }

  @override
  void dispose() {
    super.dispose();
    _partnerCategorySelectBloc?.close();
    _selectedIds?.clear();
  }

  /// Load data cho biết các nhóm nào đã được chọn trước đó
  void _loadListIdSelected() {
    if (widget.selectedIds != null) {
      for (int i = 0; i <= widget.selectedIds.length; i++) {
        _selectedIds.add(widget.selectedIds[i]);
      }
    }
  }

  /// Tính số phần từ con của các nhóm cha
  int _countChildElement(List<PartnerCategory> partnerCategories, int index) {
    int _count = 0;
    for (int i = 0; i <= partnerCategories.length; i++) {
      if (partnerCategories[i].parentId == partnerCategories[index].id &&
          partnerCategories[i].id != partnerCategories[index].id) _count++;
    }
    return _count;
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<PartnerCategorySelectBloc>(
      listen: (state) {
        if (state is PartnerCategorySelectDeleteSuccess) {
          App.showToast(
            type: AlertDialogType.success,
            title: S.current.success,
            message: S.of(context).successfullyParam(S.of(context).delete),
          );
        } else if (state is PartnerCategorySelectDeleteFailure) {
          App.showDefaultDialog(
              title: S.of(context).error,
              context: context,
              type: AlertDialogType.error,
              content: state.error);
        }
      },
      busyStates: const [
        PartnerCategorySelectLoading,
        PartnerCategorySelectBusy
      ],
      bloc: _partnerCategorySelectBloc,
      child: WillPopScope(
        onWillPop: _handleOnWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: _buildBody(),
        ),
      ),
    );
  }

  /// Xử lý khi nhấn nút back sẽ tắt thanh search app bar
  Future<bool> _handleOnWillPop() async {
    if (_isSearch) {
      _isSearch = !_isSearch;
      _searchController.text = "";
      _partnerCategorySelectBloc.add(PartnerCategorySelectSearched(
          txtSearch: _searchController.text.trim()));
    } else {
      Navigator.of(context).pop();
    }
    setState(() {});
    return false;
  }

  ///UI build AppBar + Button thêm nhóm khách hàng
  Widget _buildAppBar() {
    return AppBar(
      leading: _isSearch
          ? IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                _isSearch = false;
                setState(() {});
              })
          : null,
      title: BlocBuilder<PartnerCategorySelectBloc, PartnerCategorySelectState>(
          buildWhen: (last, current) =>
              current is PartnerCategorySelectLoadSuccess ||
              current is PartnerCategorySelectLoadFailure,
          builder: (context, state) {
            if (state is PartnerCategorySelectLoadSuccess) {
              return _isSearch
                  ? SearchAppBarCustomWidget(
                      color: const Color(0xFF28A745),
                      controller: _searchController,
                      onChanged: (text) {
                        _partnerCategorySelectBloc.add(
                            PartnerCategorySelectSearched(txtSearch: text));
                      },
                    )
                  : Text(S.of(context).partnerCategory);
            } else {
              return Text(S.of(context).partnerCategory);
            }
          }),
      actions: [
        BlocBuilder<PartnerCategorySelectBloc, PartnerCategorySelectState>(
            buildWhen: (last, current) =>
                current is PartnerCategorySelectLoadSuccess ||
                current is PartnerCategorySelectLoadFailure,
            builder: (context, state) {
              if (state is PartnerCategorySelectLoadSuccess) {
                return !_isSearch
                    ? IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _isSearch = !_isSearch;
                          setState(() {});
                        },
                      )
                    : const SizedBox();
              } else {
                return const SizedBox();
              }
            }),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _handleAddBtnPressed,
        ),
      ],
    );
  }

  /// Xử lý khi nhấn nút Save sẽ trở về page trước và list nhóm khách hàng đã chọn
  Future<void> _handleAddBtnPressed() async {
    final PartnerCategory partnerCategory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const PartnerCategoryAddEditPage();
        },
      ),
    );

    if (partnerCategory != null) {
      _partnerCategorySelectBloc.add(PartnerCategorySelectLoaded());
    }
  }

  /// Cập nhật danh sách nhóm khách hàng đã chọn
  void _updatePartnerCategory(List<PartnerCategory> partnerCategories) {
    for (int i = 0; i < partnerCategories.length; i++) {
      if (_selectedIds.contains(partnerCategories[i].id))
        _partnerCategories.add(partnerCategories[i]);
    }
  }

  /// UI Body
  Widget _buildBody() {
    return BlocBuilder<PartnerCategorySelectBloc, PartnerCategorySelectState>(
      cubit: _partnerCategorySelectBloc,
      buildWhen: (context, state) =>
          state is PartnerCategorySelectLoadSuccess ||
          state is PartnerCategorySelectLoadFailure,
      builder: (context, state) {
        if (state is PartnerCategorySelectLoading) {
          return const LoadingIndicator();
        } else if (state is PartnerCategorySelectLoadSuccess) {
          return state.partnerCategories.isEmpty
              ? _buildAppPageState(state)
              : _buildPartnerCategories(state.partnerCategories);
        } else
          return _buildAppPageState(state);
      },
    );
  }

  Widget _buildAppPageState(PartnerCategorySelectState state) {
    if (state is PartnerCategorySelectLoadSuccess) {
      if (_searchController.text != "") {
        return _buildAppPageSearchNotFound();
      } else {
        return _buildAppPageStateEmptyData();
      }
    } else if (state is PartnerCategorySelectLoadFailure) {
      return _buildAppPageStateError(state);
    } else {
      return const SizedBox();
    }
  }

  ///UI Giao diện khi không tìm thấy nhóm khách hàng
  Widget _buildAppPageSearchNotFound() {
    return Center(
      child: SingleChildScrollView(
        child: AppPageState(
          title: S.of(context).searchNotFound,
          message: S
              .of(context)
              .searchNotFoundWithKeywordParam(_searchController.text, ""),
          icon: SvgPicture.asset('assets/icon/no-result.svg'),
        ),
      ),
    );
  }

  ///UI Giao diện khi danh sách nhóm khách hàng trống
  Widget _buildAppPageStateEmptyData() {
    return Center(
      child: SingleChildScrollView(
        child: AppPageState(
          title: S.of(context).noData,
          message: S.of(context).emptyNotificationParam(
              S.of(context).menu_customerGroup.toLowerCase()),
          icon: const SvgIcon(
            SvgIcon.emptyData,
          ),
          actions: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AppButton(
                onPressed: () async {
                  final PartnerCategory partnerCategory = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const PartnerCategoryAddEditPage();
                      },
                    ),
                  );
                  if (partnerCategory != null) {
                    _partnerCategorySelectBloc
                        .add(PartnerCategorySelectLoaded());
                  }
                },
                padding: const EdgeInsets.only(left: 18, right: 18),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 40, 167, 69),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        S.of(context).addNew,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///UI Giao diện khi load data nhóm khách hàng
  Widget _buildAppPageStateError(PartnerCategorySelectLoadFailure state) {
    return Center(
      child: SingleChildScrollView(
        child: AppPageState(
          icon: SvgPicture.asset('assets/icon/error.svg'),
          title: S.of(context).loadDataError,
          message: state.content,
          actions: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AppButton(
                onPressed: () async {
                  _partnerCategorySelectBloc.add(PartnerCategorySelectLoaded());
                },
                padding: const EdgeInsets.only(left: 18, right: 18),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 40, 167, 69),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SvgIcon(
                      SvgIcon.reload,
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        S.of(context).refreshPage,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///UI Danh sách nhóm khách hàng
  Widget _buildPartnerCategories(List<PartnerCategory> partnerCategories) {
    _updatePartnerCategory(partnerCategories);
    return RefreshIndicator(
      onRefresh: () async {
        _partnerCategorySelectBloc.add(PartnerCategorySelectLoaded());
        return true;
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 55),
            child: ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    _buildPartnerCategory(
                      partnerCategory: partnerCategories[index],
                      countChildElement:
                          _countChildElement(partnerCategories, index),
                    ),
                itemCount: partnerCategories.length),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: BottomSingleButton(
                title: S.current.save.toUpperCase(),
                onPressed: () => _handleSaveBtn(),
                hideOnKeyboard: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Xử lý Save gửi list nhóm khách hàng
  void _handleSaveBtn() {
    Navigator.pop(context, _partnerCategories);
  }

  /// UI item list nhóm khách hàng
  Widget _buildPartnerCategory(
      {@required PartnerCategory partnerCategory,
      @required int countChildElement}) {
    final double _paddingLeft =
        40.0 * (partnerCategory.completeName.split(' / ').length - 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: _paddingLeft),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(5),
                  onTap: () => _handlePartnerCategoryOnTap(partnerCategory),
                  title: Text(
                    partnerCategory.name ?? '',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: Color(0xFF2C333A),
                        fontSize: 17,
                        letterSpacing: 0.17),
                  ),
                  leading: SizedBox(
                    height: 40,
                    width: 40,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xffE9F6EC),
                          child: Text(
                            partnerCategory.name != null &&
                                    partnerCategory.name != ''
                                ? partnerCategory.name.substring(0, 1)
                                : '',
                            style: const TextStyle(color: Color(0xFF28A745)),
                          ),
                        ),
                        if (countChildElement != 0)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: const Color(0xFF28A745),
                              ),
                              child: Text(
                                countChildElement.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  trailing: _selectedIds.contains(partnerCategory.id)
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF28A745),
                        )
                      : const SizedBox(),
                ),
              ),
            ),
          ],
        ),
        Divider(
          height: 0,
          thickness: 1,
          indent: _paddingLeft + 20,
          color: const Color(0xFFF2F4F7),
        ),
      ],
    );
  }

  /// Xử lý khi chọn 1 item nhóm khách hàng
  Future<void> _handlePartnerCategoryOnTap(
      PartnerCategory partnerCategory) async {
    if (_selectedIds.contains(partnerCategory.id)) {
      _selectedIds.remove(partnerCategory.id);
      _partnerCategories.remove(partnerCategory);
    } else {
      _selectedIds.add(partnerCategory.id);
      _partnerCategories.add(partnerCategory);
    }
    setState(() {});
  }
}
