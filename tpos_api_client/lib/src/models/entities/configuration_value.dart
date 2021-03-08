import 'dart:convert';

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}

class ConfigurationValue {
  ConfigurationValue(
      {this.shopUrl,
      this.luckyWheelIsPriority,
      this.luckyWheelPriorityIgnoreWinner,
      this.luckyWheelPriorityPersonalSharers,
      this.luckyWheelHasOrder,
      this.luckyWheelIgnoreWinnerPlayer,
      this.luckyWheelPriorityGroupSharers,
      this.luckyWheelHasShare,
      this.luckyWheelPrioritySharers,
      this.luckyWheelPriorityCommentPlayers,
      this.luckyWheelHasComment,
      this.dateTimeFormat,
      this.companyName,
      this.countryCode,
      this.currencyFormat,
      this.dateFormat,
      this.favoriteMenu,
      this.homePageStyle,
      this.languageCode,
      this.loginCount,
      this.luckyWheelSkipDays,
      this.luckyWheelTimeInSecond,
      this.previousVersion,
      this.shopUsername,
      this.showAllMenuOnStart,
      this.userMenus});

  ConfigurationValue.fromJson(Map<String, dynamic> jsonMap) {
    shopUrl = jsonMap['ShopUrl'];
    shopUsername = jsonMap['ShopUsername'];
    companyName = jsonMap['CompanyName'];
    loginCount = jsonMap['LoginCount'] != null ? int.tryParse(jsonMap['LoginCount']) : 0;

    if (jsonMap['UserMenus'] != null) {
      userMenus = (jsonDecode(jsonMap["UserMenus"]) as List).map<Map<String,dynamic>>((map) {
        return map;
      }).toList();
    }

    if (jsonMap['FavoriteMenu'] != null) {
      favoriteMenu = jsonDecode(jsonMap["FavoriteMenu"]);
    }

    languageCode = jsonMap['LanguageCode'];
    countryCode = jsonMap['CountryCode'];
    currencyFormat = jsonMap['CurrencyFormat'];
    dateTimeFormat = jsonMap['DateTimeFormat'];
    previousVersion = jsonMap['PreviousVersion'];
    homePageStyle = jsonMap['HomePageStyle'];


    showAllMenuOnStart = jsonMap['ShowAllMenuOnStart']?.toString()?.parseBool();
    luckyWheelHasComment = jsonMap['LuckyWheelHasComment']?.toString()?.parseBool();
    luckyWheelHasShare = jsonMap['LuckyWheelHasShare']?.toString()?.parseBool();
    luckyWheelHasOrder = jsonMap['LuckyWheelHasOrder']?.toString()?.parseBool();
    luckyWheelIgnoreWinnerPlayer = jsonMap['LuckyWheelIgnoreWinnerPlayer']?.toString()?.parseBool();
    luckyWheelPrioritySharers = jsonMap['LuckyWheelPrioritySharers']?.toString()?.parseBool();
    luckyWheelPriorityGroupSharers = jsonMap['LuckyWheelPriorityGroupSharers']?.toString()?.parseBool();
    luckyWheelPriorityPersonalSharers = jsonMap['LuckyWheelPriorityPersonalSharers']?.toString()?.parseBool();
    luckyWheelPriorityCommentPlayers = jsonMap['LuckyWheelPriorityCommentPlayers']?.toString()?.parseBool();
    luckyWheelPriorityIgnoreWinner = jsonMap['LuckyWheelPriorityIgnoreWinner']?.toString()?.parseBool();
    luckyWheelTimeInSecond = jsonMap['LuckyWheelTimeInSecond'] != null ? int.tryParse(jsonMap['LuckyWheelTimeInSecond']) : 0;
    luckyWheelSkipDays = jsonMap['LuckyWheelSkipDays'] != null ? int.tryParse(jsonMap['LuckyWheelSkipDays']) : 0;
    luckyWheelIsPriority = jsonMap['LuckyWheelIsPriority']?.toString()?.parseBool();
  }

  Map<String, dynamic> toJson([removeIfNull = false]) {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["ShopUrl"] = shopUrl;
    map["ShopUsername"] = shopUsername;
    map["CompanyName"] = companyName;
    map["LoginCount"] = loginCount?.toString();

    map["UserMenus"] = userMenus != null ? jsonEncode(userMenus) : null;
    map["FavoriteMenu"] = favoriteMenu != null ? jsonEncode(favoriteMenu) : null;

    map["LanguageCode"] = languageCode;
    map["CountryCode"] = countryCode;
    map["CurrencyFormat"] = currencyFormat;
    map["DateTimeFormat"] = dateTimeFormat;
    map["PreviousVersion"] = previousVersion;
    map["HomePageStyle"] = homePageStyle;
    map["ShowAllMenuOnStart"] = showAllMenuOnStart?.toString();
    map["LuckyWheelHasComment"] = luckyWheelHasComment?.toString();
    map["LuckyWheelHasShare"] = luckyWheelHasShare?.toString();
    map["LuckyWheelHasOrder"] = luckyWheelHasOrder?.toString();
    map["LuckyWheelIgnoreWinnerPlayer"] = luckyWheelIgnoreWinnerPlayer?.toString();
    map["LuckyWheelPrioritySharers"] = luckyWheelPrioritySharers?.toString();
    map["LuckyWheelPriorityGroupSharers"] = luckyWheelPriorityGroupSharers?.toString();
    map["LuckyWheelPriorityPersonalSharers"] = luckyWheelPriorityPersonalSharers?.toString();
    map["LuckyWheelPriorityCommentPlayers"] = luckyWheelPriorityCommentPlayers?.toString();
    map["LuckyWheelPriorityIgnoreWinner"] = luckyWheelPriorityIgnoreWinner?.toString();
    map["LuckyWheelTimeInSecond"] = luckyWheelTimeInSecond?.toString();
    map["LuckyWheelSkipDays"] = luckyWheelSkipDays?.toString();
    map["LuckyWheelIsPriority"] = luckyWheelIsPriority?.toString();

    return map;
  }

  String shopUrl;
  String shopUsername;
  int loginCount;
  Map<String, dynamic> favoriteMenu;

  /// Lưu danh sách menu người dùng
  List<Map<String, dynamic>> userMenus;

  String languageCode;
  String countryCode;
  String currencyFormat;
  String dateFormat;
  String dateTimeFormat;
  String companyName;
  String previousVersion;
  String homePageStyle;
  bool showAllMenuOnStart;

  ///Game lucky wheel
  bool luckyWheelHasComment;
  bool luckyWheelHasShare;
  bool luckyWheelHasOrder;
  bool luckyWheelIgnoreWinnerPlayer;
  bool luckyWheelPrioritySharers;
  bool luckyWheelPriorityGroupSharers;
  bool luckyWheelPriorityPersonalSharers;
  bool luckyWheelPriorityCommentPlayers;
  bool luckyWheelPriorityIgnoreWinner;
  bool luckyWheelIgnoreWinnerDay;
  int luckyWheelTimeInSecond;
  int luckyWheelSkipDays;
  bool luckyWheelIsPriority;
}
