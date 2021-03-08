import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tmt_flutter_ui/tmt_flutter_ui.dart';
import 'package:tmt_flutter_untils/sources/color_utils/color_utils.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tmt_flutter_viewmodel/tmt_flutter_viewmodel.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/ui/partner_categories_page.dart';
import 'package:tpos_mobile/feature_group/category/tag_list_page.dart';
import 'package:tpos_mobile/feature_group/category/tag_partner_list_page.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/partner_list_viewmodel.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

import 'partner/partner_info_page.dart';
import 'partner/partner_page.dart';

class PartnerListPage extends StatefulWidget {
  const PartnerListPage(
      {this.isSupplier, this.isSelectMode = false, this.onSelected});
  final bool isSupplier;

  /// Nếu [isSelectMode] được đặt giá trị là true thì trang khách hàng sẽ ở trạng thái tìm kiếm và chọn
  /// Khi chạm vào một khách hàng, khách đó sẽ được
  final bool isSelectMode;
  final ValueChanged<Partner> onSelected;

  @override
  _PartnerListPageState createState() => _PartnerListPageState();
}

class _PartnerListPageState extends State<PartnerListPage> {
  final _vm = PartnerListViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _keywordController = TextEditingController();
  final ScrollController _scrollController = ScrollController(
    keepScrollOffset: false,
    initialScrollOffset: 0,
  );
  @override
  void initState() {
    _vm.isSelectMode = widget.isSelectMode;
    _vm.isSupplier = widget.isSupplier;
    _vm.isSearchEnable = false;
    _vm.initData();
    super.initState();
  }

  /// Xử lý khi nhấn vào từng item
  void _handleOnItemPressed(BuildContext context, Partner partner) {
    if (widget.onSelected != null) widget.onSelected(partner);

    if (widget.isSelectMode) {
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
  Future<void> _handleAddPartner(BuildContext context) async {
    final vm = context.read<PartnerListViewModel>();

    await context.navigateTo(
      PartnerAddEditPage(
        closeWhenSaved: true,
        isSupplier: vm.isSupplier || vm.isSupplier == null,
        isCustomer: !vm.isSupplier || vm.isSupplier == null,
        onEditPartner: (partner) {
          vm.initData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderVmUi<PartnerListViewModel>(
      vm: _vm,
      indicatorBuilder: (BuildContext a, String message) => LoadingOverlay(
        message: message,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body: _buildBody(),
        endDrawer: _buildFilter(),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildBody() {
    return Scrollbar(
      child: RefreshIndicator(
        onRefresh: () async {
          await _vm.refreshData();
          return true;
        },
        child: Consumer<PartnerListViewModel>(
          builder: (context, model, c) => CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              // Appbar
              AnimatedSearchSliverAppbar(
                leading: BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // if (model.isSearchEnable) {
                    //   // _keywordController.text = '';
                    //   // model.exitSearchMode(false);
                    // } else {
                    //   Navigator.pop(context);
                    // }
                  },
                ),
                title: Text(
                    _vm.isSupplier ? S.current.supplier : S.current.customer),
                hint: S.current.findCommentHint,
                searchController: _keywordController,
                onKeywordChanged: (text) {
                  model.keyword = text;
                  if (_scrollController.offset > 56) {
                    _scrollController.animateTo(58,
                        duration: const Duration(seconds: 1),
                        curve: Curves.linear);
                  }
                },
                onSearchTap: () {
                  if (_scrollController.offset < 56) {
                    _scrollController.animateTo(56,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear);

                    model.isSearchEnable = true;
                  }
                },
                autoFocus: _vm.isSearchEnable,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _handleAddPartner(context);
                    },
                  ),
                ],
                otherActions: [
                  IconButton(
                    icon: Badge(
                      badgeContent: Text(
                        _vm.filterCount.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      showBadge: model.filterCount > 0,
                      child: const Icon(Icons.filter_list),
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: model.isSearching
                    ? const LinearProgressIndicator(
                        minHeight: 5,
                      )
                    : Container(
                        height: 5,
                      ),
              ),

              _buildSliverList(context),
              SliverToBoxAdapter(
                child: _buildLoadMoreItem(),
              ),
              // Fill remaning
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreItem() {
    if (_vm.canLoadMore) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: RaisedButton(
          textColor: Colors.white,
          // Tải thêm
          child: Text("${S.current.loadMore}..."),
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

  Widget _buildSliverList(BuildContext context) {
    return Consumer<PartnerListViewModel>(builder: (a, model, _) {
      print(model.state);

      Widget widget;
      if (model.state is VmLoading) {
        widget = PageState.loading();
      } else if (model.state is VmLoadFailure) {
        widget = PageState.dataError(
          description: Text(model.state.message ?? ''),
          onRefreshButtonPressed: () {
            model.initData();
          },
        );
      }

      if (model.isNotFound) {
        print(model.filterDescription);
        widget = PageState.notFound(
          icon: const SvgIcon(SvgIcon.emptyCustomer),
          title: Text(S.current.searchNotFound),
          description: Text(
            model.filterDescription,
            textAlign: TextAlign.left,
          ),
          actions: [
            PageStateActionButton(
              child: const Text('Tải lại...'),
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                model.refreshData();
              },
            ),
            PageStateActionButton(
              child: const Text('Đổi lọc...'),
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ],
          otherActions: [
            if (model.keyword.isNotNullOrEmpty())
              FlatButton(
                onPressed: () {
                  context.navigateTo(
                    PartnerAddEditPage(
                      isCustomer: !_vm.isSupplier,
                      isSupplier: _vm.isSupplier,
                      name: _keywordController.text.trim(),
                    ),
                  );
                },
                textColor: Colors.blue,
                child: Text(
                  'Chạm để thêm mới khách hàng với tên "${_keywordController.text}"',
                  textAlign: TextAlign.center,
                ),
              )
          ],
        );
      }

      if (model.isEmpty) {
        widget = PageState.emptyList(
          title: Text(S.current.empty),
          description: const Text(
              "Chưa có khách hàng nào. Nhấn thêm để thêm một khách hàng mới"),
        );
      }

      if (widget != null) {
        return SliverFillRemaining(
          child: widget,
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildItem(context, _vm.partners[index], index);
          },
          childCount: _vm.partners.length,
        ),
      );
    });
  }

  Widget _buildFilter() {
    return Consumer<PartnerListViewModel>(builder: (context, _, __) {
      return AppFilterDrawerContainer(
          countFilter: _vm.filterCountCache,
          onApply: () {
            _vm.applyFilter();
          },
          closeWhenConfirm: true,
          onRefresh: () {
            _vm.resetFilter();
          },
          onClosed: () {
            _vm.undoFilter();
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      AppFilterPanel(
                        title: Text(S.current.filterByGroup),
                        isSelected: _vm.isFilterByCategoryTemp,
                        onSelectedChange: (value) =>
                            _vm.isFilterByCategoryTemp = value,
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
                                        const PartnerCategoriesPage(
                                            isSearchMode: true, isSearch: true),
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
                        isSelected: _vm.isFilterByPartnerStatusTemp,
                        onSelectedChange: (value) =>
                            _vm.isFilterByPartnerStatusTemp = value,
                        children: <Widget>[
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                _vm.partnerStatusReportItems?.length ?? 0,
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
                                    //     final int tagColor =
                                    // int.parse("0xFF${widget.tag.color.replaceAll("#", "")}");
                                    Expanded(
                                      child: Text(
                                        _vm.partnerStatusReportItems[index]
                                                .statusText ??
                                            "",
                                        style: TextStyle(
                                            color: getColorStatusPartner(_vm
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
                        isSelected: _vm.isFilterByTagTemp,
                        onSelectedChange: (value) =>
                            _vm.isFilterByTagTemp = value,
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
          ));
    });
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
                      // Danh sách tag khách hàng
                      Text(
                        S.current.partner_tags,
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
                            //Hủy
                            child: Text(S.current.cancel,
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
                            //Lưu
                            child: Text(
                              S.current.save,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
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

  Widget _buildItem(BuildContext context, Partner partner, int index) {
    return Slidable(
      secondaryActions: [
        IconSlideAction(
          caption: S.current.edit,
          color: Colors.blue,
          icon: Icons.edit,
          closeOnTap: true,
          onTap: () {
            context.navigateTo(
              PartnerAddEditPage(
                partner: partner,
                closeWhenSaved: true,
                partnerId: partner?.id,
              ),
            );
          },
        ),
        IconSlideAction(
          caption: S.current.delete,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            if (await App.showConfirm(
                title: 'Xác nhận xóa',
                content: 'Bạn muốn xóa khách hàng ${partner.name}?')) {
              context.read<PartnerListViewModel>().deletePartner(
                    id: partner.id,
                    index: index,
                  );
            }
          },
        ),
      ],
      actionPane: const SlidableDrawerActionPane(),
      child: PartnerListItem(
        partner: partner,
        onTapAddTag: () {
          _showBottomSheet(context, partner.id, partner.tags);
        },
        onTap: () => _handleOnItemPressed(context, partner),
      ),
    );
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
      title: Text(
        partner.name,
        style: const TextStyle(color: Colors.deepOrange),
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
                  //Chưa có SĐT
                  TextSpan(
                      text: " | ${partner.phone ?? S.current.noPhoneNumber}",
                      style: textStyle),
                  TextSpan(
                      text: " | ${partner.street ?? S.current.noAddress}",
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
            ),
            const Divider(),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildTag(Tag tag) {
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
        color: getPartnerStatusColorFromStatusText(partner.statusText),
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
