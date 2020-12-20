import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/lucky_wheel_setting.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';

class LuckyWheelSettingPage extends StatefulWidget {
  const LuckyWheelSettingPage({Key key, this.luckyWheelSetting}) : super(key: key);

  @override
  _LuckyWheelSettingPageState createState() => _LuckyWheelSettingPageState();

  final LuckyWheelSetting luckyWheelSetting;
}

class _LuckyWheelSettingPageState extends State<LuckyWheelSettingPage> {
  LuckyWheelSetting _luckyWheelSetting;

  @override
  void initState() {
    _luckyWheelSetting = LuckyWheelSetting(
      numberSkipDays: widget.luckyWheelSetting.numberSkipDays,
      isSkipWinner: widget.luckyWheelSetting.isSkipWinner,
      isPriorityComment: widget.luckyWheelSetting.isPriorityComment,
      hasComment: widget.luckyWheelSetting.hasComment,
      hasOrder: widget.luckyWheelSetting.hasOrder,
      hasShare: widget.luckyWheelSetting.hasShare,
      isIgnorePriorityWinner: widget.luckyWheelSetting.isIgnorePriorityWinner,
      isPriorityShare: widget.luckyWheelSetting.isPriorityShare,
      isPriorityShareGroup: widget.luckyWheelSetting.isPriorityShareGroup,
      isPrioritySharePersonal: widget.luckyWheelSetting.isPrioritySharePersonal,
      timeInSecond: widget.luckyWheelSetting.timeInSecond,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(33, 140, 38, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: const Color.fromRGBO(33, 140, 38, 1),
              padding: const EdgeInsets.only(left: 16, right: 15, top: 10, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildAppBar(),
                  _buidObjectJoin(),
                  _buldWinPriority(),
                  _buildTimeOneRotation(),
                  _buildButton(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withOpacity(0.13),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 35,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 26),
              const Text('Cài đặt', style: TextStyle(color: Colors.white, fontSize: 21)),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.13),
            radius: 28,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.save,
                size: 30,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context, _luckyWheelSetting);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// UI cài đặt đối tượng tham gia.
  Widget _buidObjectJoin() {

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
            padding: const EdgeInsets.only(bottom: 17),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(59, 160, 70, 1), borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 20, top: 17, bottom: 17),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(100, 182, 105, 1),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
                child: Row(children: [
                  Image.asset('assets/game/lucky_wheel/icon/ic_user.png'),
                  Text(
                    '   Đối tượng tham gia',
                    style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05),
                    overflow: TextOverflow.clip,
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: _luckyWheelSetting.hasComment,
                          onChanged: (value) {
                            setState(() {
                              _luckyWheelSetting.hasComment = value;
                            });
                          },
                          activeTrackColor: const Color.fromRGBO(142, 203, 146, 1),
                          activeColor: Colors.white,
                        ),
                        Text(
                          'KH có bình luận bài viết',
                          style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                          overflow: TextOverflow.clip,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Switch(
                          value: _luckyWheelSetting.hasShare,
                          onChanged: (value) {
                            setState(() {
                              _luckyWheelSetting.hasShare = value;
                            });
                          },
                          activeTrackColor: const Color.fromRGBO(142, 203, 146, 1),
                          activeColor: Colors.white,
                        ),
                        Text(
                          'KH có chia sẻ bài viết',
                          style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                          overflow: TextOverflow.clip,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Switch(
                          value: _luckyWheelSetting.hasOrder,
                          onChanged: (value) {
                            setState(() {
                              _luckyWheelSetting.hasOrder = value;
                            });
                          },
                          activeTrackColor: const Color.fromRGBO(142, 203, 146, 1),
                          activeColor: Colors.white,
                        ),
                        Text(
                          'KH có mua hàng',
                          style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Text(
                        'Không có đơn hàng sẽ không được phép chơi',
                        style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    Row(
                      children: [
                        Switch(
                          value: _luckyWheelSetting.isSkipWinner,
                          onChanged: (value) {
                            setState(() {
                              _luckyWheelSetting.isSkipWinner = value;
                            });
                          },
                          activeTrackColor: const Color.fromRGBO(142, 203, 146, 1),
                          activeColor: Colors.white,
                        ),
                        Text(
                          'Bỏ qua người thắng cuộc',
                          style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                          overflow: TextOverflow.clip,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Text(
                        'Không thêm người đã thắng cuộc trong quá khứ vào danh sách quay',
                        style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                        overflow: TextOverflow.clip,
                      ),
                    )
                  ],
                ),
              ),
            ]));
      },
    );
  }

  /// UI cài đặt ưu tiên trúng thưởng.
  Widget _buldWinPriority() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Container(
        margin: const EdgeInsets.only(top: 15, bottom: 5),
        padding: const EdgeInsets.only(bottom: 17),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(59, 160, 70, 1), borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(children: <Widget>[
          AppBar(
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
            backgroundColor: const Color.fromRGBO(100, 182, 105, 1),
            leading: Image.asset(
              'assets/game/lucky_wheel/icon/ic_gift.png',
              scale: 1.2,
            ),
            title: Transform.translate(
              offset: const Offset(-16, 0),
              child: Text(
                'Ưu tiên trúng thưởng',
                style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.046),
                overflow: TextOverflow.clip,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Switch(
                  value: _luckyWheelSetting.isPriority,
                  onChanged: (value) {
                    setState(() {
                      _luckyWheelSetting.isPriority = value;
                    });
                  },
                  activeTrackColor: const Color.fromRGBO(142, 203, 146, 1),
                  activeColor: Colors.white,
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Switch(
                      value: _luckyWheelSetting.isPriorityShare,
                      onChanged: (value) {
                        setState(() {
                          _luckyWheelSetting.isPriorityShare = value;
                        });
                      },
                      activeTrackColor: const Color.fromRGBO(142, 203, 146, 1),
                      activeColor: Colors.white,
                    ),
                    Text(
                      'Lượt share nhiều hơn',
                      style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                      overflow: TextOverflow.clip,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: Row(
                    children: [
                      Switch(
                        value: _luckyWheelSetting.isPriorityShareGroup,
                        onChanged: (value) {
                          setState(() {
                            _luckyWheelSetting.isPriorityShareGroup = value;
                          });
                        },
                        activeTrackColor: const Color.fromRGBO(142, 203, 146, 1),
                        activeColor: Colors.white,
                      ),
                      Text(
                        'Share theo nhóm',
                        style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: Row(
                    children: [
                      Switch(
                        value: _luckyWheelSetting.isPrioritySharePersonal,
                        onChanged: (value) {
                          setState(() {
                            _luckyWheelSetting.isPrioritySharePersonal = value;
                          });
                        },
                        activeTrackColor: const Color.fromRGBO(142, 203, 146, 1),
                        activeColor: Colors.white,
                      ),
                      Text(
                        'Share cá nhân',
                        style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Switch(
                      value: _luckyWheelSetting.isPriorityComment,
                      onChanged: (value) {
                        setState(() {
                          _luckyWheelSetting.isPriorityComment = value;
                        });
                      },
                      activeTrackColor: const Color.fromRGBO(142, 203, 146, 1),
                      activeColor: Colors.white,
                    ),
                    Text(
                      'Lượt comment nhiều hơn',
                      style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                      overflow: TextOverflow.clip,
                    )
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: _luckyWheelSetting.isIgnorePriorityWinner,
                      onChanged: (value) {
                        setState(() {
                          _luckyWheelSetting.isIgnorePriorityWinner = value;
                        });
                      },
                      activeTrackColor: const Color.fromRGBO(142, 203, 146, 1),
                      activeColor: Colors.white,
                    ),
                    Flexible(
                      child: Text(
                        'Không ưu tiên người đã thắng gần đây',
                        style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                        overflow: TextOverflow.clip,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, top: 10),
                  child: Text(
                    'Nếu người đó đã thắng trong khoảng 14 ngày gần đây sẽ chỉ được 1 vé tham dự nếu đủ điều kiện',
                    style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                    overflow: TextOverflow.clip,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, top: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Text(
                          'Số ngày bỏ qua:',
                          style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        flex: 2,
                        child: StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) setState) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color.fromRGBO(83, 172, 95, 1),
                                  radius: MediaQuery.of(context).size.height * 0.03,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.remove),
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        if (_luckyWheelSetting.numberSkipDays > 0) {
                                          _luckyWheelSetting.numberSkipDays--;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(89, 174, 100, 1),
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: const Color.fromARGB(122, 255, 255, 255), width: 1)),
                                  child: Text(_luckyWheelSetting.numberSkipDays.toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 21)),
                                ),
                                CircleAvatar(
                                  backgroundColor: const Color.fromRGBO(83, 172, 95, 1),
                                  radius: MediaQuery.of(context).size.height * 0.03,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.add),
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        _luckyWheelSetting.numberSkipDays++;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    });
  }

  /// UI thời gian 1 vòng quay (s).
  Widget _buildTimeOneRotation() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Container(
          padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 20),
          margin: const EdgeInsets.only(top: 15, bottom: 15),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(57, 159, 70, 1), borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  'Thời gian 1 vòng quay (s):',
                  style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.045),
                  overflow: TextOverflow.clip,
                ),
              ),
              Flexible(
                flex: 2,
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromRGBO(83, 172, 95, 1),
                          radius: MediaQuery.of(context).size.height * 0.03,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.remove),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                if (_luckyWheelSetting.timeInSecond > 0) _luckyWheelSetting.timeInSecond--;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(89, 174, 100, 1),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: const Color.fromARGB(122, 255, 255, 255), width: 1)),
                          child: Text(_luckyWheelSetting.timeInSecond.toString() ?? '0',
                              style: const TextStyle(color: Colors.white, fontSize: 21)),
                        ),
                        CircleAvatar(
                          backgroundColor: const Color.fromRGBO(83, 172, 95, 1),
                          radius: MediaQuery.of(context).size.height * 0.03,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                _luckyWheelSetting.timeInSecond++;
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ));
    });
  }

  /// UI button lưu cấu hình.
  Widget _buildButton() {
    return AppButton(
      background: Colors.white,
      onPressed: () {
        Navigator.pop(context, _luckyWheelSetting);
      },
      borderRadius: 12,
      width: double.infinity,
      child: const Text('Lưu cấu hình',
          style: TextStyle(color: Color.fromRGBO(0, 142, 48, 1), fontSize: 17, fontWeight: FontWeight.w500)),
    );
  }
}
