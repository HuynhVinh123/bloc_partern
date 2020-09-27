// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();

  static S current;

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();

      return S.current;
    });
  }

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `TPOS Sale Management`
  String get appTitle {
    return Intl.message(
      'TPOS Sale Management',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Select language`
  String get selectLanguage {
    return Intl.message(
      'Select language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Hotline{hotline}`
  String hotline(Object hotline) {
    return Intl.message(
      'Hotline$hotline',
      name: 'hotline',
      desc: '',
      args: [hotline],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Function`
  String get function {
    return Intl.message(
      'Function',
      name: 'function',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get statistics {
    return Intl.message(
      'Statistics',
      name: 'statistics',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Personal`
  String get personal {
    return Intl.message(
      'Personal',
      name: 'personal',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get aboutApplication {
    return Intl.message(
      'About',
      name: 'aboutApplication',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting {
    return Intl.message(
      'Settings',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Send a feedback email`
  String get sendEmailFeedback {
    return Intl.message(
      'Send a feedback email',
      name: 'sendEmailFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Vote our app`
  String get voteForApp {
    return Intl.message(
      'Vote our app',
      name: 'voteForApp',
      desc: '',
      args: [],
    );
  }

  /// `Check for update`
  String get checkForUpdate {
    return Intl.message(
      'Check for update',
      name: 'checkForUpdate',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Other report`
  String get otherReport {
    return Intl.message(
      'Other report',
      name: 'otherReport',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `This month`
  String get thisMonth {
    return Intl.message(
      'This month',
      name: 'thisMonth',
      desc: '',
      args: [],
    );
  }

  /// `This year`
  String get thisYear {
    return Intl.message(
      'This year',
      name: 'thisYear',
      desc: '',
      args: [],
    );
  }

  /// `Facebook channel`
  String get facebookChannel {
    return Intl.message(
      'Facebook channel',
      name: 'facebookChannel',
      desc: '',
      args: [],
    );
  }

  /// `Facebook Order`
  String get facebookOrder {
    return Intl.message(
      'Facebook Order',
      name: 'facebookOrder',
      desc: '',
      args: [],
    );
  }

  /// `Live Campaign`
  String get liveCampaign {
    return Intl.message(
      'Live Campaign',
      name: 'liveCampaign',
      desc: '',
      args: [],
    );
  }

  /// `Create new sale order`
  String get createFastSaleOrder {
    return Intl.message(
      'Create new sale order',
      name: 'createFastSaleOrder',
      desc: '',
      args: [],
    );
  }

  /// `Sale orders`
  String get saleOrders {
    return Intl.message(
      'Sale orders',
      name: 'saleOrders',
      desc: '',
      args: [],
    );
  }

  /// `Delivery sale orders`
  String get deliverySaleOrders {
    return Intl.message(
      'Delivery sale orders',
      name: 'deliverySaleOrders',
      desc: '',
      args: [],
    );
  }

  /// `Pos order`
  String get posOrder {
    return Intl.message(
      'Pos order',
      name: 'posOrder',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Home page`
  String get homePage {
    return Intl.message(
      'Home page',
      name: 'homePage',
      desc: '',
      args: [],
    );
  }

  /// `Print configuration`
  String get printConfiguration {
    return Intl.message(
      'Print configuration',
      name: 'printConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get introPage_registerButtonTitle {
    return Intl.message(
      'Register',
      name: 'introPage_registerButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get introPage_loginButtonTitle {
    return Intl.message(
      'Login',
      name: 'introPage_loginButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Comprehensive management`
  String get introPage_page1Title {
    return Intl.message(
      'Comprehensive management',
      name: 'introPage_page1Title',
      desc: '',
      args: [],
    );
  }

  /// `Selling at stores and selling online via Facebook...`
  String get introPage_page1Description {
    return Intl.message(
      'Selling at stores and selling online via Facebook...',
      name: 'introPage_page1Description',
      desc: '',
      args: [],
    );
  }

  /// `Connect 12+ delivery partners`
  String get introPage_page2Title {
    return Intl.message(
      'Connect 12+ delivery partners',
      name: 'introPage_page2Title',
      desc: '',
      args: [],
    );
  }

  /// `Push order directly to multiple delivery carrier linked to TPOS App`
  String get introPage_page2Description {
    return Intl.message(
      'Push order directly to multiple delivery carrier linked to TPOS App',
      name: 'introPage_page2Description',
      desc: '',
      args: [],
    );
  }

  /// `Full report`
  String get introPage_page3Title {
    return Intl.message(
      'Full report',
      name: 'introPage_page3Title',
      desc: '',
      args: [],
    );
  }

  /// `Clear revenue and profit report helps shop owners manage cash flow effectively`
  String get introPage_page3Description {
    return Intl.message(
      'Clear revenue and profit report helps shop owners manage cash flow effectively',
      name: 'introPage_page3Description',
      desc: '',
      args: [],
    );
  }

  /// `Đăng nhập`
  String get loginPage_loginButtonTitle {
    return Intl.message(
      'Đăng nhập',
      name: 'loginPage_loginButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get loginPage_forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'loginPage_forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Dont't have account? Sign up now`
  String get loginPage_registerButtonTitle {
    return Intl.message(
      'Dont\'t have account? Sign up now',
      name: 'loginPage_registerButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Authentication failed`
  String get loginPage_loginFailTitle {
    return Intl.message(
      'Authentication failed',
      name: 'loginPage_loginFailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Required field have not been entered`
  String get dialogValidateFail {
    return Intl.message(
      'Required field have not been entered',
      name: 'dialogValidateFail',
      desc: '',
      args: [],
    );
  }

  /// `Đồng ý`
  String get dialogActionOk {
    return Intl.message(
      'Đồng ý',
      name: 'dialogActionOk',
      desc: '',
      args: [],
    );
  }

  /// `Không thể kết nối tới máy chủ`
  String get dialog_canNotConnectToServer {
    return Intl.message(
      'Không thể kết nối tới máy chủ',
      name: 'dialog_canNotConnectToServer',
      desc: '',
      args: [],
    );
  }

  /// `Printers`
  String get config_printers {
    return Intl.message(
      'Printers',
      name: 'config_printers',
      desc: '',
      args: [],
    );
  }

  /// `Sale settings`
  String get config_SaleSettings {
    return Intl.message(
      'Sale settings',
      name: 'config_SaleSettings',
      desc: '',
      args: [],
    );
  }

  /// `Sale online settings`
  String get config_SaleOnlineSetting {
    return Intl.message(
      'Sale online settings',
      name: 'config_SaleOnlineSetting',
      desc: '',
      args: [],
    );
  }

  /// `Facebook sale channel`
  String get menu_FacebookSaleChannel {
    return Intl.message(
      'Facebook sale channel',
      name: 'menu_FacebookSaleChannel',
      desc: '',
      args: [],
    );
  }

  /// `Close the order`
  String get menu_CloseOrderLivestram {
    return Intl.message(
      'Close the order',
      name: 'menu_CloseOrderLivestram',
      desc: '',
      args: [],
    );
  }

  /// `Sale online orders`
  String get menu_SaleOnlineOrder {
    return Intl.message(
      'Sale online orders',
      name: 'menu_SaleOnlineOrder',
      desc: '',
      args: [],
    );
  }

  /// `Live campaign`
  String get menu_LiveCampaign {
    return Intl.message(
      'Live campaign',
      name: 'menu_LiveCampaign',
      desc: '',
      args: [],
    );
  }

  /// `Create sale order`
  String get menu_createFastSaleOrder {
    return Intl.message(
      'Create sale order',
      name: 'menu_createFastSaleOrder',
      desc: '',
      args: [],
    );
  }

  /// `Fast sale orders`
  String get menu_fastSaleOrders {
    return Intl.message(
      'Fast sale orders',
      name: 'menu_fastSaleOrders',
      desc: '',
      args: [],
    );
  }

  /// `Delivery sale orders`
  String get menu_deliverySaleOrders {
    return Intl.message(
      'Delivery sale orders',
      name: 'menu_deliverySaleOrders',
      desc: '',
      args: [],
    );
  }

  /// `Pos of sale`
  String get menu_posOfSale {
    return Intl.message(
      'Pos of sale',
      name: 'menu_posOfSale',
      desc: '',
      args: [],
    );
  }

  /// `Quotations`
  String get menu_quotation {
    return Intl.message(
      'Quotations',
      name: 'menu_quotation',
      desc: '',
      args: [],
    );
  }

  /// `Purchase order`
  String get menu_purchaseOrder {
    return Intl.message(
      'Purchase order',
      name: 'menu_purchaseOrder',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get menu_product {
    return Intl.message(
      'Products',
      name: 'menu_product',
      desc: '',
      args: [],
    );
  }

  /// `Inventory receiving voucher`
  String get menu_import {
    return Intl.message(
      'Inventory receiving voucher',
      name: 'menu_import',
      desc: '',
      args: [],
    );
  }

  /// `Customers`
  String get menu_customer {
    return Intl.message(
      'Customers',
      name: 'menu_customer',
      desc: '',
      args: [],
    );
  }

  /// `Suppliers`
  String get menu_supplier {
    return Intl.message(
      'Suppliers',
      name: 'menu_supplier',
      desc: '',
      args: [],
    );
  }

  /// `Delivery carriers`
  String get menu_deliveryCarrier {
    return Intl.message(
      'Delivery carriers',
      name: 'menu_deliveryCarrier',
      desc: '',
      args: [],
    );
  }

  /// `Cash Receipt`
  String get menu_cashReceipt {
    return Intl.message(
      'Cash Receipt',
      name: 'menu_cashReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Payment Receipt`
  String get menu_paymentReceipt {
    return Intl.message(
      'Payment Receipt',
      name: 'menu_paymentReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Add customer`
  String get menu_addCustomer {
    return Intl.message(
      'Add customer',
      name: 'menu_addCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Add product`
  String get menu_addProduct {
    return Intl.message(
      'Add product',
      name: 'menu_addProduct',
      desc: '',
      args: [],
    );
  }

  /// `Sale setting`
  String get menu_settingSaleOrder {
    return Intl.message(
      'Sale setting',
      name: 'menu_settingSaleOrder',
      desc: '',
      args: [],
    );
  }

  /// `Print configuration`
  String get menu_settingPrinter {
    return Intl.message(
      'Print configuration',
      name: 'menu_settingPrinter',
      desc: '',
      args: [],
    );
  }

  /// `Sale channels`
  String get menu_saleChannels {
    return Intl.message(
      'Sale channels',
      name: 'menu_saleChannels',
      desc: '',
      args: [],
    );
  }

  /// `Customer categories`
  String get menu_customerGroup {
    return Intl.message(
      'Customer categories',
      name: 'menu_customerGroup',
      desc: '',
      args: [],
    );
  }

  /// `Product categories`
  String get menu_productGroup {
    return Intl.message(
      'Product categories',
      name: 'menu_productGroup',
      desc: '',
      args: [],
    );
  }

  /// `Receipt type`
  String get menu_receiptType {
    return Intl.message(
      'Receipt type',
      name: 'menu_receiptType',
      desc: '',
      args: [],
    );
  }

  /// `Payment type`
  String get menu_paymentType {
    return Intl.message(
      'Payment type',
      name: 'menu_paymentType',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get menu_search {
    return Intl.message(
      'Search',
      name: 'menu_search',
      desc: '',
      args: [],
    );
  }

  /// `All features`
  String get menu_allFeature {
    return Intl.message(
      'All features',
      name: 'menu_allFeature',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get menu_customMenu {
    return Intl.message(
      'Custom',
      name: 'menu_customMenu',
      desc: '',
      args: [],
    );
  }

  /// `Select sale channel`
  String get selectFacebookSaleChannel {
    return Intl.message(
      'Select sale channel',
      name: 'selectFacebookSaleChannel',
      desc: '',
      args: [],
    );
  }

  /// `Login facebook`
  String get loginFacebook {
    return Intl.message(
      'Login facebook',
      name: 'loginFacebook',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Add new page`
  String get addNewPage {
    return Intl.message(
      'Add new page',
      name: 'addNewPage',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Save with name`
  String get saveWithName {
    return Intl.message(
      'Save with name',
      name: 'saveWithName',
      desc: '',
      args: [],
    );
  }

  /// `ConnectedChannel`
  String get connectedChannel {
    return Intl.message(
      'ConnectedChannel',
      name: 'connectedChannel',
      desc: '',
      args: [],
    );
  }

  /// `Your account has only {expiredDay} to expire. Please renew soon`
  String notifyExpire(Object expiredDay) {
    return Intl.message(
      'Your account has only $expiredDay to expire. Please renew soon',
      name: 'notifyExpire',
      desc: '',
      args: [expiredDay],
    );
  }

  /// `The facebook sale channel ({channelId}) already exists.`
  String saleOnline_existsNotify(Object channelId) {
    return Intl.message(
      'The facebook sale channel ($channelId) already exists.',
      name: 'saleOnline_existsNotify',
      desc: '',
      args: [channelId],
    );
  }

  /// `Load more`
  String get loadMore {
    return Intl.message(
      'Load more',
      name: 'loadMore',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Only show > 10 comments`
  String get saleOnline_checkboxOnlyTenComment {
    return Intl.message(
      'Only show > 10 comments',
      name: 'saleOnline_checkboxOnlyTenComment',
      desc: '',
      args: [],
    );
  }

  /// `Sale online`
  String get menuGroupType_saleOnline {
    return Intl.message(
      'Sale online',
      name: 'menuGroupType_saleOnline',
      desc: '',
      args: [],
    );
  }

  /// `Fast sale`
  String get menuGroupType_fastSaleOrder {
    return Intl.message(
      'Fast sale',
      name: 'menuGroupType_fastSaleOrder',
      desc: '',
      args: [],
    );
  }

  /// `Pos of sale`
  String get menuGroupType_posOrder {
    return Intl.message(
      'Pos of sale',
      name: 'menuGroupType_posOrder',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse`
  String get menuGroupType_inventory {
    return Intl.message(
      'Warehouse',
      name: 'menuGroupType_inventory',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get menuGroupType_category {
    return Intl.message(
      'Categories',
      name: 'menuGroupType_category',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get menuGroupType_setting {
    return Intl.message(
      'Settings',
      name: 'menuGroupType_setting',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get changePassword_oldPassword {
    return Intl.message(
      'Old password',
      name: 'changePassword_oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get changePassword_newPassword {
    return Intl.message(
      'New password',
      name: 'changePassword_newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get changePassword_confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'changePassword_confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get changePassword_confirm {
    return Intl.message(
      'Confirm',
      name: 'changePassword_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword_changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword_changePassword',
      desc: '',
      args: [],
    );
  }

  /// `isNotEmpty`
  String get changePassword_isNotEmpty {
    return Intl.message(
      'Password is not empty!',
      name: 'changePassword_isNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `character length`
  String get changePassword_characterLength6 {
    return Intl.message(
      'Character length > 6',
      name: 'changePassword_characterLength6',
      desc: '',
      args: [],
    );
  }

  /// `character length`
  String get changePassword_characterLength36 {
    return Intl.message(
      'Character length <= 36',
      name: 'changePassword_characterLength36',
      desc: '',
      args: [],
    );
  }

  /// `Change failed`
  String get changePassword_changeFailed {
    return Intl.message(
      'Change failed',
      name: 'changePassword_changeFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please try to again!`
  String get changePassword_tryToAgain {
    return Intl.message(
      'Please try to again!',
      name: 'changePassword_tryToAgain',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password Error!`
  String get changePassword_confirmPasswordError {
    return Intl.message(
      'Confirm password error',
      name: 'changePassword_confirmPasswordError',
      desc: '',
      args: [],
    );
  }

  /// `Send!`
  String get forgotPassword_Send {
    return Intl.message(
      'Send',
      name: 'forgotPassword_Send',
      desc: '',
      args: [],
    );
  }

  /// Notify forgot password
  String get forgotPassword_Notify {
    return Intl.message(
      'Enter the email connected to your account.Check email and change password.',
      name: 'forgotPassword_Notify',
      desc: '',
      args: [],
    );
  }

  /// Reverse
  String get fbPostShare_Reverse {
    return Intl.message(
      'Reverse',
      name: 'fbPostShare_Reverse',
      desc: '',
      args: [],
    );
  }

  /// Total
  String get fbPostShare_Total {
    return Intl.message(
      'Total',
      name: 'fbPostShare_Total',
      desc: '',
      args: [],
    );
  }

  /// Total
  String get fbPostShare_Reload {
    return Intl.message(
      'Reload',
      name: 'fbPostShare_Reload',
      desc: '',
      args: [],
    );
  }

  /// Number of sharing people
  String get fbPostShare_NumberOfSharingPeople {
    return Intl.message(
      'Number of sharing people',
      name: 'fbPostShare_NumberOfSharingPeople',
      desc: '',
      args: [],
    );
  }

  /// share personally
  String get fbPostShare_SharePersonally {
    return Intl.message(
      'Share personally',
      name: 'fbPostShare_SharePersonally',
      desc: '',
      args: [],
    );
  }

  /// Share to group
  String get fbPostShare_ShareToGroup {
    return Intl.message(
      'Share to group',
      name: 'fbPostShare_ShareToGroup',
      desc: '',
      args: [],
    );
  }

  /// Number of share
  String get fbPostShare_NumberOfShare {
    return Intl.message(
      'Number of share',
      name: 'fbPostShare_NumberOfShare',
      desc: '',
      args: [],
    );
  }

  /// Number of share
  String get fbPostShare_NotFoundShare {
    return Intl.message(
      'Not found. Please try to again!',
      name: 'fbPostShare_NotFoundShare',
      desc: '',
      args: [],
    );
  }
  /// Number of share
  String get fbPostShare_CloseContinue {
    return Intl.message(
      'Close & Continue',
      name: 'fbPostShare_CloseContinue',
      desc: '',
      args: [],
    );
  }


}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
