import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tmt_flutter_untils/sources/color_utils/color_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/category/tag_list_page.dart';
import 'package:tpos_mobile/feature_group/category/tag_partner_list_page.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/partner_list_viewmodel.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/resources/themes.dart';
import 'package:tpos_mobile/widgets/button/page_state_action_button.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

import 'partner/partner_page.dart';
import 'partner/partner_category_page.dart';
import 'partner/partner_info_page.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class PartnerListPage extends StatefulWidget {
  const PartnerListPage(
      {this.isSupplier, this.isSearchMode = false, this.onSelected});
  final bool isSupplier;
  final bool isSearchMode;
  final ValueChanged<Partner> onSelected;

  @override
  _PartnerListPageState createState() => _PartnerListPageState();
}

class _PartnerListPageState extends State<PartnerListPage> {
  final _vm = PartnerListViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _searchEnable = false;

  String get _partnerType =>
      widget.isSupplier ? S.current.menu_supplier : S.current.customer;
  @override
  void initState() {
    _vm.init(isSearchModel: widget.isSearchMode, isSupplier: widget.isSupplier);
    _searchEnable = widget.isSearchMode;
    super.initState();
  }

  /// Xử lý khi nhấn vào từng item
  void _handleOnItemPressed(BuildContext context, Partner partner) {
    if (widget.onSelected != null) widget.onSelected(partner);

    if (widget.isSearchMode) {
      Navigator.pop(context, partner);
    } else {
      // Edit mode
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PartnerInfoPage(
            partnerId: partner.id,
            onEditPartner: (partner) {
              // Update view
              _vm.initData();
            },
            onChangeStatus: (status, statusStyle, statusText) {
              setState(() {
                partner.status = status;
                partner.statusText = statusText;
                partner.statusStyle = statusStyle;
              });
            },
          ),
        ),
      );
    }
  }

  /// Xử lý khi nhấn nút + thêm mới khách hàng
  Future<void> _handleAddPartner() async {
    final savedPartner = await context.navigateTo(
      PartnerAddEditPage(
        closeWhenSaved: true,
        isSupplier: widget.isSupplier || widget.isSupplier == null,
        isCustomer: !widget.isSupplier || widget.isSupplier == null,
      ),
    );

    if (savedPartner != null) {
      _vm.initData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase<PartnerListViewModel>(
      viewModel: _vm,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppbar(),
        body: _buildBody(),
        endDrawer: _buildFilter(),
      ),
    );
  }

  Widget _buildSearchTitle() {
    return Container(
      child: TextField(
        decoration: InputDecoration(
          hintText: S.current.partnerListPage_searchHint,
          border: InputBorder.none,
        ),
        onChanged: (text) {
          _vm.searchSink.add(text.trim());
        },
      ),
    );
  }

  Widget _buildAppbar() {
    final appbarTextTheme = Theme.of(context).appBarTheme;

    return AppBar(
      textTheme: _searchEnable ? getAppSearchAppbarTheme().textTheme : null,
      iconTheme: _searchEnable ? getAppSearchAppbarTheme().iconTheme : null,
      backgroundColor: _searchEnable ? getAppSearchAppbarTheme().color : null,
      title: _searchEnable
          ? _buildSearchTitle()
          : Text(
              widget.isSupplier ? S.current.menu_supplier : S.current.customer),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _searchEnable = !_searchEnable;
              if (!_searchEnable) {
                _vm.searchSink.add("");
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _handleAddPartner(),
        )
      ],
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<PartnerListViewModel>(
      builder: (context, _, __) => Column(
        children: <Widget>[
          _buildBodyHeader(),
          if (_vm.isSearching)
            const SizedBox(height: 2, child: LinearProgressIndicator()),
          Expanded(
            child: _buildPartnerList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.grey.shade300),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 1,
              offset: const Offset(1, 0)),
        ],
      ),
      height: 40,
      child: Row(
        children: <Widget>[
          const Spacer(),
          FlatButton.icon(
            label: Text(S.current.filter),
            icon: Badge(
              badgeContent: Text(
                _vm.filterCount.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              showBadge: _vm.filterCount > 0,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyList() {
    String title;
    String message;

    List<Widget> actions = <Widget>[];

    PageStateActionButton _addButton = PageStateActionButton(
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () => _handleAddPartner(),
      child: Text(S.current.addPartner),
    );

    PageStateActionButton _refreshButton = PageStateActionButton(
      icon: const Icon(
        Icons.refresh,
        color: Colors.white,
      ),
      onPressed: () {
        _vm.initData();
      },
      child: Text(S.current.refresh),
    );

    PageStateActionButton _openFilterButton = PageStateActionButton(
      icon: const Icon(
        Icons.filter,
        color: Colors.white,
      ),
      onPressed: () {
        _scaffoldKey.currentState.openEndDrawer();
      },
      child: Text(S.current.changeFilter),
    );
    if (_vm.filterCount == 0 && _vm.keyword.isNullOrEmpty()) {
      title = S.current.noPartner(_partnerType);
      message = S.current.pageState_noCustomerMesssage;
      actions = [
        _addButton,
      ];
    } else if (_vm.keyword.isNotNullOrEmpty()) {
      if (_vm.filterCount != 0) {
        title = S.current.noPartnerFound(_partnerType);
        message = S.current
            .pageState_noCustomerFoundWithKeywordAndFilter(_vm.keyword);
      } else {
        title = S.current.noPartnerFound(_partnerType);
        message = S.current.pageState_noCustomerFoundWithKeyword(_vm.keyword);
        actions = [];
      }
    } else {
      title = S.current.noPartnerFound(_partnerType);
      message = S.current.pageState_noCustomerFoundMesssage;
      actions = [
        _refreshButton,
        const SizedBox(
          width: 10,
        ),
        _openFilterButton,
      ];
    }

    return PageState.emptyCustomer(
      title: title,
      message: message,
      actions: actions,
    );
  }

  Widget _buildLoadMoreItem() {
    if (_vm.canLoadMore) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: RaisedButton(
          textColor: Colors.white,
          child: const Text("Tải thêm..."),
          onPressed: !_vm.isLoadingMore
              ? () {
                  _vm.loadMorePartner();
                }
              : null,
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildPartnerList() {
    final items = _vm.viewPartners;

    if ((items == null || items.isEmpty) && !_vm.isBusy && !_vm.isSearching)
      return _buildEmptyList();

    return Scrollbar(
      child: ListView.separated(
          itemBuilder: (context, index) => index == _vm.viewListCount
              ? _buildLoadMoreItem()
              : Dismissible(
                  background: Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            "Xóa dòng này?",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              "Xóa",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 36,
                        )
                      ],
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  key: UniqueKey(),
                  confirmDismiss: (direction) async {
                    final result = await context.showConfirm(
                      title: S.current.confirmDelete,
                      content: S.current.confirm_deletePartnerConfirmContent(
                          _partnerType, items[index].name),
                    );

                    if (result == true) {
                      final bool result = await _vm.deletePartner(
                          id: items[index].id, index: index);
                      return result;
                    } else {
                      return false;
                    }
                  },
                  child: PartnerListItem(
                    partner: items[index],
                    onTapAddTag: () {
                      _showBottomSheet(
                          context, items[index].id, items[index].tags);
                    },
                    onTap: () => _handleOnItemPressed(context, items[index]),
                  ),
                ),
          separatorBuilder: (context, index) => const Divider(
                height: 2,
              ),
          itemCount: _vm.viewListCount + 1),
    );
  }

  Widget _buildFilter() {
    return AppFilterDrawerContainer(
      onApply: () {
        _vm.initData();
      },
      onRefresh: () {
        _vm.resetFilter();
      },
      child: ScopedModelDescendant<PartnerListViewModel>(
        builder: (context, _, __) => Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AppFilterPanel(
                      title: Text(S.current.filterByGroup),
                      isSelected: _vm.isFilterByCategory,
                      onSelectedChange: (value) =>
                          _vm.isFilterByCategory = value,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: OutlineButton(
                            child: Text(
                              _vm.partnerCategory?.name ??
                                  S.current.selectAGroup,
                              textAlign: TextAlign.left,
                            ),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PartnerCategoryPage(
                                    isSearchMode: true,
                                  ),
                                ),
                              );

                              if (result != null) {
                                _vm.partnerCategory = result;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    AppFilterPanel(
                      title: Text(S.current.filterByStatus),
                      isSelected: _vm.isFilterByPartnerStatus,
                      onSelectedChange: (value) =>
                          _vm.isFilterByPartnerStatus = value,
                      children: <Widget>[
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _vm.partnerStatusReportItems?.length ?? 0,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  Icon(_vm.partnerStatusReportItem
                                              ?.statusText ==
                                          _vm.partnerStatusReportItems[index]
                                              ?.statusText
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${_vm.partnerStatusReportItems[index].statusText}",
                                      style: TextStyle(
                                          color: getPartnerStatusColor(_vm
                                              .partnerStatusReportItems[index]
                                              .statusStyle)),
                                    ),
                                  ),
                                  Text(
                                      "${_vm.partnerStatusReportItems[index].count}")
                                ],
                              ),
                              onTap: () {
                                _vm.partnerStatusReportItem =
                                    _vm.partnerStatusReportItems[index];
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppFilterPanel(
                      title: Text(S.current.filterByTags),
                      isSelected: _vm.isFilterByTag,
                      onSelectedChange: (value) => _vm.isFilterByTag = value,
                      children: <Widget>[
                        Wrap(children: <Widget>[
                          ...List.generate(
                              _vm.tagFilters.length ?? 0,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 4),
                                    child: RawChip(
                                      onDeleted: () {
                                        setState(() {
                                          _vm.tagFilters.removeAt(index);
                                        });
                                      },
                                      deleteIcon: const Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      label: Text(_vm.tagFilters[index].name),
                                      selected: false,
                                    ),
                                  )),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 4),
                            child: ChoiceChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(
                                    Icons.add,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  Text(S.current.addATag),
                                ],
                              ),
                              onSelected: (value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TagListPage(
                                            tags: _vm.tags,
                                            isAdd: false,
                                          )),
                                ).then((value) {
                                  if (value != null) {
                                    _vm.addTagFilters = value;
                                  }
                                });
                              },
                              selected: false,
                            ),
                          )
                        ])
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Text(_vm.count?.toString()),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(context, int partnerId, List<Tag> tagPartner) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12))),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Column(
                    children: <Widget>[
                      Text(
                        "Danh sách tag khách hàng",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w700,
                            fontSize: 17),
                      ),
                      Text(
                        S.current.pressAddToSelectNewTag,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TagPartnerListPage(
                    tags: _vm.tags,
                    tagPartner: tagPartner,
                    viewModel: _vm,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 42,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Hủy",
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 16)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 42,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _vm.assignTag(partnerId);
                            },
                            child: const Text(
                              "Lưu",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

class PartnerListItem extends StatelessWidget {
  const PartnerListItem({this.partner, this.onTap, this.onTapAddTag});
  final Partner partner;
  final VoidCallback onTap;

  /// callback sự kiện khi nhấn 'Add Tag"
  final VoidCallback onTapAddTag;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.grey);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Text(
          partner.name.length > 1 ? partner.name.substring(0, 1) : '',
        ),
        backgroundImage:
            partner.image != null ? NetworkImage(partner.imageUrl) : null,
      ),
      title: Wrap(
        children: [
          Text(
            partner.name,
            style: const TextStyle(color: Colors.deepOrange),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                // ignore: unnecessary_string_interpolations
                text: "${partner.ref ?? ""}",
                children: [
                  TextSpan(
                      text: " | ${partner.phone ?? "Chưa có SĐT"}",
                      style: textStyle),
                  TextSpan(
                      text: " | ${partner.street ?? " Chưa có địa chỉ"}",
                      style: textStyle),
                ],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                children: <Widget>[
                  if (partner.status != "Normal")
                    Padding(
                      padding: const EdgeInsets.only(right: 6, top: 4),
                      child: _buildPartnerStatus(),
                    ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      FontAwesomeIcons.tag,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  if (partner.tags != null)
                    ...List.generate(partner.tags.length,
                        (index) => _buildTag(partner.tags[index])),
                  InkWell(
                    onTap: onTapAddTag,
                    child: Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Icon(
                            Icons.add,
                            size: 14,
                          ),
                          Text("Tag")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildTag(Tag tag) {
    final color = ColorUtils.fromHex(tag.color, Colors.grey);
    const textColor = Colors.white;
    return InkWell(
      onTap: onTapAddTag,
      child: Container(
        margin: const EdgeInsets.only(right: 4, top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex(tag.color, Colors.grey),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          tag.name ?? '',
          style: const TextStyle(color: textColor),
        ),
      ),
    );
  }

  Widget _buildPartnerStatus() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: getColorFromPartnerStatus(partner.status),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 3),
        child: Text(
          partner.statusText,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}