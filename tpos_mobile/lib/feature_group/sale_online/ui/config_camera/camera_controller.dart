import 'dart:async';
import 'dart:convert';

import 'package:camera_with_rtmp/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/reports/custom_date_time.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/config_camera/content_title_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/config_camera/living_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/config_camera/preset.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/config_camera/preset_page.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';

class CameraControllerConfig extends StatefulWidget {
  const CameraControllerConfig({this.tokens, this.crmTeams});

  final List<CRMTeam> crmTeams;
  final List<String> tokens;

  @override
  _CameraControllerConfigState createState() => _CameraControllerConfigState();
}

class _CameraControllerConfigState extends State<CameraControllerConfig> {
  CameraController _controller;
  List<CameraDescription> _cameras = [];
  final List<String> _urls = [];

  final List<FacebookLivestream> _facebookLives = [];
  String _liveTitle = '';
  String _liveContent = '';
  bool _isLiveStreaming = false;
  bool _isPause = false;
  int _positionScale = 3;
  Size _size;
  bool _isConnectNetwork = true;
  bool _isPreparing = false;
  final bool _isStopping = false;
  final String _notifyInternet =
      "Không có kết nối internet. Vui lòng mở kết nối internet";
  double opacityValue = 0;

  // Tỉ lệ khung hình
  List<Map<String, dynamic>> ratios;

  // Chất lượng hình ảnh
  ResolutionPreset preset = ResolutionPreset.medium;

  // Check connect internet
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
    ratios = [
      {'key': "1:1", 'value': 1 / 1},
      {'key': "3:4", 'value': 3 / 4},
      {'key': "9:16", 'value': 9 / 16},
      {'key': "Full", 'value': null}
    ];

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (_isLiveStreaming) {
      if (ConnectivityResult.none != result) {
        if (!_isConnectNetwork) {
          _controller
              .reConnectVideoStreaming(bitrate: bitrate(preset))
              .then((value) {
            setState(() {
              _isConnectNetwork = true;
            });
          });
        }
      } else {
        setState(() {
          _isConnectNetwork = false;
        });
      }
    }
  }

  Future initData() async {
    try {
      await initConnectivity();
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
      if (_cameras != null && _cameras.isNotEmpty) {
        onNewCameraSelected(_cameras[0]);
      }
    } on CameraException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    ratios[3]['value'] = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
        body: SafeArea(
            child: Container(
                child: _cameraPreviewWidget(context),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: _controller != null &&
                              _controller.value.isRecordingVideo
                          ? _controller.value.isStreamingVideoRtmp
                              ? Colors.redAccent
                              : Colors.orangeAccent
                          : _controller != null &&
                                  _controller.value.isStreamingVideoRtmp
                              ? Colors.blueAccent
                              : Colors.grey,
                      width: 3.0,
                    )))));
  }

  // ignore: avoid_void_async
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      _controller.switchCamera(cameraDescription);
      setState(() {
        _controller.description = cameraDescription;
      });
    } else {
      _controller = CameraController(_cameras[0], preset,
          enableAudio: true, androidUseOpenGL: true);
      try {
        await _controller.initialize();
      } on CameraException catch (e) {}
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget(BuildContext context) {
    _size = MediaQuery.of(context).size;
    if (_controller == null || !_controller.value.isInitialized) {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Center(
              child: Text('Đang chờ LiveStream',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900))));
    } else {
      return Stack(
        children: [
          _buildCamera(),
          _buildAppBar(),
          Positioned(
            bottom: 6,
            left: 6,
            right: 0,
            child: _buildPauseAndPlayLive(),
          ),
          Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 160,
              child: _buildContentLive()),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: _isStopping
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black87,
                      child: const Center(
                        child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white)),
                      ),
                    )
                  : _buildUINoConnectInternet()),
          Positioned(
              left: 6,
              bottom: 38,
              child: AnimatedOpacity(
                opacity: opacityValue,
                duration: Duration(milliseconds: 500),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: Colors.black54,
                  ),
                  width: 130,
                  height: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UIEventLive(
                        title: "Switch camera",
                        onTap: () {
                          if (!_isPreparing) {
                            onNewCameraSelected(
                                _controller.description == _cameras[0]
                                    ? _cameras[1]
                                    : _cameras[0]);
                          }
                        },
                        icon: const Icon(Icons.flip_camera_ios_outlined,
                            color: Colors.white, size: 20),
                      ),
                      const Divider(height: 2, color: Colors.black),
                      UIEventLive(
                        title: "Thêm page",
                        onTap: () {},
                        icon: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                      ),
                      const Divider(height: 2, color: Colors.black),
                      UIEventLive(
                        title: "Page đang live",
                        onTap: () {
                          showPageLiving(context);
                        },
                        icon: const Icon(Icons.zoom_out_map,
                            color: Colors.white, size: 20),
                      ),
                      const Divider(height: 2, color: Colors.black),
                      UIEventLive(
                        title: "Tạm dừng",
                        onTap: () async {
                          await pauseStream();
                        },
                        icon: const Icon(Icons.pause_circle_outline_rounded,
                            color: Colors.white, size: 20),
                      ),
                      // const Divider(height: 2,color: Colors.black),
                      // UIEventLive(
                      //   title: "Phát",
                      //   onTap: () async {
                      //     await resumeStream();
                      //   },
                      //   icon: const Icon(Icons.play_arrow_outlined,
                      //       color: Colors.white, size: 20),
                      // ),
                    ],
                  ),
                ),
              ))
        ],
      );
    }
  }

  Widget _buildCamera() {
    return Center(
      child: Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: ratios[_positionScale]["value"],
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: _size.aspectRatio >= ratios[_positionScale]["value"]
                  ? BoxFit.fitHeight
                  : BoxFit.fitWidth,
              child: Container(
                width: _size.aspectRatio >= ratios[_positionScale]["value"]
                    ? _size.height
                    : _size.width,
                height: _size.aspectRatio >= ratios[_positionScale]["value"]
                    ? _size.height / _controller.value.aspectRatio
                    : _size.width / _controller.value.aspectRatio,
                child: Center(child: CameraPreview(_controller)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Visibility(
            visible: !_isLiveStreaming,
            child: InkWell(
              onTap: () async {
                if (!_isPreparing) {
                  final value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PresetPage(
                              preset: preset,
                            )),
                  );
                  if (value != null) {
                    setState(() {
                      preset = value;
                      _controller = null;
                      onNewCameraSelected(null);
                    });
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                width: 60,
                height: 36,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(18)),
                child: Center(
                  child: Text(numberPreset(preset),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !_isLiveStreaming,
            child: InkWell(
              onTap: () async {
                if (!_isPreparing) {
                  setState(() {
                    if (_positionScale == 3) {
                      _positionScale = 0;
                    } else {
                      _positionScale++;
                    }
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                width: 60,
                height: 36,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(18)),
                child: Center(
                  child: Text("${ratios[_positionScale]["key"]}",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Dio().post(
                        'https://graph.facebook.com/v3.3/104248171719400/live_videos',
                        data: {
                          'access_token':
                              'EAAEppgm4jTEBAMav9yQSc5qvn6sZCZBZAgclvqLwvPtQbVGJDntxOPZBwUlCXONlwZAJ1DgsjIl7jO5DaK1RgoOQdrHYUDxFkPxJ4QwcyNBlqgsYn6ZAuuzNWsxm3lwbZC30TPPypw7R8EtZBFJdlHDd8GTcqZBXZAWQiSQ6rufJjIwQZDZD',
                          'title': 'test',
                          'description': '<description>',
                          'status': 'LIVE_NOW',
                        },
                      ).then((value) async {
                        FacebookLivestream livestream3 =
                            FacebookLivestream.fromJson(jsonDecode(value.data));
                        try {
                          await _controller.startInsertVideoStreaming(
                              [livestream3.secureStreamUrl]);
                          await App.showToast(
                            context: context,
                            message: "Thêm page thành công!",
                            type: AlertDialogType.error,
                          );
                        } catch (e) {
                          App.showToast(
                            context: context,
                            message: e.toString(),
                            type: AlertDialogType.error,
                          );
                        }
                      });
                    }),
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios_outlined,
                      color: Colors.white),
                  onPressed: () {
                    if (!_isPreparing) {
                      onNewCameraSelected(_controller.description == _cameras[0]
                          ? _cameras[1]
                          : _cameras[0]);
                    }
                  },
                ),
                IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      // if (!_isPreparing) {
                      // if (_isLiveStreaming) {
                      confirmCloseLive(context);
                      // } else {
                      //   Navigator.pop(context);
                      // }
                      // }
                    })
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Hiển thì confirm đóng livestream.
  Future confirmCloseLive(BuildContext context) {
    App.showDefaultDialog(
        context: context,
        content: "Bạn có chắc muốn đóng LiveStream này",
        actions: <Widget>[
          ActionButton(
              child: Text("Hủy"),
              color: Colors.grey.shade200,
              textColor: AppColors.brand3,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              }),
          ActionButton(
              child: Text("Đồng ý"),
              color: Colors.grey.shade200,
              textColor: AppColors.brand3,
              onPressed: () async {
                // await stopStream();
                Navigator.pop(context);
              }),
        ]);
  }

  Widget _buildPauseAndPlayLive() {
    return Visibility(
      visible: _isLiveStreaming,
      child: Row(
        children: [
          ClipOval(
            child: Material(
              color: Colors.black87, // button color
              child: InkWell(
                splashColor: Colors.black12, // inkwell color
                child: const SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(Icons.format_list_bulleted,
                        color: Colors.white, size: 20)),
                onTap: () {
                  setState(() {
                    opacityValue = opacityValue == 1 ? 0 : 1;
                  });
                },
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: FlatButton.icon(
              label: const Text('Pause',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              icon: const Icon(Icons.pause, color: Colors.white),
              onPressed: () async {
                await pauseStream();
              },
            ),
          ),
          Visibility(
            visible: _isPause,
            child: FlatButton.icon(
              label: const Text('Play',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              onPressed: () async {
                await resumeStream();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContentLive() {
    return Visibility(
      visible: !_isLiveStreaming,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContentLiveStream(
            title: 'Tiêu đề',
            content: '$_liveTitle',
            onTap: () async {
              if (!_isPreparing) {
                final value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContentTitlePage(
                            isTitle: true,
                            content: _liveTitle,
                          )),
                );
                if (value != null) {
                  setState(() {
                    _liveTitle = value;
                  });
                }
              }
            },
          ),
          SizedBox(
            height: 4,
            child: Container(color: Colors.transparent),
          ),
          ContentLiveStream(
            title: 'Nội dung',
            content: '$_liveContent',
            onTap: () async {
              if (!_isPreparing) {
                final value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContentTitlePage(
                            isTitle: false,
                            content: _liveContent,
                          )),
                );
                if (value != null) {
                  setState(() {
                    _liveContent = value;
                  });
                }
              }
            },
          ),
          SizedBox(
            height: 12,
            child: Container(
              color: Colors.transparent,
            ),
          ),
          ShareLiveStream(
            title: 'Share',
            content: 'Enter title ...',
            onTap: () {},
          ),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: 180,
                      height: 42,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: FlatButton(
                        child: Center(
                            child: _isPreparing
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.grey[300],
                                    ))
                                : const Text('Bắt đầu live')),
                        onPressed: () async {
                          _handleLiveStream();
                        },
                      ))))
        ],
      ),
    );
  }

  Widget _buildUINoConnectInternet() {
    return Visibility(
      visible: !_isConnectNetwork && _isLiveStreaming,
      child: Container(
        color: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )),
            const SizedBox(
              height: 18,
            ),
            Text(
              _notifyInternet,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              width: 170,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(12)),
              child: FlatButton(
                child: const Text(
                  'Kết thúc live',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  stopVideoStreaming().then((value) {
                    setState(() {
                      _isLiveStreaming = false;
                    });
                  });
                },
              ),
            )
          ],
        )),
      ),
    );
  }

  Future<void> startLive() async {
    try {
      await _controller.startVideoStreaming(
        _urls,
        width: (_size.aspectRatio >= ratios[_positionScale]["value"]
                ? _size.height
                : _size.width)
            .toInt(),
        height: (_size.aspectRatio >= ratios[_positionScale]["value"]
                ? _size.height / _controller.value.aspectRatio
                : _size.width / _controller.value.aspectRatio)
            .toInt(),
      );
      setState(() {
        _isLiveStreaming = true;
      });
    } catch (e) {
      App.showToast(
        context: context,
        message: e.toString(),
        type: AlertDialogType.error,
      );
    }
  }

  Future<void> pauseStream() async {
    await _controller.pauseVideoStreaming();
    setState(() {
      _isPause = true;
    });
  }

  Future<void> resumeStream() async {
    await _controller.resumeVideoStreaming();
    setState(() {
      _isPause = false;
    });
  }

  Future<void> stopStream() async {
    try {
      await stopVideoStreaming();
      int countStreamStoped = 0;
      for (int i = 0; i < _facebookLives.length; i++) {
        Dio()
            .post(
                "https://graph.facebook.com/${_facebookLives[i].id}?end_live_video=true&access_token=${widget.tokens[i]}")
            .then((value) {
          countStreamStoped++;
          if (countStreamStoped == _facebookLives.length) {
            setState(() {
              _isLiveStreaming = false;
              onNewCameraSelected(_cameras[0]);
            });
          }
        });
      }
    } catch (e) {}
  }

  Future<void> stopVideoStreaming() async {
    try {
      await _controller.stopVideoStreaming();
    } on CameraException catch (e) {
      // ignore: avoid_returning_null_for_void
      return null;
    }
  }

  void _handleLiveStream() {
    if (_isConnectNetwork) {
      if (!_isPreparing) {
        if (widget.crmTeams != null) {
          // ignore: avoid_function_literals_in_foreach_calls
          setState(() {
            _isPreparing = true;
          });

          // ignore: avoid_function_literals_in_foreach_calls
          widget.crmTeams.forEach((element) {
            Dio().post(
              'https://graph.facebook.com/v3.3/${element.facebookPageId}/live_videos',
              data: {
                'access_token': '${element.facebookPageToken}',
                'title': _liveTitle,
                'description': _liveContent,
                'status': 'LIVE_NOW',
              },
            ).then((value) {
              final FacebookLivestream livestream =
                  FacebookLivestream.fromJson(jsonDecode(value.data));
              _urls.add(livestream.secureStreamUrl);
              _facebookLives.add(livestream);
              if (_urls.length == widget.crmTeams.length) {
                _isPreparing = false;
                startLive();
              }
            }).catchError((element) {
              App.showToast(
                  context: context,
                  message: element.toString(),
                  type: AlertDialogType.error);
            });
          });
        }
      }
    } else {
      App.showToast(
        context: context,
        message: _notifyInternet,
        type: AlertDialogType.error,
      );
    }
  }

  /// Hiển thị danh sách các page đang livestream
  void showPageLiving(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 48,
                        height: 32,
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(24)),
                        child: const Text("Trang đang live",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16))),
                  ),
                  ...widget.crmTeams
                      .map((e) => LivingPage(
                            crmTeam: e,
                          ))
                      .toList(),
                ],
              ));
        });
  }
}

class ContentLiveStream extends StatelessWidget {
  const ContentLiveStream({this.title, this.content, this.onTap});

  final VoidCallback onTap;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: ListTile(
          onTap: onTap,
          title: Row(
            children: [
              Text(
                title ?? "",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(content == '' ? '...' : content,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 13)),
                ),
              )
            ],
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
          )),
    );
  }
}

class ShareLiveStream extends StatelessWidget {
  const ShareLiveStream({this.title, this.content, this.onTap});

  final VoidCallback onTap;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: ListTile(
        onTap: onTap,
        title: Row(
          children: [
            Text(
              title ?? '',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: IconButton(
                          icon: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white10,
                                  shape: BoxShape.circle),
                              width: 32,
                              height: 32,
                              child: const Icon(FontAwesomeIcons.facebookF,
                                  color: Colors.white, size: 18)),
                          onPressed: () {}),
                    ),
                    IconButton(
                        icon: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white10, shape: BoxShape.circle),
                            width: 32,
                            height: 32,
                            child: const Icon(
                              FontAwesomeIcons.youtube,
                              color: Colors.white,
                              size: 16,
                            )),
                        onPressed: () {})
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UIEventLive extends StatelessWidget {
  const UIEventLive({this.title, this.onTap, this.icon});

  final String title;
  final GestureTapCallback onTap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 4),
        height: 48,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 8),
            Expanded(
                child: Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 14))),
          ],
        ),
      ),
    );
  }
}
