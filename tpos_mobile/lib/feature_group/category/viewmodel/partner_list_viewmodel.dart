import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';
import 'package:tmt_flutter_viewmodel/tmt_flutter_viewmodel.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/services/cache_service/cache_service.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PartnerListViewModel extends ProviderVM {
  PartnerListViewModel() {
    // Lắng nghe yêu cầu tìm kiếm
    _searchSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen((keyword) {
      if (_keyword != keyword) {
        _keyword = keyword;
        _onSearch();
      }
    });
  }

  final Logger _logger = Logger();
  final NewDialogService _dialog = GetIt.I<NewDialogService>();
  final PartnerApi _partnerApi = GetIt.I<PartnerApi>();
  final CommonApi _commonApi = GetIt.I<CommonApi>();
  final TagPartnerApi _tagPartnerApi = GetIt.I<TagPartnerApi>();
  final CacheService _cacheService = GetIt.I<CacheService>();

  /// Param Có là khách hàng hay không
  /// true: Là nhà cung cấp, false: là khách hàng, null: cả 2
  bool isSupplier;

  /// Param: Xác định chế độ là tìm kiếm hoặc danh sách
  bool isSelectMode = false;

  int _skip = 0;
  String tagIds = "";

  /// Số kết quả trên server
  int count = 0;

  /// Danh sách đối tác
  List<Partner> _partners = <Partner>[];

  List<Partner> get partners => _partners;

  /// Có đang load thêm dữ liệu hay không?
  bool _isLoadingMore = false;

  /// Từ khóa tìm kiếm
  String _keyword;

  String _filterDescription;

  void exitSearchMode(bool value) {
    _isSearchEnable = value;
    keyword = '';
    notifyListeners();
  }

  bool _isSearchEnable = false;

  bool get isSearchEnable => _isSearchEnable;
  set isSearchEnable(bool value) {
    _isSearchEnable = value;
    notifyListeners();
  }

  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>();

  /// Danh sach Tag của khách hàng
  List<Tag> tagPartners = [];

  /// Danh sach Tag
  List<Tag> _tags;
  List<Tag> get tags => _tags;
  set tags(List<Tag> value) {
    _tags = value;
    notifyListeners();
  }

  /// Tag
  final List<Tag> _tagFilters = <Tag>[];
  List<Tag> get tagFilters => _tagFilters;
  set addTagFilters(Tag value) {
    final bool isExist =
        _tagFilters.any((element) => element.name == value.name);
    if (!isExist) {
      _tagFilters.add(value);
      notifyListeners();
    }
  }

  /// Số kết quả đã tải về
  int get listCount => _partners?.length ?? 0;
  int get viewListCount => _partners?.length ?? 0;

  /// Sink tìm kiếm
  Sink<String> get searchSink => _searchSubject.sink;

  /// Có đang load thêm dữ liệu hay không?
  bool get isLoadingMore => _isLoadingMore;

  /// Có thể tải thêm dữ liệu hay không
  bool get canLoadMore => _skip < count;

  bool isFilterByKeyword = false;
  bool _isFilterByCategory = false;
  bool _isFilterByPartnerStatus = false;
  bool _isFilterByTag = false;

  /// Dùng để lưu tạm các biến filter . Khi thực hiện xác nhận mới cập nhật
  bool _isFilterByCategoryCache = false;
  bool _isFilterByPartnerStatusCache = false;
  bool _isFilterByTagCache = false;

  /// Filter by keyword
  String get keyword => _keyword;

  /// Filter by danh mục đối tác
  PartnerCategory _partnerCategory;

  /// Filter by trạn thái khách hàng
  PartnerStatusReportItem _partnerStatusReportItem;

  List<PartnerStatus> _partnerStatusList;
  PartnerStatusReport _partnerStatusReport;

  bool get isFilterByCategory => _isFilterByCategory;
  bool get isFilterByPartnerStatus => _isFilterByPartnerStatus;
  bool get isFilterByTag => _isFilterByTag;
  bool get isFilterByCategoryTemp => _isFilterByCategoryCache;
  bool get isFilterByPartnerStatusTemp => _isFilterByPartnerStatusCache;
  bool get isFilterByTagTemp => _isFilterByTagCache;

  PartnerCategory get partnerCategory => _partnerCategory;
  List<PartnerStatusReportItem> get partnerStatusReportItems =>
      _partnerStatusReport?.item;

  PartnerStatusReportItem get partnerStatusReportItem =>
      _partnerStatusReportItem;

  set keyword(String value) {
    _searchSubject.sink.add(value);
  }

  int filterCount = 0;

  int get filterCountCache {
    var count = 0;
    if (_isFilterByCategoryCache) count += 1;
    if (_isFilterByPartnerStatusCache) count += 1;
    if (_isFilterByTagCache) count += 1;

    return count;
  }

  set isFilterByCategory(bool value) {
    _isFilterByCategory = value;
    notifyListeners();
  }

  set isFilterByCategoryTemp(bool value) {
    _isFilterByCategoryCache = value;
    notifyListeners();
  }

  set isFilterByPartnerStatusTemp(bool value) {
    _isFilterByPartnerStatusCache = value;
    notifyListeners();
  }

  set isFilterByTagTemp(bool value) {
    _isFilterByTagCache = value;
    notifyListeners();
  }

  set isFilterByPartnerStatus(bool value) {
    _isFilterByPartnerStatus = value;
    notifyListeners();
  }

  set isFilterByTag(bool value) {
    _isFilterByTag = value;
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

  OldOdataFilter _getFilter() {
    final _keywordNoSign = _keyword != null
        ? StringUtils.removeVietnameseMark(_keyword?.toLowerCase())
        : null;
    final filter = OldOdataFilter(logic: "and", filters: [
      if (isSupplier != null)
        OldOdataFilterItem(
            field: "Customer", operator: "eq", value: !isSupplier),
      if (_isFilterByCategory)
        OldOdataFilterItem(
          field: "PartnerCategoryId",
          operator: "eq",
          value: _partnerCategory?.id,
        ),
      if (_isFilterByPartnerStatus)
        OldOdataFilterItem(
          field: "StatusText",
          operator: "eq",
          value: _partnerStatusReportItem?.statusText,
        ),
      if (_keyword.isNotNullOrEmpty())
        OldOdataFilter(logic: "or", filters: [
          OldOdataFilterItem(
            field: "NameNoSign",
            operator: "contains",
            value: _keywordNoSign,
          ),
          OldOdataFilterItem(
            field: "Phone",
            operator: "contains",
            value: _keywordNoSign,
          ),
          OldOdataFilterItem(
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
    _isFilterByTag = false;

    _isFilterByCategoryCache = false;
    _isFilterByPartnerStatus = false;
    _isFilterByTag = false;

    initData();
  }

  void undoFilter() {
    _isFilterByCategoryCache = _isFilterByCategory;
    _isFilterByPartnerStatusCache = _isFilterByPartnerStatus;
    _isFilterByTagCache = _isFilterByTag;
    notifyListeners();
  }

  Future<void> _fetchPartner() async {
    final String tagIds = tagFilters.map((e) => e.id).join(',');
    count = 0;
    final odataResult = await _partnerApi.getView(
      GetViewPartnerQuery(
          format: 'json',
          top: 100,
          skip: _skip,
          count: true,
          filter: _getFilter().toUrlEncode(),
          orderBy: 'LastUpdated desc',
          tagIds: isFilterByTag ? tagIds : null),
    );

    if (_lastKeyword == _keyword) {
      if (_skip > 0) {
        _partners ??= <Partner>[];
        _partners?.addAll(odataResult.value);
        _skip += odataResult.value.length;
      } else {
        count = odataResult.count;
        _partners = odataResult.value;
        _skip = odataResult.value.length;
      }
    }
  }

  Future<void> assignTag(int partnerId) async {
    setBusy(true);
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
      _dialog.showError(content: e.toString());
    }
    setBusy(false);
  }

  /// get Tag
  Future<void> _getTags() async {
    final result = await _tagPartnerApi.getTagsByType('partner');
    if (result != null) {
      tags = result.value;
    }
  }

  /// Xóa khách hàng
  Future<bool> deletePartner({int id, int index}) async {
    bool result;
    setBusy(true);
    try {
      await _partnerApi.delete(id);
      final partner = _partners.removeAt(index);
      _partners.remove(partner);
      _dialog.showToast(message: '${S.current.partner_deletedCustomer} $id');
    } catch (e, s) {
      _logger.e("", e, s);
      _dialog.showError(content: e.toString());
    }
    setBusy(false);
    return result;
  }

  /// Khởi tạo dữ liệu. GỌi hàm này bất cứ khi nào muốn khởi tạo dữ liệu ban đầu
  /// Thông thường là đặt trong hàm initState của Statefull widget.
  Future<PCommandResult> initData() async {
    _logger.d("init data");
    setLoading("Đang tải dữ liệu...");
    _skip = 0;
    try {
      await _cacheService.refreshPartnerStatus();
      await _getTags();
      await _fetchData();
      notifyListeners();
      setLoadSuccess();
    } catch (e, s) {
      _logger.e("", e, s);
      _dialog.showError(content: e.toString());
      setLoadFailure(
        e.toString(),
      );
    }

    return PCommandResult(true);
  }

  /// Cập nhật danh sách trạng thái khách hàng + màu trạng thái

  String _lastKeyword;

  /// Tìm kiếm
  Future<void> _onSearch() async {
    _lastKeyword = _keyword;
    isSearching = true;
    _skip = 0;
    notifyListeners();
    try {
      await _fetchData();
      notifyListeners();
    } catch (e, s) {
      _logger.e("", e, s);
      _dialog.showToast(message: e.toString(), type: AlertDialogType.warning);
    }

    isSearching = false;
    notifyListeners();
  }

  /// Áp dụng các điều kiện lọc và tải lại dữ liệu
  Future<void> applyFilter() async {
    setBusy(true, "Vui lòng đợi...");
    _skip = 0; //
    _isFilterByCategory = isFilterByCategoryTemp; // rest skip
    _isFilterByTag = isFilterByTagTemp;
    _isFilterByPartnerStatus = isFilterByPartnerStatusTemp;
    notifyListeners();
    try {
      await _fetchData();
      notifyListeners();
    } catch (e, s) {
      _logger.e('', e, s);
      _dialog.showError(content: e.toString());
    }
    setBusy(false);
  }

  Future<void> refreshData() async {
    setLoading();
    try {
      await _fetchData();
      setLoadSuccess();
    } catch (e, s) {
      _logger.e('', e, s);
      _dialog.showError(content: e.toString());
      setLoadFailure();
    }
    notifyListeners();
  }

  Future<void> _fetchData() async {
    await _fetchPartner();
    await _fetchStatusReport();
    _summaryFilterInfo();
  }

  /// Xác định khi nào thì không có kết quả tìm kiếm nào được tìm thấy
  bool get isNotFound =>
      state is VmLoadSuccess &&
      _partners?.isEmpty == true &&
      (_keyword.isNotNullOrEmpty() || filterCount > 0);

  /// Xác định khi nào thì danh sách trống. chưa có phần tử nào
  bool get isEmpty =>
      state is VmLoadSuccess &&
      _partners?.isEmpty == true &&
      _keyword.isNullOrEmpty() &&
      filterCount == 0;

  /// Mô tả điều kiện lọc
  String get filterDescription {
    return _filterDescription;
  }

  Future<void> loadMorePartner() async {
    _isLoadingMore = true;
    notifyListeners();
    if (!canLoadMore) {
      // Đã tới cuối danh sách
      _dialog.showToast(
          message: S.current.partner_OutOfCustomers,
          type: AlertDialogType.info);
      return;
    }
    try {
      await _fetchData();
    } catch (e, s) {
      _logger.e("", e, s);
      _dialog.showError(content: e.toString());
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> _fetchStatusReport() async {
    _partnerStatusReport = await _commonApi.getPartnerStatusReport();
  }

  void _summaryFilterInfo() {
    filterCount = 0;

    String value = S.current.pageState_noResultFoundTitle;
    if (_keyword.isNotNullOrEmpty()) {
      value += '\n- ${S.current.pageState_filterByKeyword(_keyword)}';
    }

    if (_isFilterByCategory) {
      value +=
          '\n- ${S.current.pageState_filterByGroup(_partnerCategory?.name ?? 'Chưa chọn nhóm')}';
      filterCount += 1;
    }

    if (_isFilterByPartnerStatus) {
      value +=
          '\n- ${S.current.pageState_filterByStatus(_partnerStatusList?.first?.text)}';
      filterCount += 1;
      if (_partnerStatusList.lengthOrDefault() > 1) {
        value += ' và ${_partnerStatusList.length} trạng thái khác';
      }
    }

    if (_isFilterByTag && _tagFilters.lengthOrDefault() > 0) {
      value +=
          '\n- ${S.current.pageState_filterByTags(_tagFilters?.first?.name)}';
      filterCount += 1;
      if (_tagFilters.lengthOrDefault() > 1) {
        value += ' và ${_tagFilters.length} nhãn khác';
      }
    }

    _filterDescription = value;
    notifyListeners();
  }

  @override
  void init([bool initData = false]) {}
}
