import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';

class PartnerListViewModel extends ViewModel {
  final Logger _logger = new Logger();
  final DialogService _dialog = locator<DialogService>();
  final PartnerApi _partnerApi = GetIt.I<PartnerApi>();
  final CommonApi _commonApi = GetIt.I<CommonApi>();
  final TagPartnerApi _tagPartnerApi = GetIt.I<TagPartnerApi>();

  /// Param Có là khách hàng hay không
  /// true: Là nhà cung cấp, false: là khách hàng, null: cả 2
  bool isSupplier;

  /// Param: Xác định chế độ là tìm kiếm hoặc danh sách
  bool isSearchMode = false;

  /// Nhận param và khởi tạo dữ liệu
  void init({bool isSupplier, bool isSearchModel = false}) {
    this.isSupplier = isSupplier;
    this.isSearchMode = isSearchModel;
    initData();
  }

  PartnerListViewModel() {
    // Lắng nghe yêu cầu tìm kiếm
    _searchSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen((keyword) {
      if (_keyword != keyword) {
        _keyword = keyword;
        _searchData();
      }
    });
  }

  final int _take = 500;

  /// Số kết quả trên server
  int count = 0;

  /// Danh sách đối tác
  List<Partner> _partners = new List<Partner>();

  /// Danh sách đối tác sau khi tìm kiếm local, lọc local
  List<Partner> _viewPartners;

  /// Có đang load thêm dữ liệu hay không?
  bool _isLoadingMore = false;

  /// Từ khóa tìm kiếm
  String _keyword;

  /// Quá trình tìm kiếm có đang diễn ra hay không
  bool _isSearching = false;

  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>();

  /// Danh sach Tag của khách hàng
  List<Tag> tagPartners = [];

  /// Danh sach Tag
  List<Tag> _tags;
  List<Tag> get tags => _tags;
  set tags(List<Tag> value) {
    _tags = value;
  }

  /// Số kết quả đã tải về

  List<Partner> get viewPartners => _viewPartners;
  int get listCount => _partners?.length ?? 0;
  int get viewListCount => _viewPartners?.length ?? 0;

  /// Quá trình tìm kiếm có đang diễn ra hay không
  bool get isSearching => _isSearching;

  /// Sink tìm kiếm
  Sink<String> get searchSink => _searchSubject.sink;

  /// Có đang load thêm dữ liệu hay không?
  bool get isLoadingMore => _isLoadingMore;

  /// Có thể tải thêm dữ liệu hay không
  bool get canLoadMore => listCount < count;

  bool isFilterByKeyword = false;
  bool _isFilterByCategory = false;
  bool _isFilterByPartnerStatus = false;

  /// Filter by keyword
  String keyword;

  /// Filter by danh mục đối tác
  PartnerCategory _partnerCategory;

  /// Filter by trạn thái khách hàng
  PartnerStatusReportItem _partnerStatusReportItem;

  List<PartnerStatus> _partnerStatusList;
  PartnerStatusReport _partnerStatusReport;

  bool get isFilterByCategory => _isFilterByCategory;
  bool get isFilterByPartnerStatus => _isFilterByPartnerStatus;

  PartnerCategory get partnerCategory => _partnerCategory;
  List<PartnerStatusReportItem> get partnerStatusReportItems =>
      _partnerStatusReport.item;

  PartnerStatusReportItem get partnerStatusReportItem =>
      _partnerStatusReportItem;

  int get filterCount {
    var count = 0;
    if (isFilterByKeyword) count += 1;
    if (isFilterByCategory) count += 1;
    if (isFilterByPartnerStatus) count += 1;
    return count;
  }

  set isFilterByCategory(bool value) {
    _isFilterByCategory = value;
    notifyListeners();
  }

  set isFilterByPartnerStatus(bool value) {
    _isFilterByPartnerStatus = value;
    notifyListeners();
  }

  set partnerCategory(PartnerCategory value) {
    _partnerCategory = value;
    notifyListeners();
  }

  set partnerStatusReportItem(PartnerStatusReportItem value) {
    _partnerStatusReportItem = value;
    notifyListeners();
  }

  OdataFilter _getFilter() {
    var _keywordNoSign = _keyword != null
        ? StringUtils.removeVietnameseMark(_keyword?.toLowerCase())
        : null;
    var filter = OdataFilter(logic: ("and"), filters: [
      if (isSupplier != null)
        OdataFilterItem(field: "Customer", operator: "eq", value: !isSupplier),
      if (_isFilterByCategory)
        OdataFilterItem(
          field: "PartnerCategoryId",
          operator: "eq",
          value: _partnerCategory?.id,
        ),
      if (_isFilterByPartnerStatus)
        OdataFilterItem(
          field: "StatusText",
          operator: "eq",
          value: _partnerStatusReportItem?.statusText,
        ),
      if (_keyword.isNotNullOrEmpty())
        OdataFilter(logic: "or", filters: [
          OdataFilterItem(
            field: "NameNoSign",
            operator: "contains",
            value: _keywordNoSign,
          ),
          OdataFilterItem(
            field: "Phone",
            operator: "contains",
            value: _keywordNoSign,
          ),
          OdataFilterItem(
            field: "Ref",
            operator: "contains",
            value: _keywordNoSign,
          ),
        ]),
    ]);

    if (filter.filters != null && filter.filters.isNotEmpty) return filter;
    return null;
  }

  void resetFilter() {
    _isFilterByCategory = false;
    _isFilterByPartnerStatus = false;
    notifyListeners();
  }

  Future<void> _fetchPartner() async {
    _partners.clear();
    count = 0;
    final odataResult = await _partnerApi.getView(GetViewPartnerQuery(
        format: 'json',
        top: 100,
        count: true,
        filter: '(Customer eq true and Active eq true)'));
    if (_lastKeyword == _keyword) {
      count = odataResult.count;
      _partners = odataResult.value;
      _viewPartners = _partners;
    }
  }

  Future<void> assignTag(int partnerId) async {
    onStateAdd(true);
    try {
      final AssignTagPartnerModel result = await _tagPartnerApi.assignTag(
        AssignTagPartnerModel(
          partnerId: partnerId,
          tags: tagPartners,
        ),
      );
      if (result != null) {
        tagPartners.clear();
        await initData();
      }
    } catch (e, s) {
      _logger.e("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
  }

  /// get Tag
  Future<void> getTags() async {
    try {
      final result = await _tagPartnerApi.getTagsByType('partner');
      if (result != null) {
        tags = result.value;
      }
    } catch (e, s) {
      _logger.e("", e, s);
      _dialog.showError(error: e);
    }
  }

  /// Xóa khách hàng
  Future<bool> deletePartner({int id, int index}) async {
    bool result;
    try {
      await _partnerApi.delete(id);
      _viewPartners.removeAt(index);
    } catch (e, s) {
      _logger.e("", e, s);
      _dialog.showError(error: e);
    }
    return result;
  }

  /// Khởi tạo dữ liệu
  Future<void> initData() async {
    _logger.d("init data");
    onStateAdd(true);
    try {
      await getTags();
      await _fetchPartner();
      await _fetchStatusReport();
      isInit = true;
      notifyListeners();
    } catch (e, s) {
      _logger.e("", e, s);
      _dialog.showError(error: e);
    }
    onStateAdd(false);
  }

  String _lastKeyword;

  /// Tìm kiếm
  Future<void> _searchData() async {
    _lastKeyword = _keyword;
    try {
      this._isSearching = true;
      notifyListeners();
      await _fetchPartner();
      await _fetchStatusReport();
      notifyListeners();
    } catch (e, s) {
      _logger.e("", e, s);
    }

    this._isSearching = false;
    notifyListeners();
  }

  Future<void> loadMorePartner() async {
    _isLoadingMore = true;
    notifyListeners();
    if (!this.canLoadMore) {
      _dialog.showNotify(
          message: "Đã tới cuối danh sách", type: DialogType.NOTIFY);
      return;
    }
    try {
      // var result = await _partnerApi.getView(
      //   top: _take,
      //   skip: this.listCount,
      //   filter: _getFilter(),
      // );

      final result = await _partnerApi.getView(
        GetViewPartnerQuery(
          top: _take,
          skip: listCount,
          filter: _getFilter().toUrlEncode(),
        ),
      );

      _partners.addAll(result.value);
    } catch (e, s) {
      _logger.e("", e, s);
      _dialog.showError(error: e);
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> _fetchStatusReport() async {
    _partnerStatusReport = await _commonApi.getPartnerStatusReport();
  }
}
