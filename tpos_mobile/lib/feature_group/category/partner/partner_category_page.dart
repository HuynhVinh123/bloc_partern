import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';

import 'package:tpos_mobile/src/tpos_apis/models/partner_category.dart';

import 'package:tpos_mobile/widgets/appbar_search_widget.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'partner_category_add_edit_page.dart';
import 'viewmodel/partner_category_viewmodel.dart';

class PartnerCategoryPage extends StatefulWidget {
  const PartnerCategoryPage(
      {this.partnerCategories, this.isSearchMode = true, this.keyWord = ""});
  final List<PartnerCategory> partnerCategories;
  final bool isSearchMode;
  final String keyWord;

  @override
  _PartnerCategoryPageState createState() =>
      _PartnerCategoryPageState(partnerCategories: partnerCategories);
}

class _PartnerCategoryPageState extends State<PartnerCategoryPage> {
  _PartnerCategoryPageState({this.partnerCategories});
  List<PartnerCategory> partnerCategories;

  PartnerCategoryViewModel viewModel = PartnerCategoryViewModel();

  @override
  void initState() {
    viewModel.keyword = widget.keyWord;
    viewModel.selectedPartnerCategories = partnerCategories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _showBody(),
    );
  }

  Widget _showBody() {
    return UIViewModelBase(
      viewModel: viewModel,
      child: StreamBuilder(
          stream: viewModel.partnerCategoriesStream,
          initialData: viewModel.partnerCategories,
          builder: (_, snapshot) {
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel.partnerCategories?.length ?? 0,
              separatorBuilder: (context, index) => const Divider(
                height: 2,
                indent: 50,
              ),
              itemBuilder: (context, position) {
                return Slidable(
                  actionPane: const SlidableDrawerActionPane(),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Text(viewModel.partnerCategories[position].name
                          .substring(0, 1)),
                    ),
                    onTap: () async {
                      if (widget.isSearchMode) {
                        Navigator.pop(
                            context, viewModel.partnerCategories[position]);
                      } else {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          final PartnerCategoryAddEditPage
                              productCategoryAddEditPage =
                              PartnerCategoryAddEditPage(
                            productCategoryId: snapshot.data[position].id,
                            onEdited: (cat) {
                              viewModel.partnerCategories[position] = cat;
                            },
                          );
                          return productCategoryAddEditPage;
                        }));
                      }
                    },
                    title: Text(
                      viewModel.partnerCategories[position].name ?? '',
                      textAlign: TextAlign.start,
                    ),
                    trailing: viewModel.selectedPartnerCategories?.any((f) =>
                                f.id ==
                                viewModel.partnerCategories[position].id) ==
                            true
                        ? const Icon(Icons.check)
                        : null,
                  ),
                  actionExtentRatio: 0.20,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      onTap: () {
                        viewModel.delete(viewModel.partnerCategories[position]);
                      },
                      caption: S.current.delete,
                      icon: Icons.delete,
                      color: Colors.red,
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
        child: AppbarSearchWidget(
          onTextChange: (text) {
            viewModel.keywordChangedCommand(text);
          },
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            final PartnerCategory newPartnerCategory = await Navigator.push(
                context, MaterialPageRoute(builder: (context) {
              const PartnerCategoryAddEditPage partnerCategoryAddEditPage =
                  PartnerCategoryAddEditPage(
                closeWhenDone: true,
              );
              return partnerCategoryAddEditPage;
            }));

            if (newPartnerCategory != null) {
              viewModel.addNewPartnerCategoryCommand(PartnerCategory(
                name: newPartnerCategory.name,
              ));
            }
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
