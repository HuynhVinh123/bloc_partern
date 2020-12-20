import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_bloc.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_event.dart';
import 'package:tpos_mobile/feature_group/tag/bloc/tag_state.dart';
import 'package:tpos_mobile/feature_group/tag/tag_type_helper.dart';
import 'package:tpos_mobile/feature_group/tag/uis/tag_category_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/tag/uis/tag_category_info_page.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile/widgets/page_state/page_state.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class TagCategoryListPage extends StatefulWidget {
  @override
  _TagCategoryListPageState createState() => _TagCategoryListPageState();
}

class _TagCategoryListPageState extends State<TagCategoryListPage> {
  final TagBloc _bloc = TagBloc();
  final int _limit = 50;
  int _skip = 0;
  List<Type> typeTags;
  String typeTag;
  double heightFilter = 0;
  double heightTransparent = 0;
  bool isSearch = false;
  bool isEmptySearch = false;
  List<String> selectedTypes = <String>[];
  final TextEditingController _searchController = TextEditingController();
  final BehaviorSubject _behaviorSubject = BehaviorSubject();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    typeTags = tagTypeHelpers();
    super.initState();
    _behaviorSubject
        .debounceTime(const Duration(milliseconds: 400))
        .listen((value) {
      _bloc.add(TagLoaded(
          top: _limit, skip: 0, keyWord: value, tagTypes: selectedTypes));
    });
    _bloc.add(TagLoaded(top: _limit, skip: _skip));
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<TagBloc>(
      listen: (state) {
        if (state is ActionSuccess) {
          App.showToast(
              title: state.title, context: context, message: state.message);
          _bloc.add(TagDeleteLocal(tag: state.tag, odataTag: state.odataTag));
        } else if (state is ActionFailure) {
          App.showDefaultDialog(
              type: AlertDialogType.error,
              title: state.title,
              context: context,
              content: state.message);
        } else if (state is TagLoadFailure) {
          App.showDefaultDialog(
              type: AlertDialogType.error,
              title: state.title,
              context: context,
              content: state.message);
        }
      },
      bloc: _bloc,
      child: BlocLoadingScreen<TagBloc>(
        busyStates: const [TagLoading],
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppBar(),
            body: _buildBody()),
      ),
    );
  }

  /// UI appbar
  Widget _buildAppBar() {
    return AppBar(
      title: isSearch ? _buildSearch() : Text(S.current.tags),
      actions: [
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });
              if (isSearch) focusNode.requestFocus();
            }),
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              FocusScope.of(context)?.requestFocus(FocusNode());
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TagCategoryAddEditPage()),
              ).then((value) {
                if (value != null) {
                  setState(() {});
                  _bloc.add(TagLoaded(top: _limit, skip: 0));
                }
              });
            })
      ],
    );
  }

  /// UI search
  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24)),
      height: 40,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 12,
          ),
          const Icon(
            Icons.search,
            color: Color(0xFF28A745),
          ),
          Expanded(
            child: Center(
              child: Container(
                  height: 35,
                  margin: const EdgeInsets.only(left: 4),
                  child: Center(
                    child: TextField(
                      focusNode: focusNode,
                      controller: _searchController,
                      onChanged: (value) {
                        _behaviorSubject.add(value);
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          isDense: true,
                          hintText: S.current.search,
                          border: InputBorder.none),
                    ),
                  )),
            ),
          ),
          Visibility(
            visible: _searchController.text != "",
            child: IconButton(
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 48,
              ),
              padding: const EdgeInsets.all(0.0),
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
                size: 19,
              ),
              onPressed: () {
                _behaviorSubject.add("");
                setState(() {
                  isEmptySearch = true;
                  _searchController.text = "";
                });
              },
            ),
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
    );
  }

  /// UI tổng quan cho page
  Widget _buildBody() {
    return Stack(
      children: [
        Positioned(
            top: 60,
            left: 0,
            right: 0,
            bottom: 12,
            child: BlocBuilder<TagBloc, TagState>(
                buildWhen: (prevState, currState) {
              return currState is TagLoadSuccess ||
                  currState is TagLoadFailure ||
                  currState is TagRefreshLoading;
            }, builder: (context, state) {
              if (state is TagLoadSuccess) {
                return _buildListTag(state.odataTag);
              } else if (state is TagLoadFailure) {
                return PageState(
                  type: PageStateType.dataError,
                  actions: [
                    Container(
                      width: 110,
                      height: 35,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                          color: Colors.green,
                          onPressed: () {
                            _bloc.add(TagLoaded(
                                top: _limit, skip: _skip, isReload: true));
                          },
                          child: Text(
                            S.current.reload,
                            style: const TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                );
              } else if (state is TagRefreshLoading) {
                return LoadingIndicator();
              }
              return const SizedBox();
            })),
        Positioned(
          child: _buildTypePayment(),
          top: 11,
        ),
      ],
    );
  }

  /// UI hiển thị loại nhãn
  Widget _buildTypePayment() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (heightFilter == 0) {
                  heightFilter = 200;
                  heightTransparent = MediaQuery.of(context).size.height;
                } else {
                  heightFilter = 0;
                  heightTransparent = 0;
                }
              });
              // FocusScope.of(context)?.requestFocus(FocusNode());
            },
            child: Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: const Color(0xFFF8F9FB)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: Text(S.current.tags_TagType)),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(6)),
                        width: 20,
                        height: 20,
                        child: Center(
                          child: Text(
                            selectedTypes.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )),
                    const Icon(Icons.arrow_drop_down_sharp)
                  ],
                )),
          ),
          const Divider(
            height: 4,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            height: heightFilter,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            child: Visibility(
              visible: heightFilter != 0,
              child: Column(
                children: [
                  Expanded(
                    child: Wrap(
                      children: List.generate(
                          typeTags.length,
                          (index) => Container(
                                margin: const EdgeInsets.only(right: 6),
                                child: ChoiceChip(
                                    selectedColor: const Color(0xFFE9F6EC),
                                    backgroundColor: Colors.white,
                                    onSelected: (value) {
                                      setState(() {
                                        typeTags[index].isSelected =
                                            !typeTags[index].isSelected;
                                      });
                                    },
                                    label: Text(typeTags[index].value),
                                    selected: typeTags[index].isSelected,
                                    avatarBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        side: BorderSide(
                                            color: typeTags[index].isSelected
                                                ? const Color(0xFF28A745)
                                                : const Color(0xFFE9EDF2)))),
                              )),
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FlatButton.icon(
                              onPressed: () {
                                selectedTypes.clear();
                                // ignore: avoid_function_literals_in_foreach_calls
                                typeTags.forEach((element) {
                                  element.isSelected = false;
                                });
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                              label: Text(S.current.tags_DeleteTag)),
                        ),
                      ),
                      FlatButton.icon(
                          onPressed: () {
                            // ignore: avoid_function_literals_in_foreach_calls
                            selectedTypes.clear();
                            setState(() {
                              if (heightFilter == 0) {
                                heightFilter = 200;
                                heightTransparent =
                                    MediaQuery.of(context).size.height;
                              } else {
                                heightFilter = 0;
                                heightTransparent = 0;
                              }
                            });
                            // ignore: avoid_function_literals_in_foreach_calls
                            typeTags.forEach((element) {
                              if (element.isSelected) {
                                selectedTypes.add(element.key);
                              }
                            });

                            _bloc.add(TagLoaded(
                                top: _limit,
                                skip: 0,
                                tagTypes: selectedTypes,
                                keyWord: _searchController.text));
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Color(0xFF28A745),
                          ),
                          label: Text(S.current.apply)),
                    ],
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                if (heightFilter == 0) {
                  heightFilter = 200;
                  heightTransparent = MediaQuery.of(context).size.height;
                } else {
                  heightFilter = 0;
                  heightTransparent = 0;
                }
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: heightTransparent,
              decoration: BoxDecoration(
                  color: heightFilter == 0
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.4)),
            ),
          )
        ],
      );

  /// UI hiển thị danh sách nhãn
  Widget _buildListTag(OdataListResult<Tag> odataTag) {
    return odataTag.value.isEmpty
        ? _searchController.text == "" && !isSearch
            ? PageState(
                type: PageStateType.dataEmpty,
                actions: [
                  Container(
                    width: 110,
                    height: 35,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: FlatButton(
                        color: Colors.green,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TagCategoryAddEditPage()),
                          ).then((value) {
                            if (value != null) {
                              setState(() {});
                              _bloc.add(TagLoaded(top: _limit, skip: 0));
                            }
                          });
                        },
                        child: Text(
                          S.current.tags_AddTag,
                          style: const TextStyle(color: Colors.white),
                        )),
                  )
                ],
              )
            : PageState(
                message:
                    "${S.current.pageState_noCustomerFoundWithKeyword} ${_searchController.text}",
              )
        : RefreshIndicator(
            onRefresh: () async {
              setState(() {
                selectedTypes.clear();
                typeTags = tagTypeHelpers();
              });

              _bloc.add(TagLoaded(top: _limit, skip: 0));
            },
            child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                      height: 1,
                    ),
                itemCount: odataTag.value.length,
                itemBuilder: (context, index) {
                  return odataTag.value[index].name == "temp"
                      ? _buildButtonLoadMore(index, odataTag)
                      : _TagItem(
                          tag: odataTag.value[index],
                          odataTag: odataTag,
                          bloc: _bloc,
                          index: index,
                        );
                }),
          );
  }

  /// UI button loadmore cho nhãn
  Widget _buildButtonLoadMore(int index, OdataListResult<Tag> odataTag) {
    return BlocBuilder<TagBloc, TagState>(builder: (context, state) {
      if (state is TagLoadMoreLoading) {
        return Center(
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
          ),
        );
      }
      return Center(
        child: Container(
            margin:
                const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
            height: 45,
            child: FlatButton(
              onPressed: () {
                _skip = odataTag.value.length - 1;
                _bloc.add(TagLoadMoreLoaded(
                    top: _limit,
                    skip: _skip,
                    odataTag: odataTag,
                    keyWord: _searchController.text,
                    tagTypes: selectedTypes));
              },
              color: Colors.blueGrey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(S.current.loadMore,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(
                      width: 12,
                    ),
                    const Icon(
                      Icons.save_alt,
                      color: Colors.white,
                      size: 18,
                    )
                  ],
                ),
              ),
            )),
      );
    });
  }
}

/// UI hiển thị thông cho từng nhãn
class _TagItem extends StatelessWidget {
  const _TagItem({@required this.tag, this.odataTag, this.bloc, this.index})
      : assert(tag != null);

  final Tag tag;
  final OdataListResult<Tag> odataTag;
  final TagBloc bloc;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Colors.green,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                S.current.deleteALine,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 30,
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
        final dialogResult = await showQuestion(
            context: context,
            title: S.current.delete,
            message: "${S.current.tags_confirmDeleteTag} ${tag.name ?? ""}");
        if (dialogResult == DialogResultType.YES) {
          bloc.add(TagDeleted(tag: tag, odataTag: odataTag));
        }
        return false;
      },
      child: ListTile(
        onTap: () {
          FocusScope.of(context)?.requestFocus(FocusNode());
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TagCategoryInfoPage(
                      tag: tag,
                      callBack: (value) {
                        if (value != null) {
                          odataTag.value[index] = value;
                          bloc.add(TagLoadLocal(odataTag: odataTag));
                        }
                      },
                    )),
          ).then((value) {
            if (value != null) {
              bloc.add(TagDeleteLocal(tag: value, odataTag: odataTag));
            }
          });
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          tag.name ?? "",
          style: const TextStyle(color: Color(0xFF2C333A)),
        ),
        subtitle: Row(
          children: [
            const Icon(
              Icons.circle,
              color: Color(0xFF28A745),
              size: 6,
            ),
            const SizedBox(
              width: 6,
            ),
            Flexible(
              child: Text(
                convertTypeTagToName(tag.type),
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
              ),
            ),
          ],
        ),
        trailing: Container(
          width: 85,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Color(int.parse("0xFF${tag.color.replaceAll("#", "")}"))),
          child: Text(
            tag.name ?? "",
            style: const TextStyle(fontSize: 13, color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
