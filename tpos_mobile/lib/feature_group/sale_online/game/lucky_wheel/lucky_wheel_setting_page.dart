import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/sale_online/game/lucky_wheel/lucky_wheel_setting.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/number_input_dialog.dart';

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
      hasOrder: widget.luckyWheelSetting.hasOrder,
      isIgnorePriorityWinner: widget.luckyWheelSetting.isIgnorePriorityWinner,
      isPriorityShare: widget.luckyWheelSetting.isPriorityShare,
      isPriorityShareGroup: widget.luckyWheelSetting.isPriorityShareGroup,
      isPrioritySharePersonal: widget.luckyWheelSetting.isPrioritySharePersonal,
      timeInSecond: widget.luckyWheelSetting.timeInSecond,
      useShareApi: widget.luckyWheelSetting.useShareApi,
      isPriority: widget.luckyWheelSetting.isPriority,
      minNumberComment: widget.luckyWheelSetting.minNumberComment,
      isMinComment: widget.luckyWheelSetting.isMinComment,
      isPriorityUnWinner: widget.luckyWheelSetting.isPriorityUnWinner,
      minNumberShare: widget.luckyWheelSetting.minNumberShare,
      isMinShare: widget.luckyWheelSetting.isMinShare,
      isMinShareGroup: widget.luckyWheelSetting.isMinShareGroup,
      minNumberShareGroup: widget.luckyWheelSetting.minNumberShareGroup,
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
                  _buildPlayerList(),
                  const SizedBox(height: 20),
                  _buildObjectJoin(),
                  const SizedBox(height: 10),
                  _buildWinPriority(),
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
              ClipOval(
                child: Material(
                  color: Colors.white.withOpacity(0.13),
                  child: const BackButton(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              const Text('Cài đặt', style: TextStyle(color: Colors.white, fontSize: 21)),
            ],
          ),
          ClipOval(
            child: Material(
              color: Colors.white.withOpacity(0.13),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.save,
                  size: 25,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context, _luckyWheelSetting);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// UI cài đặt đối tượng tham gia.
  Widget _buildObjectJoin() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
            padding: const EdgeInsets.only(bottom: 15),
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
                  const SizedBox(width: 10),
                  const Text(
                    'Đối tượng tham gia',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.clip,
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 16),
                child: _luckyWheelSetting.useShareApi ? _buildShareSettings() : _buildCommentSettings(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 16, top: 10),
                child: Column(
                  children: [
                    _buildCheckItem(
                      title: 'Bỏ qua người thắng cuộc',
                      itemValue: _luckyWheelSetting.isSkipWinner,
                      onCheck: (bool value) {
                        _luckyWheelSetting.isSkipWinner = value;
                      },
                      subtitle: 'Không thêm người đã thắng cuộc trong quá khứ vào danh sách quay',
                    ),
                    _buildCheckItem(
                        title: 'KH có đơn hàng',
                        itemValue: _luckyWheelSetting.hasOrder,
                        onCheck: (bool value) {
                          _luckyWheelSetting.hasOrder = value;
                        }),
                  ],
                ),
              ),
            ]));
      },
    );
  }

  ///Xây dựng giao diện lấy danh sách người chơi từ share hay comment
  Widget _buildPlayerList() {
    return Theme(
      data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
      child: Container(
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
                const SizedBox(width: 10),
                const Text(
                  'Danh sách người chơi từ',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
              ]),
            ),
            RadioListTile<bool>(
              title: const Text(
                'KH có bình luận bài viết',
                style: TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
              value: false,
              activeColor: Colors.white,
              groupValue: _luckyWheelSetting.useShareApi,
              onChanged: (bool value) {
                _luckyWheelSetting.useShareApi = value;
                setState(() {});
              },
            ),
            RadioListTile<bool>(
              activeColor: Colors.white,
              title: const Text(
                'KH có chia sẻ bài viết',
                style: TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
              value: true,
              groupValue: _luckyWheelSetting.useShareApi,
              onChanged: (bool value) {
                _luckyWheelSetting.useShareApi = value;
                setState(() {});
              },
            ),
          ])),
    );
  }

  Widget _buildShareSettings() {
    return Column(
      children: [
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Column(
              children: [
                _buildCheckItem(
                    title: 'Có số lượt chia sẻ tối thiểu là ${_luckyWheelSetting.minNumberShare}',
                    itemValue: _luckyWheelSetting.isMinShare,
                    onCheck: (bool value) {
                      _luckyWheelSetting.isMinShare = value;
                    }),
                _buildNumberInput(
                    title: 'Số lượt chia sẻ tối thiểu',
                    value: _luckyWheelSetting.minNumberShare,
                    onValueChanged: (int value) {
                      _luckyWheelSetting.minNumberShare = value;
                      setState(() {});
                    }),
              ],
            );
          },
        ),
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Column(
              children: [
                _buildCheckItem(
                    title: 'Có số lượt chia sẻ nhóm tối thiểu là ${_luckyWheelSetting.minNumberShareGroup}',
                    itemValue: _luckyWheelSetting.isMinShareGroup,
                    onCheck: (bool value) {
                      _luckyWheelSetting.isMinShareGroup = value;
                    }),
                _buildNumberInput(
                    title: 'Số lượt chia sẻ nhóm tối thiểu',
                    value: _luckyWheelSetting.minNumberShareGroup,
                    onValueChanged: (int value) {
                      _luckyWheelSetting.minNumberShareGroup = value;
                      setState(() {});
                    }),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommentSettings() {
    return Column(
      children: [
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Column(
              children: [
                _buildCheckItem(
                    title: 'Có bình luận tối thiểu là ${_luckyWheelSetting.minNumberComment}',
                    itemValue: _luckyWheelSetting.isMinComment,
                    onCheck: (bool value) {
                      _luckyWheelSetting.isMinComment = value;
                    }),
                _buildNumberInput(
                    title: 'Số bình luận tối thiểu',
                    value: _luckyWheelSetting.minNumberComment,
                    onValueChanged: (int value) {
                      _luckyWheelSetting.minNumberComment = value;
                      setState(() {});
                    }),
              ],
            );
          },
        ),
      ],
    );
  }

  /// UI cài đặt ưu tiên trúng thưởng.
  Widget _buildWinPriority() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 5),
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
              offset: const Offset(-16, 5),
              child: const Text(
                'Ưu tiên trúng thưởng',
                style: TextStyle(fontSize: 18),
                overflow: TextOverflow.fade,
                softWrap: true,
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
            padding: const EdgeInsets.only(left: 10, right: 16),
            child: Column(
              children: [
                if (_luckyWheelSetting.useShareApi) _buildShareWinPriority(),
                // else
                //   _buildCommentWinPriority(),
                _buildCheckItem(
                    title: 'Người chơi chưa từng trúng thưởng',
                    itemValue: _luckyWheelSetting.isPriorityUnWinner,
                    onCheck: (bool value) {
                      _luckyWheelSetting.isPriorityUnWinner = value;
                    }),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                    return Column(
                      children: [
                        _buildCheckItem(
                            title: 'Không ưu tiên người đã thắng gần đây',
                            itemValue: _luckyWheelSetting.isIgnorePriorityWinner,
                            subtitle:
                                'Nếu người đó đã thắng trong khoảng ${_luckyWheelSetting.numberSkipDays} ngày gần đây sẽ chỉ được 1 vé tham dự nếu đủ điều kiện',
                            onCheck: (bool value) {
                              _luckyWheelSetting.isIgnorePriorityWinner = value;
                            }),
                        const SizedBox(height: 10),
                        _buildNumberInput(
                            title: 'Số ngày không ưu tiên người thắng',
                            value: _luckyWheelSetting.numberSkipDays,
                            onValueChanged: (int value) {
                              _luckyWheelSetting.numberSkipDays = value;
                              setState(() {});
                            }),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ]),
      );
    });
  }

  Widget _buildShareWinPriority() {
    return Column(
      children: [
        _buildCheckItem(
            title: 'Có lượt chia sẻ nhiều hơn',
            itemValue: _luckyWheelSetting.isPriorityShare,
            onCheck: (bool value) {
              _luckyWheelSetting.isPriorityShare = value;
            }),
        _buildCheckItem(
            title: 'Có lượt chia sẻ nhóm nhiều hơn',
            itemValue: _luckyWheelSetting.isPriorityShareGroup,
            onCheck: (bool value) {
              _luckyWheelSetting.isPriorityShareGroup = value;
            }),
      ],
    );
  }

  /// UI thời gian 1 vòng quay (s).
  Widget _buildTimeOneRotation() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Container(
        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 20),
        margin: const EdgeInsets.only(top: 15, bottom: 15),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(57, 159, 70, 1), borderRadius: BorderRadius.all(Radius.circular(15))),
        child: _buildNumberInput(
            title: 'Thời gian 1 vòng quay (s):',
            value: _luckyWheelSetting.timeInSecond,
            onValueChanged: (int value) {
              _luckyWheelSetting.timeInSecond = value;
            }),
      );
    });
  }

  Widget _buildNumberInput({String title, int value, Function(int) onValueChanged}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 17)),
          ),
          Flexible(
            child: StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildCircleButton(
                      child: const Icon(Icons.remove, color: Colors.white),
                      onPressed: () {
                        value ??= 0;
                        if (value > 0) {
                          value -= 1;
                          setState(() {});
                        }
                        onValueChanged?.call(value);
                      },
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: _buildEditValue(
                          onTap: () async {
                            value ??= 0;
                            final double number = await showNumberInputDialog(context, value.toDouble());
                            if (number != null) {
                              value = number.toInt();
                              setState(() {});
                              onValueChanged?.call(value);
                            }
                          },
                          value: value?.toString() ?? '0'),
                    ),
                    const SizedBox(width: 5),
                    _buildCircleButton(
                      child: const Icon(Icons.add, color: Colors.white, size: 25),
                      onPressed: () {
                        value ??= 0;
                        value += 1;
                        setState(() {});
                        onValueChanged?.call(value);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditValue({GestureTapCallback onTap, String value}) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      child: Material(
        color: const Color.fromRGBO(83, 172, 95, 1),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 9, top: 9),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: const Color(0xffE9EDF2))),
            child: Text(
              value,
              overflow: TextOverflow.fade,
              style: const TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({VoidCallback onPressed, Widget child}) {
    return ClipOval(
      child: Material(
        color: const Color.fromRGBO(83, 172, 95, 1),
        child: IconButton(
          iconSize: 25,
          icon: child,
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _buildCheckItem({String title, String subtitle, bool itemValue = false, Function(bool) onCheck}) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Switch(
              value: itemValue,
              onChanged: (value) {
                setState(() {
                  itemValue = value;
                });
                onCheck?.call(value);
              },
              activeTrackColor: const Color.fromRGBO(142, 203, 146, 1),
              activeColor: Colors.white,
            ),
            Expanded(
              child: subtitle != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          overflow: TextOverflow.fade,
                          softWrap: true,
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic),
                          overflow: TextOverflow.fade,
                          softWrap: true,
                        ),
                      ],
                    )
                  : Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      overflow: TextOverflow.fade,
                      softWrap: true,
                    ),
            )
          ],
        );
      },
    );
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
