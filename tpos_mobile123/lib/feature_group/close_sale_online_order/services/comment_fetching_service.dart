import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_data.dart';

import 'package:tpos_mobile/feature_group/sale_online/services/service.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';

import 'package:w3c_event_source/event_source.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';

typedef CommentFetchingCallback = dynamic Function(CommentData);

/// Truyền vào các tham số để khởi tạo quá trình lấy comment cần thiết và trả lại các comment thông qua callback
/// Các comment được quảng bá thông qua kênh commentStream và các comment được phát ra sẽ không bao giờ trùng nhau
abstract class CommentFetchingService {
  /// Một luồng của comment
  Stream<FacebookComment> get commentStream;
  LiveStatus get liveStatus;
  bool get isLive;
}

/// Dịch vụ này truyền vào các tham số cần thiết để có thể lấy được comment của một bài đăng.
/// Nếu trạng thái video là đang Live. ĐỊnh kỳ sau một khoảng thời gian được thiết lập sẽ làm mới lại để kiểm tra tình trạng của video.
/// Nếu đang live thì comment sẽ được tải về liên tục để phục vụ cho việc livestream
///
class FacebookCommentFetchingService implements CommentFetchingService {
  FacebookCommentFetchingService(
      {IFacebookApiService facebookApiService,
      ISettingService settingService}) {
    _setting = settingService ?? locator<ISettingService>();
    _facebookApiService = facebookApiService ?? locator<IFacebookApiService>();
    _init();
  }

  /// Facebook Api Service instance
  IFacebookApiService _facebookApiService;
  ISettingService _setting;

  /// Logger service
  final Logger _logger = Logger();

  /// Add and broatcast comment to listener
  final PublishSubject<FacebookComment> _commentSubject =
      PublishSubject<FacebookComment>();

  static const int _FETCH_LIMIT = 200;

  /// Whether the [setup] is call or not.
  bool _isInit = false;

  CRMTeam _crmTeam;
  LiveStatus _liveStatus;
  FacebookPost _facebookPost;
  bool _isFetchingComment = false;

  /// private get or set [facebookComment] Store and cache
  //List<FacebookComment> _comments = <FacebookComment>[];

  /// Dùng để xác định xem comment có tồn tại hay chưa
  Map<String, FacebookComment> _commentMaps = <String, FacebookComment>{};

  FacebookComment _lastComment;

  EventSource _eventSource;
  StreamSubscription _eventSourceSubscription;

  // *********Public*************///
  /// get video live status
  LiveStatus get liveStatus => _liveStatus;
  bool get isLive => _liveStatus == LiveStatus.LIVE;

  /// get whether the comment is being fetch.
  bool get isFetchingComment => _isFetchingComment;

  // ******** SETTING **********///
  /// Private set or gets whether enable fetch comment by eventsource or not
  bool _enableEventSource = false;

  /// private set or gets whether enable fetch comment by api or not
  bool _enableFetchByApi = false;

  /// Time delay bettwen two request on page
  int get _delayTimeWhenFetchCommentByApi => _setting.secondRefreshComment;

  /// Comment filter rate
  CommentRate get _reatimeCommentFilter =>
      _setting.saleOnlineFetchCommentOnRealtimeRate;

  /// call after [FacebookCommentFetchingService] contructor
  void _init() {
    _isInit = true;
  }

  /// Call when UI Need to parse parameter to Service.
  /// Must be call atleat one time.
  void setParameter({
    @required FacebookPost facebookPost,
    @required CRMTeam crmTeam,
  }) {
    assert(facebookPost.id != null && facebookPost.id.isNotEmpty);
    assert(facebookPost.idForEventSource != null &&
        facebookPost.idForEventSource.isNotEmpty);

    assert(facebookPost.type != null);
    _facebookPost = facebookPost;
    _crmTeam = crmTeam;

    _logger.i('setParameter (facebookPost: $facebookPost, crmTeam $crmTeam)');
  }

  /// setup the fetching service
  void setup() {
    if (!_isInit) {
      throw Exception('The init function must be call first');
    }
  }

  /// Action Command Refresh
  /// Clear all saved comment and reset
  void handleRefresh() async {
    // Cancel all service and subcible

    assert(_facebookPost != null);
    assert(_facebookPost.type != null);
    assert(_crmTeam != null);

    _eventSourceSubscription?.cancel();
    _eventSource?.close();

    //_comments?.clear();
    _commentMaps?.clear();
    _liveStatus = null;
    _isFetchingComment = false;
    try {
      _logger.i('handleRefresh start');
      if (_facebookPost.type == 'video') {
        await checkLiveStatus();
      }
      await _fetchAllComment();
      if (_facebookPost.type == 'video' && _liveStatus == LiveStatus.LIVE) {
        _startFetchComment();
      }
      _logger.i('handleRefresh completed');
    } catch (e, s) {
      //_comments.clear();
      _commentMaps.clear();
      _liveStatus = null;
      _logger.e('handleRefresh Error', e, s);
    }

    // run schedule
    _scheduleCheckLiveStatus();
  }

  /// Xử lý kết nối lại sau khi rớt mạng hoặc gặp sự cố với việc lấy comment qua event source
  void _handleReconnect() async {
    assert(_facebookPost.type == 'video',
        'Eventsource only reconnect when post type is video');
    assert(_crmTeam.facebookTypeId == "User",
        'Event source only reconnect when [crmTeam.facebookTypeId] is User');
    assert(_liveStatus == LiveStatus.LIVE,
        'reconnect only when liveStatus is [Live]');
    _startFetchCommentByEventSource();
  }

  /// Check status of live video
  /// Only video can check
  @visibleForTesting
  Future<void> checkLiveStatus() async {
    assert(_isInit);
    assert(_crmTeam != null);
    assert(_facebookPost != null);
    assert(_crmTeam.userOrPageToken != null &&
        _crmTeam.userOrPageToken.isNotEmpty);
    assert(_facebookPost.type == "video");
    if (_facebookPost.type != FacebookPostType.video.describle()) {
      _liveStatus = null;
    }

    try {
      final LiveVideo liveVideo = await _facebookApiService.getLiveVideo(
          accessToken: _crmTeam.userOrPageToken,
          liveVideoId: _facebookPost.idForEventSource);

      _liveStatus = liveVideo.liveStatus.toEnum<LiveStatus>(LiveStatus.values);
      _logger.i('checkLiveStatus => $_liveStatus');
    } catch (e, s) {
      _logger.e('checkLiveStatus', e, s);
    }
  }

  /// Bắt đầu tải comment trong thời gian thực
  /// Hàm này chỉ được gọi khi trạng thái của [_liveStatus] là LiveStatus.LIVE

  /// Nếu CrmTeam.TypeId == Page chỉ cần dùng Api
  /// Nếu CrmTeam.TypeId == Personal thì kết hợp api + event source
  void _startFetchComment() async {
    assert(_liveStatus == LiveStatus.LIVE);
    if (_facebookPost.type == "video" && _liveStatus == LiveStatus.VOD) {
      if (_crmTeam.facebookTypeId == "Page") {
        _fetchCommentOnRealtimeByApi();
      } else if (_crmTeam.facebookTypeId == "User") {
        _fetchCommentOnRealtimeByApi();
        _startFetchCommentByEventSource();
      }
    }
  }

  /// fetch comment on realtime by api using since
  Future<void> _fetchCommentOnRealtimeByApi() async {
    assert(_facebookPost != null);
    assert(_crmTeam != null);
    assert(_crmTeam.userOrPageToken != null);
    assert(_facebookPost.type == 'video');

    while (_liveStatus == LiveStatus.LIVE && _enableFetchByApi) {
//      final FacebookComment lastComment =
//          _comments.where((element) => element.fetchByRealtime == false).last;

      final FacebookComment lastComment = _lastComment;
      try {
        final List<FacebookComment> results =
            await _facebookApiService.fetchTopComment(
                top: _FETCH_LIMIT,
                postId: _facebookPost.id,
                accessToken: _crmTeam.userOrPageToken,
                lastTime: lastComment.createdTime);

        _addCommentToStream(results);
      } catch (e, s) {
        _logger.e('', e, s);
      }

      await _delayWhenFetchCommentByApi();
    }
  }

  /// Fetch all comment. This function only call one time after refresh the page
  @visibleForTesting
  Future<void> _fetchAllComment() async {
    _logger.i('fetchAllComment');
    FacebookListPaging _paging;
    Future<void> fetchCommentByPaging() async {
      try {
        final fetchResult = await _facebookApiService.fetchCommentWithPaging(
            postId: _facebookPost?.id,
            accessToken: _crmTeam.userOrPageToken,
            isNewestOnTop: false,
            limit: _FETCH_LIMIT);
        _paging = fetchResult.paging;
        // _comments.addAll(fetchResult.data);
        _commentMaps.addEntries(fetchResult.data.map((e) => MapEntry(e.id, e)));
        for (var comment in fetchResult.data) {
          _commentSubject.add(comment);
        }

        _logger.i(
            '_fetchCommentByPaging Success with ${_commentMaps.length} item');
      } catch (e, s) {
        _logger.e('_fetchCommentByPaging', e, s);
      }
    }

    Future<void> fetchMoreCommentWithPaging() async {
      _logger.i('fetch more comment');
      try {
        final fetchResult =
            await _facebookApiService.fetchMoreCommentWithPaging(
          _paging,
          _crmTeam.userOrPageToken,
          limit: _FETCH_LIMIT,
        );
        _paging = fetchResult.paging;
        //_comments.addAll(fetchResult.data);
        _commentMaps.addEntries(fetchResult.data.map((e) => MapEntry(e.id, e)));
        for (var comment in fetchResult.data) {
          _commentSubject.add(comment);
        }

        _logger.i('fetch more comment success with ${fetchResult.data} items');
      } catch (e, s) {
        _logger.e('fetchMoreCommentErorr', e, s);
      }
    }

    await fetchCommentByPaging();

    while (_paging != null && _paging.next != null) {
      await fetchMoreCommentWithPaging();
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  Stream<FacebookComment> get commentStream => _commentSubject.stream;

  /// Hàm nội bộ thực hiện thêm một bình luận vào stream. Nó sẽ kiểm tra xem comment đó đã được thêm vào stream trước đó hay chưa.
  ///
  /// Nếu chưa thì sẽ thêm vào stream
  /// Nếu có thì sẽ bỏ qua
  void _addCommentToStream(List<FacebookComment> comments) {
    for (FacebookComment comment in comments) {
      if (!_checkCommentExists(comment)) {
        //_comments.add(comment);
        _commentMaps[comment.id] = comment;
        _commentSubject.add(comment);
        _logger.i('addCommentToStream (${comment.id})');
      }
    }
  }

  /// Kiểm tra xem comment đã được đẩy qua stream hay chưa
  ///
  /// Nếu đã tồn tại trả về [true]
  /// Nếu chưa thì trả về [false]
  bool _checkCommentExists(FacebookComment comment) {
    // if (_comments.any((element) => element.id == comment.id)) {
    if (_commentMaps.containsKey(comment.id)) {
      _logger.i('checkCommentExists with result true');
      return true;
    }
    _logger.i('checkCommentExists with result false');
    return false;
  }

  /// Delay a Duration time for re fecth comment
  ///     // Chờ 1 thời gian và lặp lại. Khác nhau tùy thuộc vào loại source phát.
  //      // Nếu là page thì theo setting mặc định
  //      // Nếu là cá nhân thì dãn cách tùy vào tần suất nhận comment
  Future<void> _delayWhenFetchCommentByApi() async {
    if (_crmTeam.facebookTypeId == 'Page') {
      _logger.i('DelayDuration $_delayTimeWhenFetchCommentByApi');
      await Future.delayed(
        Duration(seconds: _delayTimeWhenFetchCommentByApi),
      );
    }
  }

  /// Dừng việc lắng nghe eventsource hiện tại và khởi tạo lại kết nối mới.
  ///
  /// Chú ý: Hàm này chỉ được gọi khi trạng thái video là [LiveStatus.LIVE]
  Future<void> _startFetchCommentByEventSource() {
    assert(_liveStatus == LiveStatus.LIVE);
    _cancelEventSource();

    final uri = Uri.parse(
        'https://streaming-graph.facebook.com/${_facebookPost.idForEventSource}/live_comments?live_filter=no_filter&comment_rate=${_reatimeCommentFilter.describe}&fields=id,is_hidden,message,from{id,name,picture},created_time&access_token=${_crmTeam.userOrPageToken}');
    _eventSource = EventSource(uri);

    _eventSourceSubscription = _eventSource.events.listen(
      (MessageEvent message) {
        //get comment and add to stream
        try {
          var comment = FacebookComment.fromMap(jsonDecode(message.data));
          _addCommentToStream([comment]);
        } catch (e, s) {
          _logger.e('Convert comment to Object fail from event source', e, s);
        }
      },
    );
  }

  /// Hàm nội bộ thực hiện kiểm tra trạng thái video sau một khoảng thời gian được định sẵn cố định mặc định là 20 giây.
  ///
  /// Hàm này còn thực hiện kết nối lại event source nếu như event source đã bị mất kết nối
  ///
  /// Chú ý: Chỉ được gọi hàm này nếu như trạng thái video đã được xác định một lần trước đó và vẫn đang ở trạng thái [LiveStatus.LIVE]
  Future<void> _scheduleCheckLiveStatus() async {
    assert(_liveStatus == LiveStatus.LIVE);
    while (_liveStatus == LiveStatus.LIVE) {
      await checkLiveStatus();
      _isFetchingComment = _liveStatus == LiveStatus.LIVE;

      if (_facebookPost.type == 'video' &&
          _crmTeam.facebookTypeId == "User" &&
          _liveStatus == LiveStatus.LIVE) {
        if (_eventSource.readyState == EventSource.CLOSED) {
          _handleReconnect();
        }
      }
      await Future.delayed(
        Duration(seconds: 20),
      );
    }
  }

  void _cancelEventSource() {
    _eventSourceSubscription?.cancel();
    _eventSource?.close();
  }

  /// Must call dispose
  void dispose() {
    _commentSubject.close();
    _eventSource.close();
    _logger.i('CommentFetchingService disposed');
  }
}
