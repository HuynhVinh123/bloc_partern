import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/tag_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

class TagListPage extends StatefulWidget {
  const TagListPage({this.tags, this.isAdd = true, this.isSelectMore = false});
  final List<Tag> tags;
  final bool isAdd;
  final bool isSelectMore;

  @override
  _TagListPageState createState() => _TagListPageState();
}

class _TagListPageState extends State<TagListPage> {
  var viewModel = locator<TagListViewModel>();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.tags = widget.tags;
    viewModel.tagDefaults = widget.tags;
  }

  /// Giao diện search Product
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
                      controller: _keywordController,
                      onChanged: (value) {
                        if (value == "" || value.length == 1) {
                          setState(() {});
                        }
                        viewModel.searchTag(value);
                      },
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Tìm kiếm",
                          border: InputBorder.none),
                    ),
                  )),
            ),
          ),
          Visibility(
            visible: _keywordController.text != "",
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
                setState(() {
                  _keywordController.text = "";
                });
                viewModel.searchTag("");
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

  @override
  Widget build(BuildContext context) {
    return ViewBase<TagListViewModel>(
        model: viewModel,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: viewModel.isSearch
                  ? _buildSearch()
                  : const Text("Danh sách Tag"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    viewModel.changeSearch();
                  },
                ),
                Visibility(
                  visible: widget.isAdd,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _showDialogAddTag();
                    },
                  ),
                )
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await viewModel.getTags();
              },
              child: ListView.separated(
                itemCount: viewModel.tags.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context, viewModel.tags[index]);
                    },
                    title: InkWell(
                        child: Text(
                      viewModel.tags[index].name,
                    )),
                  );
                },
              ),
            ),
          );
        });
  }

  void _showDialogAddTag() {
    showDialog(
      useRootNavigator: false,
      barrierDismissible: false,
      context: context,
      builder: (contxt) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(bottom: 12, top: 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
            ),
          ),
          title: const Text(
            "Thêm Tag",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("Tag"),
                TextField(
                  controller: _tagController,
                  decoration: const InputDecoration(
                    hintText: "Nhập tên",
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text("HỦY"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text("XÁC NHẬN"),
              onPressed: () {
                if (_tagController.text != "" &&
                    !viewModel.isCheckNameTag(_tagController.text)) {
                  _keywordController.text = _tagController.text;
                  viewModel.addTag(_tagController.text);
                  _tagController.text = "";
                  Navigator.pop(context);
                } else {
                  viewModel.showError();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
