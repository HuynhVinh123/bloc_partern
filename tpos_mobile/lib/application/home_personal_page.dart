/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/4/19 6:25 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/4/19 10:18 AM
 *
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/application/company_change/company_change_page.dart';
import 'package:tpos_mobile/application/viewmodel/home_personal_viewmodel.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile/resources/string_resources.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/app_route.dart';
import 'application/application_bloc.dart';
import 'application/application_event.dart';
import 'change_pass_word_page.dart';

class HomePersonalPage extends StatefulWidget {
  @override
  _HomePersonalPageState createState() => _HomePersonalPageState();
}

class _HomePersonalPageState extends State<HomePersonalPage> {
  final _vm = HomePersonalViewModel();

  @override
  void initState() {
    _vm.initData();
    super.initState();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<HomePersonalViewModel>(
      model: _vm,
      child: SafeArea(
        child: Scaffold(
          body: _buildBody(),
          backgroundColor: Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        _vm.refreshData();
        return true;
      },
      child: ListView(
        children: <Widget>[
          ScopedModelDescendant<HomePersonalViewModel>(
            builder: (context, child, model) => Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    height: 70,
                    width: 70,
                    child: CircleAvatar(
                      backgroundImage: model.loginUser != null
                          ? NetworkImage(model.loginUser.avatar ?? '')
                          : const NetworkImage("images/no_image.png"),
                      radius: 50,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  child: Text(
                                    model.companyName,
                                    style: const TextStyle(
                                        color: Colors.blue, fontSize: 17),
                                  ),
                                  onTap: () {
                                    // TODO GOTO Edit company
                                  },
                                ),
                              ),
                              InkWell(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      S.current.change,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return CompanyChangePage();
                                      },
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            model.shopUrl,
                            style: const TextStyle(color: Colors.green),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            S.current.dateUserLeft(
                                model.currentCompany?.expiredInShort ?? "N/A"),
                            // "Còn khoảng ${model.currentCompany?.expiredInShort ?? "N/A"} sử dụng",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            child: Text(
                              '${S.current.loginBy} ${model.loginUsername}',
                              style: const TextStyle(color: Colors.blue),
                            ),
                            onTap: () {},
                          ),
                          Row(
                            children: <Widget>[
                              OutlineButton(
                                child: Text(
                                  S.current.history,
                                  textAlign: TextAlign.left,
                                ),
                                textColor: Colors.green,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AppRoute.history);
                                },
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              OutlineButton(
                                child: Text(S.current.changePassword),
                                textColor: Colors.blue,
                                onPressed: () {
//                                  showDialog(
//                                    context: context,
//                                    builder: (context) =>
//                                        const ChangePassWordDialog(null),
//                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            const ChangePassWordPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Material(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const SettingIcon(
                    Icon(
                      Icons.new_releases,
                      size: 17,
                    ),
                  ),
                  title: Text(S.current.checkForUpdate),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () async {
                    StoreRedirect.redirect(
                        androidAppId: ANDROID_APP_ID, iOSAppId: APPLE_APP_ID);
                  },
                ),
                if (!Platform.isIOS) ...[
                  const Divider(
                    height: 1,
                    indent: 12,
                  ),
                  ListTile(
                    leading: const SettingIcon(
                      Icon(
                        Icons.rate_review,
                        size: 17,
                      ),
                    ),
                    title: Text(S.current.voteForApp),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            color: const Color(0xFF737373),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  color: Colors.white),
                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          S.current.setting_notifyRateApp,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black87),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: OutlineButton(
                                            child: Text(
                                              S.current
                                                  .setting_notifyRateAppActionNo,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            color: Colors.white,
                                            textColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton(
                                            child: Text(
                                              S.current.yes,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            onPressed: () async {
                                              StoreRedirect.redirect(
                                                  androidAppId: ANDROID_APP_ID,
                                                  iOSAppId: APPLE_APP_ID);
                                            },
                                            color:
                                                Theme.of(context).primaryColor,
                                            textColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

//
                    },
                  ),
                ],
                const Divider(
                  height: 1,
                  indent: 12,
                ),
                ListTile(
                  leading: const SettingIcon(
                    Icon(
                      Icons.email,
                      size: 17,
                    ),
                  ),
                  title: Text(S.current.sendEmailFeedback),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final url =
                        'mailto:$CONTACT_EMAIL?subject=${Uri.encodeFull(CONTACT_EMAIL_SUBJECT)}&body=';

                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {}
                  },
                ),
                const Divider(
                  height: 1,
                  indent: 12,
                ),
                ListTile(
                  leading: const SettingIcon(Icon(
                    Icons.settings,
                    size: 17,
                  )),
                  title: Text(S.current.setting),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.setting);
                  },
                ),
                const Divider(
                  height: 1,
                  indent: 12,
                ),
                ListTile(
                  leading: const SettingIcon(
                    Icon(
                      Icons.info,
                      size: 17,
                    ),
                  ),
                  title: Row(children: <Widget>[
                    Expanded(
                      child: Text(S.current.aboutApplication),
                    ),
                    Text(
                      App.appVersion ?? '',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ]),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoute.about);
                  },
                ),
                const Divider(
                  height: 1,
                  indent: 12,
                ),
                ListTile(
                  leading: const SettingIcon(
                    Icon(
                      Icons.info,
                      size: 17,
                    ),
                  ),
                  title: Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          "Application language",
                        ),
                      ),
                      Text(
                        Localizations.localeOf(context).getText(),
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showLanguageSelect(context);
                  },
                ),
                const Divider(
                  height: 1,
                  indent: 12,
                ),
                ListTile(
                  leading: const SettingIcon(
                    Icon(
                      FontAwesomeIcons.doorClosed,
                      size: 15,
                    ),
                  ),
                  title: Text(S.current.logout),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    // Đăng xuất
                    BlocProvider.of<ApplicationBloc>(context)
                        .add(ApplicationLogout());
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SettingIcon extends StatelessWidget {
  const SettingIcon(this.icon);
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.green.shade100.withOpacity(0.5),
        ),
      ),
      padding: const EdgeInsets.all(3),
      child: icon,
    );
  }
}

class SwitchCompanyPage extends StatefulWidget {
  @override
  _SwitchCompanyPageState createState() => _SwitchCompanyPageState();
}

class _SwitchCompanyPageState extends State<SwitchCompanyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return const ListTile();
          }),
    );
  }
}
