import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/application/menu/menu_widget.dart';
import 'package:tpos_mobile/application/menu/normal_menu_item_wrap.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/game_lucky_wheel_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/new_game_lucky_wheel_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/new_facebook_post_comment_viewmodel.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class GameMenuPage extends StatelessWidget {
  const GameMenuPage({Key key, @required this.commentViewModel})
      : super(key: key);
  final NewFacebookPostCommentViewModel commentViewModel;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.7),
          body: Container(
            margin: const EdgeInsets.only(top: 40, bottom: 40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.1, sigmaY: 3.1),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: media.size.height),
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 21, bottom: 22),
                                child: NormalMenuItemWrap(
                                  onReorder: (a1, a2) {},
                                  contentPadding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 64,
                                    bottom: 16,
                                  ),
                                  children: [
                                    NormalMenuItem(
                                      name: 'Vòng xoay may mắn',
                                      hasPermission: true,
                                      canDelete: false,
                                      icon: const Icon(
                                        Icons.gamepad,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        assert(commentViewModel != null);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                GameLuckyWheelPage(
                                              postId: commentViewModel
                                                  .facebookPost.id,
                                              uId: commentViewModel
                                                  .crmTeam.userUidOrPageId,
                                              commentVm: commentViewModel,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    // TODO(namnv): Bỏ if (kDebugMode) khi game hoàn thành
                                    if (kDebugMode || kReleaseMode)
                                      NormalMenuItem(
                                        name: 'Vòng xoay may mắn (New)',
                                        hasPermission: true,
                                        canDelete: false,
                                        height: 80,
                                        icon: const SvgIcon(
                                          SvgIcon.luckyWheel,
                                          size: 100,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NewGameLuckyWheelPage(
                                                crmTeam:
                                                    commentViewModel.crmTeam,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 42,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: AppColors.primary1,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 26, right: 26),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Icon(
                                          FontAwesomeIcons.gamepad,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          "Game tương tác",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: SizedBox(
                              width: double.infinity,
                              child: FlatButton(
                                color: Colors.white,
                                textColor: Colors.black,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(S.current.close),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
