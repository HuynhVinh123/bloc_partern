import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/product_template_tags/bloc/tag_product_bloc.dart';
import 'package:tpos_mobile/feature_group/category/product_template_tags/bloc/tag_product_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template_tags/bloc/tag_product_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/search_app_bar.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///Tìm kiếm các tag
///[onSelected] callback trả về danh sách các tag
///[selectedItems] nếu muốn đánh dấu các tag đã được chọn
///[tags] danh sách tag tìm kiếm
class TagProductListPage extends StatefulWidget {
  const TagProductListPage(
      {Key key, this.onSelected, this.selectedItems, this.tags})
      : super(key: key);

  @override
  _TagProductListPageState createState() => _TagProductListPageState();

  final Function(List<Tag>) onSelected;

  final List<Tag> selectedItems;
  final List<Tag> tags;
}

class _TagProductListPageState extends State<TagProductListPage> {
  TagProductBloc _tagProductBloc;
  final List<Tag> _selectedItems = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _tagController = TextEditingController();
  List<Tag> _tags;
  bool _isChange = false;
  String _search = '';
  final GlobalKey<SearchAppBarState> _searchKey =
      GlobalKey<SearchAppBarState>();
  @override
  void initState() {
    _tagProductBloc = TagProductBloc();
    if (widget.selectedItems != null) {
      _selectedItems.addAll(widget.selectedItems);
    }

    _tagProductBloc.add(TagProductStarted(tags: widget.tags));
    super.initState();
  }

  @override
  void dispose() {
    _tagController.dispose();
    _focusNode.dispose();
    _tagProductBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _isChange);
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
    return SearchAppBar(
      key: _searchKey,
      title: S.of(context).selectParam(S.current.tag.toLowerCase()),
      text: _search,
      hideBackWhenSearch: true,
      onKeyWordChanged: (String text) {
        if (_search != text) {
          _search = text;
          _tagProductBloc.add(TagProductSearched(keyword: text));
        }
      },
      actions: [
        ClipOval(
          child: Container(
            height: 50,
            width: 50,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                iconSize: 30,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  _showDialogAddTag();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<TagProductBloc, TagProductState>(
      loadingState: TagProductLoading,
      busyState: TagProductBusy,
      bloc: _tagProductBloc,
      errorState: TagProductLoadFailure,
      errorBuilder: (BuildContext context, TagProductState state) {
        String error = S.current.canNotGetDataFromServer;
        if (state is TagProductLoadFailure) {
          error = state.error ?? S.current.canNotGetDataFromServer;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.current.loadDataError,
                content: error,
                statusIcon: SvgPicture.asset('assets/icon/error.svg',
                    width: 170, height: 130),
                action: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AppButton(
                    onPressed: () {
                      _tagProductBloc.add(TagProductStarted(tags: widget.tags));
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
                            S.current.refreshPage,
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
      listener: (BuildContext context, TagProductState state) {
        if (state is TagProductAddTagSuccess) {
          final Widget snackBar = getCloseableSnackBar(
              message: S.of(context).addSuccessful, context: context);
          Scaffold.of(context).showSnackBar(snackBar);
          _isChange = true;
        } else if (state is TagProductAddTagFailure) {
          App.showDefaultDialog(
              title: S.of(context).error,
              context: context,
              type: AlertDialogType.error,
              content: state.error);
        }
      },
      builder: (BuildContext context, TagProductState state) {
        _tags = state.tags;
        return Column(
          children: [
            if (state.tags.isEmpty)
              Expanded(child: _buildEmptyList())
            else
              Expanded(child: _buildTags(state.tags)),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
              child: AppButton(
                onPressed: () {
                  widget.onSelected(_selectedItems);
                  Navigator.of(context).pop(_isChange);
                },
                borderRadius: 8,
                width: double.infinity,
                height: 48,
                background: const Color(0xff28A745),
                child: Text(
                  S.current.insert,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ///Xây dựng giao diện trống
  Widget _buildEmptyList() {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
        LoadStatusWidget.empty(
          statusName: S.current.noData,
          content: _search != ''
              ? S.current.searchNotFoundWithKeywordParam(
                  _search, S.current.tag.toLowerCase())
              : S.current.emptyNotificationParam(S.current.tag.toLowerCase()),
          action: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AppButton(
              onPressed: () {
                _showDialogAddTag();
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
                      Icons.add,
                      color: Colors.white,
                      size: 23,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      S.current.addNewParam(S.current.tag.toLowerCase()),
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
    ));
  }

  Widget _buildTags(List<Tag> tags) {
    return ListView.separated(
      itemCount: tags.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox();
      },
      itemBuilder: (BuildContext context, int index) {
        return _buildTagItem(tags[index]);
      },
    );
  }

  Widget _buildTagItem(Tag tag) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Column(
          children: <Widget>[
            const Divider(height: 2.0),
            ListTile(
              onTap: () {
                if (_selectedItems.any((Tag item) => item.id == tag.id)) {
                  _selectedItems.removeWhere((element) => element.id == tag.id);
                } else {
                  _selectedItems.add(tag);
                }
                setState(() {});
              },
              contentPadding:
                  const EdgeInsets.only(left: 13, right: 16, top: 5, bottom: 5),
              title: Text(tag.name ?? '', textAlign: TextAlign.start),
              leading: CircleAvatar(
                backgroundColor: const Color(0xffE9F6EC),
                child: Text(tag.name != null && tag.name != ''
                    ? tag.name.substring(0, 1)
                    : ''),
              ),
              trailing: _selectedItems.any((Tag item) => item.id == tag.id)
                  ? const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.check_circle,
                        color: Color(0xff28A745),
                        size: 20,
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        );
      },
    );
  }

  void _showDialogAddTag() {
    showDialog(
      useRootNavigator: false,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(bottom: 12, top: 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
            ),
          ),
          title: Text(
            S.current.addParam(S.current.tag.toLowerCase()),
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(S.current.tag),
                TextField(
                  controller: _tagController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: S.current
                        .enterParam(S.current.tags_TagName.toLowerCase()),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(S.current.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(S.current.confirm),
              onPressed: () {
                if (_tagController.text == "") {
                  App.showDefaultDialog(
                      title: S.of(context).warning,
                      context: context,
                      type: AlertDialogType.warning,
                      content: S.current.pleaseEnterParam(
                          S.current.tags_TagName.toLowerCase()));
                  _focusNode.requestFocus();
                  return;
                }
                if (_tags
                    .any((element) => element.name == _tagController.text)) {
                  App.showDefaultDialog(
                      title: S.of(context).warning,
                      context: context,
                      type: AlertDialogType.warning,
                      content:
                          S.current.alreadyExistsParam(S.current.tags_TagName));
                  _focusNode.requestFocus();
                  return;
                }

                _tagProductBloc.add(TagProductAdded(
                    tag: Tag(
                        name: _tagController.text, type: 'producttemplate')));
                _tagController.text = "";
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
