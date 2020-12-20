/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';

import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/facebook_post_with_channel.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_online_facebook_post_viewmodel.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as time_ago;

import 'new_facebook_post_comment_page.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class SaleOnlineFacebookPostPage extends StatefulWidget {
  const SaleOnlineFacebookPostPage({
    @required this.crmTeam,
    this.selectMode = false,
  }) : assert(crmTeam != null);
  final CRMTeam crmTeam;
  final bool selectMode;

  @override
  _SaleOnlineFacebookPostPageState createState() =>
      _SaleOnlineFacebookPostPageState();
}

class _SaleOnlineFacebookPostPageState
    extends State<SaleOnlineFacebookPostPage> {
  _SaleOnlineFacebookPostPageState();
  final dividerMin = const Divider(
    height: 2,
  );

  final viewModel = SaleOnlineFacebookPostViewModel();

  ScrollController postScrollController = ScrollController();
  bool _isPullToRefresh = false;
  @override
  void initState() {
    super.initState();

    viewModel.init(
      crmTeam: widget.crmTeam,
    );

    viewModel.dialogMessageController.listen((data) {
      registerDialogToView(context, data);
    });

    postScrollController.addListener(() {
      final double maxScroll = postScrollController.position.maxScrollExtent;
      final double currentScroll = postScrollController.position.pixels;
      const double delta = 200.0; // or something else..
      if (maxScroll - currentScroll <= delta) {
        // whatever you determine here
        viewModel.loadMoreFacebookPostCommand();
      }
    });

    time_ago.setLocaleMessages("vi", time_ago.ViMessages());
  }

  @override
  void didChangeDependencies() {
    viewModel.notifyPropertyChangedController.listen((name) {
      setState(() {});
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(widget.crmTeam.name ?? ''),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctxt) {
                    final TextEditingController _customPostIdController =
                        TextEditingController();
                    return AlertDialog(
                      // Nhập ID Live video
                      title: Text(S.current.saleOnline_EnterId),
                      content: TextField(
                        controller: _customPostIdController,
                        style: const TextStyle(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Ví dụ: 1722166934595222",
                            labelText: S.current.saleOnline_PostId),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(S.current.cancel.toUpperCase()),
                          onPressed: () {
                            Navigator.pop(ctxt);
                          },
                        ),
                        FlatButton(
                          child: Text(S.current.confirm.toUpperCase()),
                          onPressed: () {
                            Navigator.pop(ctxt);
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (ctxt) {
                                  return NewFacebookPostCommentPage(
                                    crmTeam: widget.crmTeam,
                                    facebookPost: FacebookPost(
                                      type: "video",
                                      id: "${widget.crmTeam.userAsuidOrPageId}_${_customPostIdController.text.trim()}",
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: UIViewModelBase(
        viewModel: viewModel,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _showHeader(),
            Expanded(child: _showPost()),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _showHeader() {
    return Container(
      color: Colors.white,
      height: 50,
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          Text("${S.current.type}: "),
          StreamBuilder<FacebookPostType>(
              stream: viewModel.postTypeStream,
              initialData: viewModel.postType,
              builder: (context, snapshot) {
                return DropdownButton(
                  underline: const SizedBox(),
                  style:
                      const TextStyle(color: Colors.blueAccent, fontSize: 17),
                  hint: Text(S.current.filter),
                  items: FacebookPostType.values.map((FacebookPostType f) {
                    String name = "";
                    switch (f) {
                      case FacebookPostType.all:
                        name = "Tất cả";
                        break;
                      case FacebookPostType.link:
                        name = "Link";
                        break;
                      case FacebookPostType.video:
                        name = "Video";
                        break;
                      case FacebookPostType.photo:
                        name = "Photo";
                        break;
                      case FacebookPostType.offer:
                        name = "Offer";
                        break;
                      case FacebookPostType.status:
                        name = "Status";
                        break;
                    }

                    return DropdownMenuItem<FacebookPostType>(
                      value: f,
                      child: Text(
                        name ?? '',
                      ),
                    );
                  }).toList(),
                  onChanged: (item) {
                    viewModel.postType = item;
                    viewModel.refreshFacebookPost();
                  },
                  value: viewModel.postType,
                );
              }),
          Checkbox(
            value: viewModel.isOnlyShowPostHasComment,
            onChanged: (bool value) {
              setState(() {
                viewModel.isOnlyShowPostHasComment = value;
                viewModel.refreshFacebookPost();
              });
            },
          ),
          Expanded(
            child: Text(
              "${S.current.saleOnline_checkboxOnlyTenComment}:",
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _showPost() {
    return RefreshIndicator(
      semanticsLabel: "Loading",
      semanticsValue: "Loading",
      onRefresh: () async {
        _isPullToRefresh = true;
        await viewModel.refreshFacebookPost();
        _isPullToRefresh = false;
        return Future.value();
      },
      child: StreamBuilder<List<FacebookPost>>(
        stream: viewModel.facebookPostsStream,
        initialData: viewModel.facebookPosts,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: FlatButton(
                  child: Text(
                    "${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    setState(() {});
                    await viewModel.refreshFacebookPost();
                  },
                ),
              );
            }

            return StreamBuilder<bool>(
                stream: viewModel.isLoadingFacebookPostStream,
                initialData: viewModel.isLoadingFacebookPost,
                builder: (context, snapshot) {
                  if (snapshot.data && _isPullToRefresh == false) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return CustomScrollView(
                    controller: postScrollController,
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ct, index) {
                            if (index == viewModel.facebookPosts.length) {
                              if (viewModel.facebookPostPaging != null &&
                                  viewModel.facebookPostPaging.next != null) {
                                // load more
                                return StreamBuilder(
                                    stream: viewModel
                                        .isLoadingMoreFacebookPostStream,
                                    initialData:
                                        viewModel.isLoadingMoreFacebookPost,
                                    builder: (ctx, snapshot) {
                                      if (snapshot.data == true) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: FlatButton(
                                            color: Colors.indigo,
                                            textColor: Colors.white,
                                            shape: OutlineInputBorder(
                                              borderSide:
                                                  const BorderSide(width: 0),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              "${S.current.loadMore}...",
                                            ),
                                            onPressed: () {
                                              viewModel.loadFacebookPost();
                                            },
                                          ),
                                        );
                                      }
                                    });
                              } else {
                                return const Text("");
                              }
                            } else {
                              return _buildPostItem(
                                viewModel.facebookPosts[index],
                              );
                            }
                          },
                          childCount:
                              (viewModel.facebookPosts?.length ?? 0) + 1 ?? 0,
                        ),
                      ),
                    ],
                  );
                });
          }
        },
      ),
    );
  }

  /// Xây dựng UI 1 bài viết trong danh sách [FacebookPosts]
  /// + Ảnh đại diện, Ngày tháng, Tiêu đề, Số lượng like, share
  Widget _buildPostItem(FacebookPost item) {
    return Card(
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Ngày
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    if (item.isVideo)
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          FontAwesomeIcons.video,
                          size: 17,
                          color: Colors.red,
                        ),
                      ),
                    if (item.isLive)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          S.current.live.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    Icon(
                      Icons.date_range,
                      color: Colors.blue.shade400,
                    ),
                    Expanded(
                      child: Text(
                        (item.createdTime?.toLocal() ??
                                item.updatedTime?.toLocal() ??
                                DateTime.now())
                            .toStringFormat("dd/MM/yyyy HH:mm"),
                        style: TextStyle(color: Colors.blue.shade400),
                      ),
                    ),
                    InkWell(
                      child: const Icon(
                        Icons.more_horiz,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        _showModalBottomMenu(item);
                      },
                    ),
                  ],
                ),
              ),
              if (item.liveCampaignName != null &&
                  item.liveCampaignName.isNotEmpty)
                SizedBox(
                  child: Card(
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "${S.current.liveCampaign}: ${item.liveCampaignName}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(),
              Text(
                StringUtils.trimUnicode(item.message, 100) ?? '',
              ),
            ],
          ),
          leading: _showPostImage(facebookPost: item),
          subtitle: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: item.createdTime != null
                      ? Text(
                          time_ago.format(
                              item.createdTime ??
                                  item.updatedTime ??
                                  DateTime.now(),
                              locale: S.current.languageCode),
                        )
                      : const Text(''),
                ),
                Icon(
                  Icons.thumb_up,
                  color: Colors.blue.shade400,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    " ${item.toltalLike}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.comment),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "${item.totalComment}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            item.isSave == true ? Colors.black87 : Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            if (widget.selectMode) {
              Navigator.pop(
                context,
                FacebookPostWithChannel(
                  crmTeam: widget.crmTeam,
                  post: item,
                ),
              );
            } else {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return NewFacebookPostCommentPage(
                      crmTeam: widget.crmTeam,
                      facebookPost: item,
                    );
                  },
                ),
              );
            }
          },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 100,
                    width: 100,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        ListTile(
                          title: const Text("Đi tới bài viết"),
                          onTap: () async {
                            final url = "https://facebook.com/${item.id}";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch Maps';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _showPostImage({FacebookPost facebookPost}) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        children: <Widget>[
          if (facebookPost.picture == null)
            Image.asset(
              "images/no_image.png",
              height: 90,
              width: 90,
            )
          else
            Image.network(
              facebookPost.picture ?? '',
              fit: BoxFit.cover,
              height: 90,
              width: 90,
            ),
          Center(child: _showPostImageType(facebookPost.type)),
        ],
      ),
    );
  }

  Widget _showPostImageType(String type) {
    switch (type) {
      case "video":
        return Image.asset(
          "images/facebook_play.png",
          height: 50,
          width: 50,
        );
        break;
      case "link":
        return const SizedBox();
        break;
      case "photo":
        return const SizedBox();
        break;
    }

    return const SizedBox();
  }

  void _showModalBottomMenu(FacebookPost post) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BottomSheet(
            shape: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            builder: (context) => ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
//                ListTile(
//                  leading: Icon(Icons.open_in_new),
//                  title: Text("Mở trên facebook"),
//                  onTap: () async {
//                    Navigator.pop(context);
//                    // Goto facebook
//
//                    //333347943781959_827106614338372
//                    var url = "fb://feed";
//                    print(url);
//                    if (await canLaunch(url)) {
//                      await launch(url);
//                    } else {
//                      print("cannot");
//                    }
//                  },
                // ),
                dividerMin,
                ListTile(
                  leading: const Icon(Icons.open_in_browser),
                  title: Text(S.current.openWithBrowser),
                  onTap: () async {
                    final url = "https://facebook.com/${post.id}";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch Maps';
                    }
                  },
                ),
                dividerMin,
                ListTile(
                  leading: const Icon(
                    Icons.save,
                    color: Colors.blue,
                  ),
                  title: Text(S.current.saveComments),
                  onTap: () async {
                    Navigator.pop(context);
                    viewModel.saveComment(post);
                  },
                ),
                const ListTile(),
              ],
            ),
            onClosing: () {},
          );
        });
  }

//  Widget _showLongPressMenu() {
//    return  AlertDialog(
//      content: Column(),
//    );
//  }
}
