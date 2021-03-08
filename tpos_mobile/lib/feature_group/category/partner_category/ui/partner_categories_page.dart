import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/partner_category_bloc.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/partner_category_event.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/partner_category_state.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/ui/partner_category_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/ui/partner_category_view_page.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/search_app_bar_custom.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PartnerCategoriesPage extends StatefulWidget {
  const PartnerCategoriesPage(
      {Key key,
      this.isSearch = false,
      this.isSearchMode = true,
      this.onSelected,
      this.selectedItems = const <PartnerCategory>[],
      this.current})
      : super(key: key);

  @override
  _PartnerCategoriesPageState createState() => _PartnerCategoriesPageState();

  final bool isSearchMode;

  final PartnerCategory current;

  final Function(PartnerCategory) onSelected;

  final List<PartnerCategory> selectedItems;
  final bool isSearch;
}

class _PartnerCategoriesPageState extends State<PartnerCategoriesPage> {
  PartnerCategoryBloc _partnerCategoryBloc;
  final TextEditingController _searchController = TextEditingController();
  List<PartnerCategory> _partnerCategories;
  bool _isSearch;

  @override
  void initState() {
    _isSearch = widget.isSearch;
    _partnerCategoryBloc = PartnerCategoryBloc();
    _partnerCategoryBloc.add(PartnerCategoriesLoaded());
    super.initState();
  }

  @override
  void dispose() {
    _partnerCategoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<PartnerCategoryBloc>(
      listen: (state) {
        if (state is PartnerCategoryDeleteSuccess) {
          App.showToast(
            type: AlertDialogType.success,
            title: S.current.success,
            message: S.of(context).successfullyParam(S.of(context).delete),
          );
        } else if (state is PartnerCategoryActionFailure) {
          App.showDefaultDialog(
              title: S.of(context).error,
              context: context,
              type: AlertDialogType.error,
              content: state.error);
        }
      },
      busyStates: const [PartnerCategoryLoading, PartnerCategoryBusy],
      bloc: _partnerCategoryBloc,
      child: WillPopScope(
        onWillPop: () async {
          setState(() {
            if (_isSearch) {
              _isSearch = !_isSearch;
              _searchController.text = "";
              _partnerCategoryBloc.add(PartnerCategorySearched(
                  search: _searchController.text.trim()));
            } else {
              Navigator.of(context).pop();
            }
          });
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          appBar: _buildAppBar(),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: _isSearch && widget.isSearchMode
          ? IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              })
          : null,
      title: BlocBuilder<PartnerCategoryBloc, PartnerCategoryState>(
          buildWhen: (last, current) =>
              current is PartnerCategoryLoadSuccess ||
              current is PartnerCategoryLoadFailure,
          builder: (context, state) {
            if (state is PartnerCategoryLoadSuccess) {
              return _isSearch
                  ? SearchAppBarCustomWidget(
                      color: const Color(0xFF28A745),
                      controller: _searchController,
                      onChanged: (text) {
                        _partnerCategoryBloc
                            .add(PartnerCategorySearched(search: text));
                      },
                    )
                  : Text(S.of(context).partnerCategory);
            } else {
              return Text(S.of(context).partnerCategory);
            }
          }),
      actions: [
        BlocBuilder<PartnerCategoryBloc, PartnerCategoryState>(
            buildWhen: (last, current) =>
                current is PartnerCategoryLoadSuccess ||
                current is PartnerCategoryLoadFailure,
            builder: (context, state) {
              if (state is PartnerCategoryLoadSuccess) {
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
              _partnerCategoryBloc.add(PartnerCategoriesLoaded());
            }
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<PartnerCategoryBloc, PartnerCategoryState>(
      buildWhen: (context, state) =>
          state is PartnerCategoryLoadSuccess ||
          state is PartnerCategoryLoadFailure,
      builder: (BuildContext context, PartnerCategoryState state) {
        if (state is PartnerCategoryLoadSuccess) {
          _partnerCategories = state.partnerCategories;
          return _partnerCategories.isEmpty
              ? _buildEmpty(state)
              : _buildPartnerCategories(_partnerCategories);
        } else
          return _buildEmpty(state);
      },
    );
  }

  Widget _buildEmpty(PartnerCategoryState state) {
    if (state is PartnerCategoryLoadSuccess) {
      if (_searchController.text != "") {
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
      } else {
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
                      final PartnerCategory partnerCategory =
                          await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const PartnerCategoryAddEditPage();
                          },
                        ),
                      );

                      if (partnerCategory != null) {
                        _partnerCategoryBloc.add(PartnerCategoriesLoaded());
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
    } else if (state is PartnerCategoryLoadFailure) {
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
                    _partnerCategoryBloc.add(PartnerCategoriesLoaded());
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
    } else {
      return const SizedBox();
    }
  }

  Widget _buildPartnerCategories(List<PartnerCategory> partnerCategories) {
    return RefreshIndicator(
      onRefresh: () async {
        _partnerCategoryBloc.add(PartnerCategoriesLoaded());
        return true;
      },
      child: ListView.separated(
        itemCount: partnerCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildPartnerCategory(partnerCategories[index], index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 0);
        },
      ),
    );
  }

  Widget _buildPartnerCategory(PartnerCategory partnerCategory, index,
      {int level = 0}) {
    return Slidable(
      key: ValueKey<int>(partnerCategory.id),
      secondaryActions: [
        InkWell(
          onTap: () async {
            final bool result = await App.showConfirm(
                title: S.of(context).confirmDelete,
                content: S.of(context).deleteSelectConfirmParam(
                    S.of(context).partnerCategory.toLowerCase()));

            if (result != null && result) {
              _partnerCategoryBloc.add(
                  PartnerCategoryDeleted(partnerCategory: partnerCategory));
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Center(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraint) {
                final double width = constraint.biggest.width > 14
                    ? 14
                    : constraint.biggest.width;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Flexible(
                        child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
                    Flexible(
                      child: Text(
                        S.of(context).delete,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white, fontSize: 14 * width / 14),
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ),
      ],
      actionPane: const SlidableStrechActionPane(),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 40.0 * level),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade200))),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      onTap: () async {
                        if (widget.isSearchMode) {
                          widget.onSelected?.call(partnerCategory);
                          Navigator.pop(context, partnerCategory);
                        } else {
                          final PartnerCategory result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PartnerCategoryViewPage(
                                    partnerCategory: partnerCategory);
                              },
                            ),
                          );
                          if (result != null) {
                            _partnerCategoryBloc.add(PartnerCategoriesLoaded());
                          }
                        }

                        setState(() {});
                      },
                      contentPadding: const EdgeInsets.all(5),
                      title: Text(partnerCategory.name ?? '',
                          textAlign: TextAlign.start),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xffE9F6EC),
                        child: Text(
                          partnerCategory != null && partnerCategory.name != ''
                              ? partnerCategory.name.substring(0, 1)
                              : '',
                          style: const TextStyle(color: Color(0xff28A745)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
