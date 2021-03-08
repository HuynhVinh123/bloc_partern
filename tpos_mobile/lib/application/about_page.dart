/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/10/19 11:55 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/10/19 9:29 AM
 *
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:tpos_mobile/resources/string_resources.dart';
import 'package:tpos_mobile/resources/themes.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String version;

  Future<void> getPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void initState() {
    getPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const dividerMin = Divider(
      height: 2,
    );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                primary: true,
                pinned: false,
                expandedHeight: 220,
                flexibleSpace: Container(
                  padding: const EdgeInsets.only(top: 50),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primary1Color,
                        AppTheme.primary2Color,
                      ],
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          "images/tpos_logo.png",
                        ),
                      ),
                      const SizedBox(),
                      Text(
                        S.current.appTitle,
                        style: const TextStyle(
                            fontSize: 20,
                            letterSpacing: 0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "${S.current.version} ${version ?? "release"}",
                        style: const TextStyle(
                            fontSize: 15,
                            letterSpacing: 0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.open_in_new,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              title: const Text("Website"),
                              subtitle: const Text(WEBSITE_URL),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () async {
                                const url = WEBSITE_URL;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {}
                              },
                            ),
                            dividerMin,
                            ListTile(
                              leading: Icon(
                                Icons.phonelink_lock,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              title: Text(S.current.privacyPolicy),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () async {
                                const url = PRIVACY_POLICY_URL;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {}
                              },
                            ),
                            dividerMin,
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Copyright © 2019-2021 TMT SOLUTION",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
