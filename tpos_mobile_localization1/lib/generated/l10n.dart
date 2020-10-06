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
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
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

  /// `Invoice report`
  String get menu_invoiceReport {
    return Intl.message(
      'Invoice report',
      name: 'menu_invoiceReport',
      desc: '',
      args: [],
    );
  }

  /// `Delivery report`
  String get menu_deliveryReport {
    return Intl.message(
      'Delivery report',
      name: 'menu_deliveryReport',
      desc: '',
      args: [],
    );
  }

  /// `Inventory`
  String get menu_inventoryReport {
    return Intl.message(
      'Inventory',
      name: 'menu_inventoryReport',
      desc: '',
      args: [],
    );
  }

  /// `Business report`
  String get menu_businessReport {
    return Intl.message(
      'Business report',
      name: 'menu_businessReport',
      desc: '',
      args: [],
    );
  }

  /// `Customer dept`
  String get menu_customerDeptReport {
    return Intl.message(
      'Customer dept',
      name: 'menu_customerDeptReport',
      desc: '',
      args: [],
    );
  }

  /// `Supplier dept`
  String get menu_supplierDeptReport {
    return Intl.message(
      'Supplier dept',
      name: 'menu_supplierDeptReport',
      desc: '',
      args: [],
    );
  }

  /// `Pos sessions`
  String get menu_posSession {
    return Intl.message(
      'Pos sessions',
      name: 'menu_posSession',
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

  /// `Connected channel`
  String get connectedChannel {
    return Intl.message(
      'Connected channel',
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

  /// `Report`
  String get menuGroup_report {
    return Intl.message(
      'Report',
      name: 'menuGroup_report',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get report_reportList {
    return Intl.message(
      'Reports',
      name: 'report_reportList',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get loginPage_forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'loginPage_forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Old password`
  String get changePassword_oldPassword {
    return Intl.message(
      'Old password',
      name: 'changePassword_oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get changePassword_newPassword {
    return Intl.message(
      'New password',
      name: 'changePassword_newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
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

  /// `Password cannot be empty!`
  String get changePassword_isNotEmpty {
    return Intl.message(
      'Password cannot be empty!',
      name: 'changePassword_isNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Your password must be between 6-36 characters`
  String get changePassword_characterLength6 {
    return Intl.message(
      'Your password must be between 6-36 characters',
      name: 'changePassword_characterLength6',
      desc: '',
      args: [],
    );
  }

  /// `Your password must be between 6-36 characters`
  String get changePassword_characterLength36 {
    return Intl.message(
      'Your password must be between 6-36 characters',
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

  /// `Passwords do not match`
  String get changePassword_confirmPasswordError {
    return Intl.message(
      'Passwords do not match',
      name: 'changePassword_confirmPasswordError',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get forgotPassword_Send {
    return Intl.message(
      'Send',
      name: 'forgotPassword_Send',
      desc: '',
      args: [],
    );
  }

  /// `Enter the email connected to your account.Check email and change password.`
  String get forgotPassword_Notify {
    return Intl.message(
      'Enter the email connected to your account.Check email and change password.',
      name: 'forgotPassword_Notify',
      desc: '',
      args: [],
    );
  }

  /// `Reverse`
  String get fbPostShare_Reverse {
    return Intl.message(
      'Reverse',
      name: 'fbPostShare_Reverse',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get fbPostShare_Total {
    return Intl.message(
      'Total',
      name: 'fbPostShare_Total',
      desc: '',
      args: [],
    );
  }

  /// `Number of sharing people`
  String get fbPostShare_NumberOfSharingPeople {
    return Intl.message(
      'Number of sharing people',
      name: 'fbPostShare_NumberOfSharingPeople',
      desc: '',
      args: [],
    );
  }

  /// `Share personally`
  String get fbPostShare_SharePersonally {
    return Intl.message(
      'Share personally',
      name: 'fbPostShare_SharePersonally',
      desc: '',
      args: [],
    );
  }

  /// `Share to group`
  String get fbPostShare_ShareToGroup {
    return Intl.message(
      'Share to group',
      name: 'fbPostShare_ShareToGroup',
      desc: '',
      args: [],
    );
  }

  /// `Number of share`
  String get fbPostShare_NumberOfShare {
    return Intl.message(
      'Number of share',
      name: 'fbPostShare_NumberOfShare',
      desc: '',
      args: [],
    );
  }

  /// `Reload`
  String get fbPostShare_Reload {
    return Intl.message(
      'Reload',
      name: 'fbPostShare_Reload',
      desc: '',
      args: [],
    );
  }

  /// `Not found. Please try to again!`
  String get fbPostShare_NotFoundShare {
    return Intl.message(
      'Not found. Please try to again!',
      name: 'fbPostShare_NotFoundShare',
      desc: '',
      args: [],
    );
  }

  /// `Close & Continue`
  String get fbPostShare_CloseContinue {
    return Intl.message(
      'Close & Continue',
      name: 'fbPostShare_CloseContinue',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while sending request to the server. Code {statusCode}`
  String network_default(Object statusCode) {
    return Intl.message(
      'An error occurred while sending request to the server. Code $statusCode',
      name: 'network_default',
      desc: '',
      args: [statusCode],
    );
  }

  /// `400. Bad request`
  String get network_badRequest {
    return Intl.message(
      '400. Bad request',
      name: 'network_badRequest',
      desc: '',
      args: [],
    );
  }

  /// `401. Authentication required`
  String get network_authorisedRequest {
    return Intl.message(
      '401. Authentication required',
      name: 'network_authorisedRequest',
      desc: '',
      args: [],
    );
  }

  /// `500. Internal server error`
  String get network_internalServerError {
    return Intl.message(
      '500. Internal server error',
      name: 'network_internalServerError',
      desc: '',
      args: [],
    );
  }

  /// `Request time out`
  String get network_requestTimeout {
    return Intl.message(
      'Request time out',
      name: 'network_requestTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Send request time out`
  String get network_sendTimeout {
    return Intl.message(
      'Send request time out',
      name: 'network_sendTimeout',
      desc: '',
      args: [],
    );
  }

  /// `404. Not found`
  String get network_notFound {
    return Intl.message(
      '404. Not found',
      name: 'network_notFound',
      desc: '',
      args: [],
    );
  }

  /// `Service unavailable`
  String get network_serviceUnavailable {
    return Intl.message(
      'Service unavailable',
      name: 'network_serviceUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `The request cancelled`
  String get network_requestCancelled {
    return Intl.message(
      'The request cancelled',
      name: 'network_requestCancelled',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get network_noInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'network_noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Invoice report`
  String get reportOrder_invoiceStatistics {
    return Intl.message(
      'Invoice report',
      name: 'reportOrder_invoiceStatistics',
      desc: '',
      args: [],
    );
  }

  /// `Overview`
  String get reportOrder_Overview {
    return Intl.message(
      'Overview',
      name: 'reportOrder_Overview',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get reportOrder_Sell {
    return Intl.message(
      'Sell',
      name: 'reportOrder_Sell',
      desc: '',
      args: [],
    );
  }

  /// `Promotion + Discount`
  String get reportOrder_promotionDiscount {
    return Intl.message(
      'Promotion + Discount',
      name: 'reportOrder_promotionDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Amount total`
  String get reportOrder_amountTotal {
    return Intl.message(
      'Amount total',
      name: 'reportOrder_amountTotal',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get reportOrder_Discount {
    return Intl.message(
      'Discount',
      name: 'reportOrder_Discount',
      desc: '',
      args: [],
    );
  }

  /// `Promotion`
  String get reportOrder_Promotion {
    return Intl.message(
      'Promotion',
      name: 'reportOrder_Promotion',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get reportOrder_Detail {
    return Intl.message(
      'Detail',
      name: 'reportOrder_Detail',
      desc: '',
      args: [],
    );
  }

  /// `Fast sale order`
  String get reportOrder_fastSaleOrder {
    return Intl.message(
      'Fast sale order',
      name: 'reportOrder_fastSaleOrder',
      desc: '',
      args: [],
    );
  }

  /// `Invoices`
  String get reportOrder_Invoices {
    return Intl.message(
      'Invoices',
      name: 'reportOrder_Invoices',
      desc: '',
      args: [],
    );
  }

  /// `Debt`
  String get reportOrder_Debt {
    return Intl.message(
      'Debt',
      name: 'reportOrder_Debt',
      desc: '',
      args: [],
    );
  }

  /// `Partner`
  String get partner {
    return Intl.message(
      'Partner',
      name: 'partner',
      desc: '',
      args: [],
    );
  }

  /// `Employee`
  String get employee {
    return Intl.message(
      'Employee',
      name: 'employee',
      desc: '',
      args: [],
    );
  }

  /// `Company`
  String get company {
    return Intl.message(
      'Company',
      name: 'company',
      desc: '',
      args: [],
    );
  }

  /// `Invoice type`
  String get reportOrder_invoiceType {
    return Intl.message(
      'Invoice type',
      name: 'reportOrder_invoiceType',
      desc: '',
      args: [],
    );
  }

  /// `Delivery report`
  String get reportOrder_deliveryStatistics {
    return Intl.message(
      'Delivery report',
      name: 'reportOrder_deliveryStatistics',
      desc: '',
      args: [],
    );
  }

  /// `Collection amount`
  String get reportOrder_collectionAmount {
    return Intl.message(
      'Collection amount',
      name: 'reportOrder_collectionAmount',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get reportOrder_Paid {
    return Intl.message(
      'Paid',
      name: 'reportOrder_Paid',
      desc: '',
      args: [],
    );
  }

  /// `Delivering`
  String get reportOrder_Delivering {
    return Intl.message(
      'Delivering',
      name: 'reportOrder_Delivering',
      desc: '',
      args: [],
    );
  }

  /// `Refunded Order`
  String get reportOrder_refundedOrder {
    return Intl.message(
      'Refunded Order',
      name: 'reportOrder_refundedOrder',
      desc: '',
      args: [],
    );
  }

  /// `The control was not successful`
  String get reportOrder_controlFailed {
    return Intl.message(
      'The control was not successful',
      name: 'reportOrder_controlFailed',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get reportOrder_Deposit {
    return Intl.message(
      'Deposit',
      name: 'reportOrder_Deposit',
      desc: '',
      args: [],
    );
  }

  /// `Invoices`
  String get reportOrder_Invoice {
    return Intl.message(
      'Invoices',
      name: 'reportOrder_Invoice',
      desc: '',
      args: [],
    );
  }

  /// `Delivery invoices`
  String get reportOrder_deliveryInvoices {
    return Intl.message(
      'Delivery invoices',
      name: 'reportOrder_deliveryInvoices',
      desc: '',
      args: [],
    );
  }

  /// `Delivery control`
  String get reportOrder_deliveryControl {
    return Intl.message(
      'Delivery control',
      name: 'reportOrder_deliveryControl',
      desc: '',
      args: [],
    );
  }

  /// `Delivery status`
  String get reportOrder_deliveryStatus {
    return Intl.message(
      'Delivery status',
      name: 'reportOrder_deliveryStatus',
      desc: '',
      args: [],
    );
  }

  /// `Control status`
  String get reportOrder_controlStatus {
    return Intl.message(
      'Control status',
      name: 'reportOrder_controlStatus',
      desc: '',
      args: [],
    );
  }

  /// `Delivery partner`
  String get reportOrder_deliveryPartner {
    return Intl.message(
      'Delivery partner',
      name: 'reportOrder_deliveryPartner',
      desc: '',
      args: [],
    );
  }

  /// `Delivery partner type`
  String get reportOrder_deliveryPartnerType {
    return Intl.message(
      'Delivery partner type',
      name: 'reportOrder_deliveryPartnerType',
      desc: '',
      args: [],
    );
  }

  /// `Companies`
  String get companies {
    return Intl.message(
      'Companies',
      name: 'companies',
      desc: '',
      args: [],
    );
  }

  /// `Employees`
  String get employees {
    return Intl.message(
      'Employees',
      name: 'employees',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Partners`
  String get reportOrder_partners {
    return Intl.message(
      'Partners',
      name: 'reportOrder_partners',
      desc: '',
      args: [],
    );
  }

  /// `Total invoices`
  String get reportOrder_totalInvoices {
    return Intl.message(
      'Total invoices',
      name: 'reportOrder_totalInvoices',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get reportOrder_All {
    return Intl.message(
      'All',
      name: 'reportOrder_All',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get reportOrder_Received {
    return Intl.message(
      'Received',
      name: 'reportOrder_Received',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Fast delivery`
  String get reportOrder_FastDelivery {
    return Intl.message(
      'Fast delivery',
      name: 'reportOrder_FastDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Base on rule`
  String get reportOrder_baseOnRule {
    return Intl.message(
      'Base on rule',
      name: 'reportOrder_baseOnRule',
      desc: '',
      args: [],
    );
  }

  /// `Fixed price`
  String get reportOrder_fixedPrice {
    return Intl.message(
      'Fixed price',
      name: 'reportOrder_fixedPrice',
      desc: '',
      args: [],
    );
  }

  /// `Refunded Product`
  String get reportOrder_refundedProduct {
    return Intl.message(
      'Refunded Product',
      name: 'reportOrder_refundedProduct',
      desc: '',
      args: [],
    );
  }

  /// `Has not received`
  String get reportOrder_hasNotReceived {
    return Intl.message(
      'Has not received',
      name: 'reportOrder_hasNotReceived',
      desc: '',
      args: [],
    );
  }

  /// `Collected money`
  String get reportOrder_collectedMoney {
    return Intl.message(
      'Collected money',
      name: 'reportOrder_collectedMoney',
      desc: '',
      args: [],
    );
  }

  /// `Checked`
  String get reportOrder_checked {
    return Intl.message(
      'Checked',
      name: 'reportOrder_checked',
      desc: '',
      args: [],
    );
  }

  /// `UnChecked`
  String get reportOrder_unChecked {
    return Intl.message(
      'UnChecked',
      name: 'reportOrder_unChecked',
      desc: '',
      args: [],
    );
  }

  /// `Demo`
  String get demo {
    return Intl.message(
      'Demo',
      name: 'demo',
      desc: '',
      args: [],
    );
  }

  /// `en`
  String get languageCode {
    return Intl.message(
      'en',
      name: 'languageCode',
      desc: '',
      args: [],
    );
  }

  /// `Create order`
  String get createOrder {
    return Intl.message(
      'Create order',
      name: 'createOrder',
      desc: '',
      args: [],
    );
  }

  /// `Create order`
  String get createOrderShort {
    return Intl.message(
      'Create order',
      name: 'createOrderShort',
      desc: '',
      args: [],
    );
  }

  /// `Select product`
  String get selectProduct {
    return Intl.message(
      'Select product',
      name: 'selectProduct',
      desc: '',
      args: [],
    );
  }

  /// `Select campaign`
  String get selectCampaign {
    return Intl.message(
      'Select campaign',
      name: 'selectCampaign',
      desc: '',
      args: [],
    );
  }

  /// `Print error`
  String get printError {
    return Intl.message(
      'Print error',
      name: 'printError',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message(
      'Info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get reply {
    return Intl.message(
      'Reply',
      name: 'reply',
      desc: '',
      args: [],
    );
  }

  /// `Send inbox`
  String get sendInbox {
    return Intl.message(
      'Send inbox',
      name: 'sendInbox',
      desc: '',
      args: [],
    );
  }

  /// `Hide`
  String get hide {
    return Intl.message(
      'Hide',
      name: 'hide',
      desc: '',
      args: [],
    );
  }

  /// `Unhide`
  String get unHide {
    return Intl.message(
      'Unhide',
      name: 'unHide',
      desc: '',
      args: [],
    );
  }

  /// `Facebook name, phone`
  String get findComment_hint {
    return Intl.message(
      'Facebook name, phone',
      name: 'findComment_hint',
      desc: '',
      args: [],
    );
  }

  /// `Find comments in this post`
  String get findComment_notifyTitle {
    return Intl.message(
      'Find comments in this post',
      name: 'findComment_notifyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter keywords as names, phone, numbers, or content to find the comment`
  String get findComment_description {
    return Intl.message(
      'Enter keywords as names, phone, numbers, or content to find the comment',
      name: 'findComment_description',
      desc: '',
      args: [],
    );
  }

  /// `Can't find any comment match with keyword: {keyword}`
  String findComment_notFound(Object keyword) {
    return Intl.message(
      'Can\'t find any comment match with keyword: $keyword',
      name: 'findComment_notFound',
      desc: '',
      args: [keyword],
    );
  }

  /// `Summary`
  String get summary {
    return Intl.message(
      'Summary',
      name: 'summary',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get customer {
    return Intl.message(
      'Customer',
      name: 'customer',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message(
      'Product',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Share count`
  String get commentMenu_shareCount {
    return Intl.message(
      'Share count',
      name: 'commentMenu_shareCount',
      desc: '',
      args: [],
    );
  }

  /// `Post summary`
  String get commentMenu_postSummary {
    return Intl.message(
      'Post summary',
      name: 'commentMenu_postSummary',
      desc: '',
      args: [],
    );
  }

  /// `Save comment`
  String get commentMenu_saveComment {
    return Intl.message(
      'Save comment',
      name: 'commentMenu_saveComment',
      desc: '',
      args: [],
    );
  }

  /// `Game`
  String get commentMenu_game {
    return Intl.message(
      'Game',
      name: 'commentMenu_game',
      desc: '',
      args: [],
    );
  }

  /// `Facebook user`
  String get commentMenu_facebookUser {
    return Intl.message(
      'Facebook user',
      name: 'commentMenu_facebookUser',
      desc: '',
      args: [],
    );
  }

  /// `Export excel`
  String get commentMenu_exportExcel {
    return Intl.message(
      'Export excel',
      name: 'commentMenu_exportExcel',
      desc: '',
      args: [],
    );
  }

  /// `Export excel has phone`
  String get commentMenu_exportExcelHasPhone {
    return Intl.message(
      'Export excel has phone',
      name: 'commentMenu_exportExcelHasPhone',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get commentMenu_refresh {
    return Intl.message(
      'Refresh',
      name: 'commentMenu_refresh',
      desc: '',
      args: [],
    );
  }

  /// `Sync and update`
  String get commentMenu_synchAndUpdate {
    return Intl.message(
      'Sync and update',
      name: 'commentMenu_synchAndUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Select customer`
  String get selectCustomer {
    return Intl.message(
      'Select customer',
      name: 'selectCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Other information`
  String get otherInformation {
    return Intl.message(
      'Other information',
      name: 'otherInformation',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Date`
  String get invoiceDate {
    return Intl.message(
      'Invoice Date',
      name: 'invoiceDate',
      desc: '',
      args: [],
    );
  }

  /// `Seller`
  String get seller {
    return Intl.message(
      'Seller',
      name: 'seller',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Amount total`
  String get totalAmount {
    return Intl.message(
      'Amount total',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Payment information`
  String get paymentInformation {
    return Intl.message(
      'Payment information',
      name: 'paymentInformation',
      desc: '',
      args: [],
    );
  }

  /// `Payment method`
  String get paymentMethod {
    return Intl.message(
      'Payment method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Discount amount`
  String get discountAmount {
    return Intl.message(
      'Discount amount',
      name: 'discountAmount',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message(
      'Paid',
      name: 'paid',
      desc: '',
      args: [],
    );
  }

  /// `Left`
  String get left {
    return Intl.message(
      'Left',
      name: 'left',
      desc: '',
      args: [],
    );
  }

  /// `Shipping address`
  String get shippingAddress {
    return Intl.message(
      'Shipping address',
      name: 'shippingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Delivery carrier and fee`
  String get deliveryCarrierAndFee {
    return Intl.message(
      'Delivery carrier and fee',
      name: 'deliveryCarrierAndFee',
      desc: '',
      args: [],
    );
  }

  /// `Delivery carrier`
  String get deliveryCarrier {
    return Intl.message(
      'Delivery carrier',
      name: 'deliveryCarrier',
      desc: '',
      args: [],
    );
  }

  /// `Tap to select`
  String get tapToSelect {
    return Intl.message(
      'Tap to select',
      name: 'tapToSelect',
      desc: '',
      args: [],
    );
  }

  /// `Delivery carrier fee`
  String get deliveryCarrierFee {
    return Intl.message(
      'Delivery carrier fee',
      name: 'deliveryCarrierFee',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `Shipping fee`
  String get shippingFee {
    return Intl.message(
      'Shipping fee',
      name: 'shippingFee',
      desc: '',
      args: [],
    );
  }

  /// `Deposit amount`
  String get depositAmount {
    return Intl.message(
      'Deposit amount',
      name: 'depositAmount',
      desc: '',
      args: [],
    );
  }

  /// `Cash on delivery`
  String get cashOnDelivery {
    return Intl.message(
      'Cash on delivery',
      name: 'cashOnDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Delivery note`
  String get deliveryNote {
    return Intl.message(
      'Delivery note',
      name: 'deliveryNote',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `The list of products is empty. Please press 'Find Product' for add`
  String get addFastSaleOrder_emptyProductNotify {
    return Intl.message(
      'The list of products is empty. Please press \'Find Product\' for add',
      name: 'addFastSaleOrder_emptyProductNotify',
      desc: '',
      args: [],
    );
  }

  /// `Select delivery carrier`
  String get addFastSaleOrder_delieryEmptyNotify {
    return Intl.message(
      'Select delivery carrier',
      name: 'addFastSaleOrder_delieryEmptyNotify',
      desc: '',
      args: [],
    );
  }

  /// `Leave a note to shipper`
  String get addFastSaleOrder_deliveryNoteHint {
    return Intl.message(
      'Leave a note to shipper',
      name: 'addFastSaleOrder_deliveryNoteHint',
      desc: '',
      args: [],
    );
  }

  /// `Back to invoice`
  String get backToInvoice {
    return Intl.message(
      'Back to invoice',
      name: 'backToInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Dept`
  String get dept {
    return Intl.message(
      'Dept',
      name: 'dept',
      desc: '',
      args: [],
    );
  }

  /// `Invoice`
  String get invoice {
    return Intl.message(
      'Invoice',
      name: 'invoice',
      desc: '',
      args: [],
    );
  }

  /// `Revenue`
  String get revenue {
    return Intl.message(
      'Revenue',
      name: 'revenue',
      desc: '',
      args: [],
    );
  }

  /// `Total revenue`
  String get totalRevenue {
    return Intl.message(
      'Total revenue',
      name: 'totalRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Current dept`
  String get currentDept {
    return Intl.message(
      'Current dept',
      name: 'currentDept',
      desc: '',
      args: [],
    );
  }

  /// `Customer's info`
  String get customerInfo {
    return Intl.message(
      'Customer\'s info',
      name: 'customerInfo',
      desc: '',
      args: [],
    );
  }

  /// `Customer Number`
  String get customerNumber {
    return Intl.message(
      'Customer Number',
      name: 'customerNumber',
      desc: '',
      args: [],
    );
  }

  /// `Customer name`
  String get customerName {
    return Intl.message(
      'Customer name',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Birthday`
  String get birthday {
    return Intl.message(
      'Birthday',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `Customer groups`
  String get customerGroups {
    return Intl.message(
      'Customer groups',
      name: 'customerGroups',
      desc: '',
      args: [],
    );
  }

  /// `Tax code`
  String get taxCode {
    return Intl.message(
      'Tax code',
      name: 'taxCode',
      desc: '',
      args: [],
    );
  }

  /// `Price list`
  String get priceList {
    return Intl.message(
      'Price list',
      name: 'priceList',
      desc: '',
      args: [],
    );
  }

  /// `Default discount`
  String get defaultDiscount {
    return Intl.message(
      'Default discount',
      name: 'defaultDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Default discount in amount`
  String get defaultAmountDiscount {
    return Intl.message(
      'Default discount in amount',
      name: 'defaultAmountDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Other info (FB, mail, zalo)`
  String get partnerInfo_otherInfo {
    return Intl.message(
      'Other info (FB, mail, zalo)',
      name: 'partnerInfo_otherInfo',
      desc: '',
      args: [],
    );
  }

  /// `Sale & purchase info`
  String get partnerInfo_saleInfo {
    return Intl.message(
      'Sale & purchase info',
      name: 'partnerInfo_saleInfo',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sort {
    return Intl.message(
      'Sort',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Quotations`
  String get quotations {
    return Intl.message(
      'Quotations',
      name: 'quotations',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get quotation_selected {
    return Intl.message(
      'Selected',
      name: 'quotation_selected',
      desc: '',
      args: [],
    );
  }

  /// `Choose quotation`
  String get quotation_chooseQuotation {
    return Intl.message(
      'Choose quotation',
      name: 'quotation_chooseQuotation',
      desc: '',
      args: [],
    );
  }

  /// `Export excel`
  String get quotation_exportExcel {
    return Intl.message(
      'Export excel',
      name: 'quotation_exportExcel',
      desc: '',
      args: [],
    );
  }

  /// `Copy quotation`
  String get quotation_copyQuotation {
    return Intl.message(
      'Copy quotation',
      name: 'quotation_copyQuotation',
      desc: '',
      args: [],
    );
  }

  /// `Filter by status`
  String get quotation_filterByStatus {
    return Intl.message(
      'Filter by status',
      name: 'quotation_filterByStatus',
      desc: '',
      args: [],
    );
  }

  /// `End date`
  String get quotation_endDate {
    return Intl.message(
      'End date',
      name: 'quotation_endDate',
      desc: '',
      args: [],
    );
  }

  /// `Payment terms`
  String get quotation_paymentTerms {
    return Intl.message(
      'Payment terms',
      name: 'quotation_paymentTerms',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get quotation_note {
    return Intl.message(
      'Note',
      name: 'quotation_note',
      desc: '',
      args: [],
    );
  }

  /// `Sale information`
  String get quotation_saleInformation {
    return Intl.message(
      'Sale information',
      name: 'quotation_saleInformation',
      desc: '',
      args: [],
    );
  }

  /// `Quotation information`
  String get quotation_quotationInformation {
    return Intl.message(
      'Quotation information',
      name: 'quotation_quotationInformation',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get quotation_status {
    return Intl.message(
      'Status',
      name: 'quotation_status',
      desc: '',
      args: [],
    );
  }

  /// `Amount discount`
  String get quotation_amountDiscount {
    return Intl.message(
      'Amount discount',
      name: 'quotation_amountDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Amount total`
  String get quotation_amountTotal {
    return Intl.message(
      'Amount total',
      name: 'quotation_amountTotal',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get quotation_Products {
    return Intl.message(
      'Products',
      name: 'quotation_Products',
      desc: '',
      args: [],
    );
  }

  /// `Edit quotation`
  String get quotation_editQuotation {
    return Intl.message(
      'Edit quotation',
      name: 'quotation_editQuotation',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get quotation_save {
    return Intl.message(
      'Save',
      name: 'quotation_save',
      desc: '',
      args: [],
    );
  }

  /// `Cannot edit`
  String get quotation_cannotEdit {
    return Intl.message(
      'Cannot edit',
      name: 'quotation_cannotEdit',
      desc: '',
      args: [],
    );
  }

  /// `Add product`
  String get quotation_addProduct {
    return Intl.message(
      'Add product',
      name: 'quotation_addProduct',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get quotation_information {
    return Intl.message(
      'Information',
      name: 'quotation_information',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete quotation?`
  String get quotation_doYouWantToDeleteQuotation {
    return Intl.message(
      'Do you want to delete quotation?',
      name: 'quotation_doYouWantToDeleteQuotation',
      desc: '',
      args: [],
    );
  }

  /// `Add quotation`
  String get quotation_addQuotation {
    return Intl.message(
      'Add quotation',
      name: 'quotation_addQuotation',
      desc: '',
      args: [],
    );
  }

  /// `Partner cannot be empty!`
  String get quotation_partnerCannotBeEmpty {
    return Intl.message(
      'Partner cannot be empty!',
      name: 'quotation_partnerCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Please add product`
  String get quotation_pleaseAddProduct {
    return Intl.message(
      'Please add product',
      name: 'quotation_pleaseAddProduct',
      desc: '',
      args: [],
    );
  }

  /// `Quotation was deleted successful.`
  String get quotation_quotationWasDeletedSuccessful {
    return Intl.message(
      'Quotation was deleted successful.',
      name: 'quotation_quotationWasDeletedSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `File was saved in folder`
  String get fileWasSavedInFolder {
    return Intl.message(
      'File was saved in folder',
      name: 'fileWasSavedInFolder',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to open File?`
  String get doYouWantToOpenFile {
    return Intl.message(
      'Do you want to open File?',
      name: 'doYouWantToOpenFile',
      desc: '',
      args: [],
    );
  }

  /// `Quotation`
  String get quotation_quotation {
    return Intl.message(
      'Quotation',
      name: 'quotation_quotation',
      desc: '',
      args: [],
    );
  }

  /// `Quotation was sent`
  String get quotation_quotationWasSent {
    return Intl.message(
      'Quotation was sent',
      name: 'quotation_quotationWasSent',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get quotation_discount {
    return Intl.message(
      'Discount',
      name: 'quotation_discount',
      desc: '',
      args: [],
    );
  }

  /// `Check quotation`
  String get quotation_checkQuotation {
    return Intl.message(
      'Check quotation',
      name: 'quotation_checkQuotation',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `Open Folder`
  String get openFolder {
    return Intl.message(
      'Open Folder',
      name: 'openFolder',
      desc: '',
      args: [],
    );
  }

  /// `New session`
  String get posOfSale_NewSession {
    return Intl.message(
      'New session',
      name: 'posOfSale_NewSession',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continues {
    return Intl.message(
      'Continue',
      name: 'continues',
      desc: '',
      args: [],
    );
  }

  /// `Active type`
  String get posOfSale_activeType {
    return Intl.message(
      'Active type',
      name: 'posOfSale_activeType',
      desc: '',
      args: [],
    );
  }

  /// `Stock location`
  String get posOfSale_stockLocation {
    return Intl.message(
      'Stock location',
      name: 'posOfSale_stockLocation',
      desc: '',
      args: [],
    );
  }

  /// `Price list`
  String get posOfSale_priceList {
    return Intl.message(
      'Price list',
      name: 'posOfSale_priceList',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get posOfSale_active {
    return Intl.message(
      'Active',
      name: 'posOfSale_active',
      desc: '',
      args: [],
    );
  }

  /// `Payment type`
  String get posOfSale_paymentType {
    return Intl.message(
      'Payment type',
      name: 'posOfSale_paymentType',
      desc: '',
      args: [],
    );
  }

  /// `Printer configuration`
  String get posOfSale_printerConfiguration {
    return Intl.message(
      'Printer configuration',
      name: 'posOfSale_printerConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Auto print`
  String get posOfSale_autoPrint {
    return Intl.message(
      'Auto print',
      name: 'posOfSale_autoPrint',
      desc: '',
      args: [],
    );
  }

  /// `Discount default`
  String get posOfSale_discountDefault {
    return Intl.message(
      'Discount default',
      name: 'posOfSale_discountDefault',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get posOfSale_cart {
    return Intl.message(
      'Cart',
      name: 'posOfSale_cart',
      desc: '',
      args: [],
    );
  }

  /// `Update data`
  String get posOfSale_updateData {
    return Intl.message(
      'Update data',
      name: 'posOfSale_updateData',
      desc: '',
      args: [],
    );
  }

  /// `Print configuration`
  String get posOfSale_printConfiguration {
    return Intl.message(
      'Print configuration',
      name: 'posOfSale_printConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Close session`
  String get posOfSale_closeSession {
    return Intl.message(
      'Close session',
      name: 'posOfSale_closeSession',
      desc: '',
      args: [],
    );
  }

  /// `Edit product`
  String get posOfSale_editProduct {
    return Intl.message(
      'Edit product',
      name: 'posOfSale_editProduct',
      desc: '',
      args: [],
    );
  }

  /// `Discount fixed`
  String get posOfSale_discountFixed {
    return Intl.message(
      'Discount fixed',
      name: 'posOfSale_discountFixed',
      desc: '',
      args: [],
    );
  }

  /// `Tax`
  String get posOfSale_tax {
    return Intl.message(
      'Tax',
      name: 'posOfSale_tax',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get posOfSale_add {
    return Intl.message(
      'Add',
      name: 'posOfSale_add',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get posOfSale_payment {
    return Intl.message(
      'Payment',
      name: 'posOfSale_payment',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete product`
  String get quotation_doYouWantToDeleteProduct {
    return Intl.message(
      'Do you want to delete product',
      name: 'quotation_doYouWantToDeleteProduct',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quotation_quantity {
    return Intl.message(
      'Quantity',
      name: 'quotation_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get quotation_price {
    return Intl.message(
      'Price',
      name: 'quotation_price',
      desc: '',
      args: [],
    );
  }

  /// `Cart is Empty!`
  String get quotation_cartIsEmpty {
    return Intl.message(
      'Cart is Empty!',
      name: 'quotation_cartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Multi select`
  String get quotation_multiSelect {
    return Intl.message(
      'Multi select',
      name: 'quotation_multiSelect',
      desc: '',
      args: [],
    );
  }

  /// `Employee`
  String get quotation_employee {
    return Intl.message(
      'Employee',
      name: 'quotation_employee',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get quotation_description {
    return Intl.message(
      'Description',
      name: 'quotation_description',
      desc: '',
      args: [],
    );
  }

  /// `Choose date`
  String get quotation_chooseDate {
    return Intl.message(
      'Choose date',
      name: 'quotation_chooseDate',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get quotation_notification {
    return Intl.message(
      'Notification',
      name: 'quotation_notification',
      desc: '',
      args: [],
    );
  }

  /// `Quotation was updated successful.`
  String get quotation_quotationWasUpdatedSuccessful {
    return Intl.message(
      'Quotation was updated successful.',
      name: 'quotation_quotationWasUpdatedSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Quotation was added successful.`
  String get quotation_quotationWasAddedSuccessful {
    return Intl.message(
      'Quotation was added successful.',
      name: 'quotation_quotationWasAddedSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `There are no products`
  String get quotation_noProduct {
    return Intl.message(
      'There are no products',
      name: 'quotation_noProduct',
      desc: '',
      args: [],
    );
  }

  /// `Choose partner`
  String get quotation_choosePartner {
    return Intl.message(
      'Choose partner',
      name: 'quotation_choosePartner',
      desc: '',
      args: [],
    );
  }

  /// `Choose employee`
  String get quotation_chooseEmployee {
    return Intl.message(
      'Choose employee',
      name: 'quotation_chooseEmployee',
      desc: '',
      args: [],
    );
  }

  /// `Choose terms`
  String get quotation_chooseTerms {
    return Intl.message(
      'Choose terms',
      name: 'quotation_chooseTerms',
      desc: '',
      args: [],
    );
  }

  /// `Receipt Types`
  String get receiptType_receiptTypes {
    return Intl.message(
      'Receipt Types',
      name: 'receiptType_receiptTypes',
      desc: '',
      args: [],
    );
  }

  /// `Choose company`
  String get receiptType_chooseCompany {
    return Intl.message(
      'Choose company',
      name: 'receiptType_chooseCompany',
      desc: '',
      args: [],
    );
  }

  /// `Enter code`
  String get receiptType_enterCode {
    return Intl.message(
      'Enter code',
      name: 'receiptType_enterCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter name`
  String get receiptType_enterName {
    return Intl.message(
      'Enter name',
      name: 'receiptType_enterName',
      desc: '',
      args: [],
    );
  }

  /// `Enter note`
  String get receiptType_enterNote {
    return Intl.message(
      'Enter note',
      name: 'receiptType_enterNote',
      desc: '',
      args: [],
    );
  }

  /// `Company`
  String get receiptType_company {
    return Intl.message(
      'Company',
      name: 'receiptType_company',
      desc: '',
      args: [],
    );
  }

  /// `Edit receipt type`
  String get receiptType_editReceiptType {
    return Intl.message(
      'Edit receipt type',
      name: 'receiptType_editReceiptType',
      desc: '',
      args: [],
    );
  }

  /// `Add receipt type`
  String get receiptType_addReceiptType {
    return Intl.message(
      'Add receipt type',
      name: 'receiptType_addReceiptType',
      desc: '',
      args: [],
    );
  }

  /// `Edit payment type`
  String get paymentType_editPaymentType {
    return Intl.message(
      'Edit payment type',
      name: 'paymentType_editPaymentType',
      desc: '',
      args: [],
    );
  }

  /// `Add payment type`
  String get paymentType_addPaymentType {
    return Intl.message(
      'Add payment type',
      name: 'paymentType_addPaymentType',
      desc: '',
      args: [],
    );
  }

  /// `Payment types`
  String get paymentType_paymentTypes {
    return Intl.message(
      'Payment types',
      name: 'paymentType_paymentTypes',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this line?`
  String get deleteALine {
    return Intl.message(
      'Do you want to delete this line?',
      name: 'deleteALine',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete Receipt Type `
  String get receiptType_confirmDelete {
    return Intl.message(
      'Do you want to delete Receipt Type ',
      name: 'receiptType_confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete Payment Type `
  String get paymentType_confirmDelete {
    return Intl.message(
      'Do you want to delete Payment Type ',
      name: 'paymentType_confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Delete successful!`
  String get paymentType_deleteSuccessful {
    return Intl.message(
      'Delete successful!',
      name: 'paymentType_deleteSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Delete successful!`
  String get receiptType_deleteSuccessful {
    return Intl.message(
      'Delete successful!',
      name: 'receiptType_deleteSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Receipt type was updated successful.`
  String get receiptType_receiptTypeWasUpdatedSuccessful {
    return Intl.message(
      'Receipt type was updated successful.',
      name: 'receiptType_receiptTypeWasUpdatedSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Receipt type was added successful.`
  String get receiptType_receiptTypeWasAddedSuccessful {
    return Intl.message(
      'Receipt type was added successful.',
      name: 'receiptType_receiptTypeWasAddedSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Payment type was added successful.`
  String get paymentType_paymentTypeWasAddedSuccessful {
    return Intl.message(
      'Payment type was added successful.',
      name: 'paymentType_paymentTypeWasAddedSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Payment type was updated successful.`
  String get paymentType_paymentTypeWasUpdatedSuccessful {
    return Intl.message(
      'Payment type was updated successful.',
      name: 'paymentType_paymentTypeWasUpdatedSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Companies`
  String get receiptType_companies {
    return Intl.message(
      'Companies',
      name: 'receiptType_companies',
      desc: '',
      args: [],
    );
  }

  /// `Pos session`
  String get posSession_posSession {
    return Intl.message(
      'Pos session',
      name: 'posSession_posSession',
      desc: '',
      args: [],
    );
  }

  /// `Session`
  String get posSession_Session {
    return Intl.message(
      'Session',
      name: 'posSession_Session',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to close Session?`
  String get posSession_doYouWantToCloseSession {
    return Intl.message(
      'Do you want to close Session?',
      name: 'posSession_doYouWantToCloseSession',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete Session?`
  String get posSession_confirmDelete {
    return Intl.message(
      'Do you want to delete Session?',
      name: 'posSession_confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Close session`
  String get posSession_closeSession {
    return Intl.message(
      'Close session',
      name: 'posSession_closeSession',
      desc: '',
      args: [],
    );
  }

  /// `Payment type`
  String get posSession_paymentType {
    return Intl.message(
      'Payment type',
      name: 'posSession_paymentType',
      desc: '',
      args: [],
    );
  }

  /// `Balance start`
  String get posSession_balanceStart {
    return Intl.message(
      'Balance start',
      name: 'posSession_balanceStart',
      desc: '',
      args: [],
    );
  }

  /// `Balance end`
  String get posSession_balanceEnd {
    return Intl.message(
      'Balance end',
      name: 'posSession_balanceEnd',
      desc: '',
      args: [],
    );
  }

  /// `Difference`
  String get posSession_difference {
    return Intl.message(
      'Difference',
      name: 'posSession_difference',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get posSession_detail {
    return Intl.message(
      'Detail',
      name: 'posSession_detail',
      desc: '',
      args: [],
    );
  }

  /// `OVERVIEW`
  String get posSession_overview {
    return Intl.message(
      'OVERVIEW',
      name: 'posSession_overview',
      desc: '',
      args: [],
    );
  }

  /// `Employee`
  String get posSession_employee {
    return Intl.message(
      'Employee',
      name: 'posSession_employee',
      desc: '',
      args: [],
    );
  }

  /// `Date created`
  String get dateCreated {
    return Intl.message(
      'Date created',
      name: 'dateCreated',
      desc: '',
      args: [],
    );
  }

  /// `End date`
  String get posSession_endDate {
    return Intl.message(
      'End date',
      name: 'posSession_endDate',
      desc: '',
      args: [],
    );
  }

  /// `Open control`
  String get posSession_openControl {
    return Intl.message(
      'Open control',
      name: 'posSession_openControl',
      desc: '',
      args: [],
    );
  }

  /// `Close control`
  String get posSession_closeControl {
    return Intl.message(
      'Close control',
      name: 'posSession_closeControl',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get posSession_closed {
    return Intl.message(
      'Closed',
      name: 'posSession_closed',
      desc: '',
      args: [],
    );
  }

  /// `Amount transaction`
  String get posSession_amountTransaction {
    return Intl.message(
      'Amount transaction',
      name: 'posSession_amountTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get posSession_processing {
    return Intl.message(
      'Processing',
      name: 'posSession_processing',
      desc: '',
      args: [],
    );
  }

  /// `Invoices`
  String get posSession_invoices {
    return Intl.message(
      'Invoices',
      name: 'posSession_invoices',
      desc: '',
      args: [],
    );
  }

  /// `Payment detail`
  String get posSession_paymentDetail {
    return Intl.message(
      'Payment detail',
      name: 'posSession_paymentDetail',
      desc: '',
      args: [],
    );
  }

  /// `Empty`
  String get posSession_partnerEmpty {
    return Intl.message(
      'Empty',
      name: 'posSession_partnerEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get posSession_date {
    return Intl.message(
      'Date',
      name: 'posSession_date',
      desc: '',
      args: [],
    );
  }

  /// `Session was deleted successful.`
  String get posSession_sessionWasDelete {
    return Intl.message(
      'Session was deleted successful.',
      name: 'posSession_sessionWasDelete',
      desc: '',
      args: [],
    );
  }

  /// `Session was closed successful.`
  String get posSession_sessionWasClosed {
    return Intl.message(
      'Session was closed successful.',
      name: 'posSession_sessionWasClosed',
      desc: '',
      args: [],
    );
  }

  /// `Session was closed fail.`
  String get posSession_sessionWasClosedFail {
    return Intl.message(
      'Session was closed fail.',
      name: 'posSession_sessionWasClosedFail',
      desc: '',
      args: [],
    );
  }

  /// `Session was updated successful.`
  String get posSession_sessionWasUpdated {
    return Intl.message(
      'Session was updated successful.',
      name: 'posSession_sessionWasUpdated',
      desc: '',
      args: [],
    );
  }

  /// `You have not given permission to the app`
  String get permission {
    return Intl.message(
      'You have not given permission to the app',
      name: 'permission',
      desc: '',
      args: [],
    );
  }

  /// `There are no products in this cart`
  String get posOfSale_noProduct {
    return Intl.message(
      'There are no products in this cart',
      name: 'posOfSale_noProduct',
      desc: '',
      args: [],
    );
  }

  /// `Add product`
  String get posOfSale_addProduct {
    return Intl.message(
      'Add product',
      name: 'posOfSale_addProduct',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get posOfSale_discount {
    return Intl.message(
      'Discount',
      name: 'posOfSale_discount',
      desc: '',
      args: [],
    );
  }

  /// `Promotions`
  String get posOfSale_promotions {
    return Intl.message(
      'Promotions',
      name: 'posOfSale_promotions',
      desc: '',
      args: [],
    );
  }

  /// `Add to cart`
  String get posOfSale_addToCart {
    return Intl.message(
      'Add to cart',
      name: 'posOfSale_addToCart',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get posOfSale_quantity {
    return Intl.message(
      'Quantity',
      name: 'posOfSale_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get posOfSale_price {
    return Intl.message(
      'Price',
      name: 'posOfSale_price',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get posOfSale_notes {
    return Intl.message(
      'Notes',
      name: 'posOfSale_notes',
      desc: '',
      args: [],
    );
  }

  /// `Multi select`
  String get posOfSale_multiSelect {
    return Intl.message(
      'Multi select',
      name: 'posOfSale_multiSelect',
      desc: '',
      args: [],
    );
  }

  /// `Top sales`
  String get posOfSale_topSales {
    return Intl.message(
      'Top sales',
      name: 'posOfSale_topSales',
      desc: '',
      args: [],
    );
  }

  /// `Amount total`
  String get posOfSale_amountTotal {
    return Intl.message(
      'Amount total',
      name: 'posOfSale_amountTotal',
      desc: '',
      args: [],
    );
  }

  /// `Amount before tax`
  String get posOfSale_amountBeforeTax {
    return Intl.message(
      'Amount before tax',
      name: 'posOfSale_amountBeforeTax',
      desc: '',
      args: [],
    );
  }

  /// `Create invoice`
  String get posOfSale_createInvoice {
    return Intl.message(
      'Create invoice',
      name: 'posOfSale_createInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Allows customers to debit and pay later`
  String get posOfSale_allowDebit {
    return Intl.message(
      'Allows customers to debit and pay later',
      name: 'posOfSale_allowDebit',
      desc: '',
      args: [],
    );
  }

  /// `Payment total`
  String get posOfSale_totalPayment {
    return Intl.message(
      'Payment total',
      name: 'posOfSale_totalPayment',
      desc: '',
      args: [],
    );
  }

  /// `Debt`
  String get posOfSale_debt {
    return Intl.message(
      'Debt',
      name: 'posOfSale_debt',
      desc: '',
      args: [],
    );
  }

  /// `Amount return`
  String get posOfSale_amountReturn {
    return Intl.message(
      'Amount return',
      name: 'posOfSale_amountReturn',
      desc: '',
      args: [],
    );
  }

  /// `Invoices`
  String get posOfSale_invoices {
    return Intl.message(
      'Invoices',
      name: 'posOfSale_invoices',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get posOfSale_print {
    return Intl.message(
      'Print',
      name: 'posOfSale_print',
      desc: '',
      args: [],
    );
  }

  /// `Returns`
  String get posOfSale_returns {
    return Intl.message(
      'Returns',
      name: 'posOfSale_returns',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to close pos of sale?`
  String get posOfSale_closePosOfSale {
    return Intl.message(
      'Do you want to close pos of sale?',
      name: 'posOfSale_closePosOfSale',
      desc: '',
      args: [],
    );
  }

  /// `Auto move to the next order`
  String get posOfSale_autoMoveToTheNextOrder {
    return Intl.message(
      'Auto move to the next order',
      name: 'posOfSale_autoMoveToTheNextOrder',
      desc: '',
      args: [],
    );
  }

  /// `Auto fill in the correct payment amount with the remaining amount`
  String get posOfSale_autoFillIn {
    return Intl.message(
      'Auto fill in the correct payment amount with the remaining amount',
      name: 'posOfSale_autoFillIn',
      desc: '',
      args: [],
    );
  }

  /// `Allow notes on sales details`
  String get posOfSale_allowNotes {
    return Intl.message(
      'Allow notes on sales details',
      name: 'posOfSale_allowNotes',
      desc: '',
      args: [],
    );
  }

  /// `Quick download of product list`
  String get posOfSale_quickDownload {
    return Intl.message(
      'Quick download of product list',
      name: 'posOfSale_quickDownload',
      desc: '',
      args: [],
    );
  }

  /// `Allow discount on the entire order`
  String get posOfSale_allowDiscount {
    return Intl.message(
      'Allow discount on the entire order',
      name: 'posOfSale_allowDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Allow discounts fixed on the entire order`
  String get posOfSale_allowDiscountFixed {
    return Intl.message(
      'Allow discounts fixed on the entire order',
      name: 'posOfSale_allowDiscountFixed',
      desc: '',
      args: [],
    );
  }

  /// `Apply to tax on the entire order`
  String get posOfSale_applyToTax {
    return Intl.message(
      'Apply to tax on the entire order',
      name: 'posOfSale_applyToTax',
      desc: '',
      args: [],
    );
  }

  /// `Invoice and Receipts`
  String get posOfSale_invoiceAndReceipts {
    return Intl.message(
      'Invoice and Receipts',
      name: 'posOfSale_invoiceAndReceipts',
      desc: '',
      args: [],
    );
  }

  /// `Add messages to headers and footers`
  String get posOfSale_addMessages {
    return Intl.message(
      'Add messages to headers and footers',
      name: 'posOfSale_addMessages',
      desc: '',
      args: [],
    );
  }

  /// `Show logo`
  String get posOfSale_showLogo {
    return Intl.message(
      'Show logo',
      name: 'posOfSale_showLogo',
      desc: '',
      args: [],
    );
  }

  /// `Cash control`
  String get posOfSale_cashControl {
    return Intl.message(
      'Cash control',
      name: 'posOfSale_cashControl',
      desc: '',
      args: [],
    );
  }

  /// `Feature`
  String get posOfSale_feature {
    return Intl.message(
      'Feature',
      name: 'posOfSale_feature',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete product`
  String get posOfSale_confirmDeleteProduct {
    return Intl.message(
      'Do you want to delete product',
      name: 'posOfSale_confirmDeleteProduct',
      desc: '',
      args: [],
    );
  }

  /// `Unit`
  String get unit {
    return Intl.message(
      'Unit',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `Enter amount`
  String get posOfSale_enterAmount {
    return Intl.message(
      'Enter amount',
      name: 'posOfSale_enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Partner cannot be empty!`
  String get posOfSale_partnerIsNotEmpty {
    return Intl.message(
      'Partner cannot be empty!',
      name: 'posOfSale_partnerIsNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Print error`
  String get posOfSale_printError {
    return Intl.message(
      'Print error',
      name: 'posOfSale_printError',
      desc: '',
      args: [],
    );
  }

  /// `Payment successful`
  String get posOfSale_paymentSuccessful {
    return Intl.message(
      'Payment successful',
      name: 'posOfSale_paymentSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Payment failed`
  String get posOfSale_paymentFailed {
    return Intl.message(
      'Payment failed',
      name: 'posOfSale_paymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to returns?`
  String get posOfSale_confirmReturn {
    return Intl.message(
      'Do you want to returns?',
      name: 'posOfSale_confirmReturn',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to copy?`
  String get posOfSale_confirmCopy {
    return Intl.message(
      'Do you want to copy?',
      name: 'posOfSale_confirmCopy',
      desc: '',
      args: [],
    );
  }

  /// `Successful!`
  String get posOfSale_successful {
    return Intl.message(
      'Successful!',
      name: 'posOfSale_successful',
      desc: '',
      args: [],
    );
  }

  /// `Failed!`
  String get posOfSale_failed {
    return Intl.message(
      'Failed!',
      name: 'posOfSale_failed',
      desc: '',
      args: [],
    );
  }

  /// `Tax default`
  String get posOfSale_taxDefault {
    return Intl.message(
      'Tax default',
      name: 'posOfSale_taxDefault',
      desc: '',
      args: [],
    );
  }

  /// `Information can be delete. Do you want to close?`
  String get posOfSale_confirmBackProduct {
    return Intl.message(
      'Information can be delete. Do you want to close?',
      name: 'posOfSale_confirmBackProduct',
      desc: '',
      args: [],
    );
  }

  /// `Add partner`
  String get posOfSale_addPartner {
    return Intl.message(
      'Add partner',
      name: 'posOfSale_addPartner',
      desc: '',
      args: [],
    );
  }

  /// `Edit partner`
  String get posOfSale_editPartner {
    return Intl.message(
      'Edit partner',
      name: 'posOfSale_editPartner',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Barcode`
  String get posOfSale_barCode {
    return Intl.message(
      'Barcode',
      name: 'posOfSale_barCode',
      desc: '',
      args: [],
    );
  }

  /// `Tax code`
  String get posOfSale_taxCode {
    return Intl.message(
      'Tax code',
      name: 'posOfSale_taxCode',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get posOfSale_address {
    return Intl.message(
      'Address',
      name: 'posOfSale_address',
      desc: '',
      args: [],
    );
  }

  /// `Choose from Camera`
  String get posOfSale_chooseFromCamera {
    return Intl.message(
      'Choose from Camera',
      name: 'posOfSale_chooseFromCamera',
      desc: '',
      args: [],
    );
  }

  /// `Choose from Gallery`
  String get posOfSale_chooseFromGallery {
    return Intl.message(
      'Choose from Gallery',
      name: 'posOfSale_chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Partner name cannot be empty!`
  String get posOfSale_partnerNameNotEmpty {
    return Intl.message(
      'Partner name cannot be empty!',
      name: 'posOfSale_partnerNameNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Partner information`
  String get posOfSale_partnerInfo {
    return Intl.message(
      'Partner information',
      name: 'posOfSale_partnerInfo',
      desc: '',
      args: [],
    );
  }

  /// `Partners`
  String get posOfSale_partners {
    return Intl.message(
      'Partners',
      name: 'posOfSale_partners',
      desc: '',
      args: [],
    );
  }

  /// `UnSelect tax`
  String get posOfSale_unSelectTax {
    return Intl.message(
      'UnSelect tax',
      name: 'posOfSale_unSelectTax',
      desc: '',
      args: [],
    );
  }

  /// `Default`
  String get posOfSale_default {
    return Intl.message(
      'Default',
      name: 'posOfSale_default',
      desc: '',
      args: [],
    );
  }

  /// `By name`
  String get posOfSale_byName {
    return Intl.message(
      'By name',
      name: 'posOfSale_byName',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to close this page?`
  String get posOfSale_closePage {
    return Intl.message(
      'Do you want to close this page?',
      name: 'posOfSale_closePage',
      desc: '',
      args: [],
    );
  }

  /// `Edit pos of sale`
  String get posOfSale_editPosOfSale {
    return Intl.message(
      'Edit pos of sale',
      name: 'posOfSale_editPosOfSale',
      desc: '',
      args: [],
    );
  }

  /// `Header`
  String get posOfSale_header {
    return Intl.message(
      'Header',
      name: 'posOfSale_header',
      desc: '',
      args: [],
    );
  }

  /// `Footer`
  String get posOfSale_footer {
    return Intl.message(
      'Footer',
      name: 'posOfSale_footer',
      desc: '',
      args: [],
    );
  }

  /// `Information was updated successful.`
  String get posOfSale_inforUpdateSuccess {
    return Intl.message(
      'Information was updated successful.',
      name: 'posOfSale_inforUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Information was updated fail.`
  String get posOfSale_inforUpdateFail {
    return Intl.message(
      'Information was updated fail.',
      name: 'posOfSale_inforUpdateFail',
      desc: '',
      args: [],
    );
  }

  /// `Product was deleted successful`
  String get posOfSale_deleteProduct {
    return Intl.message(
      'Product was deleted successful',
      name: 'posOfSale_deleteProduct',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to save orders in old session?`
  String get posOfSale_notifySaveOrder {
    return Intl.message(
      'Do you want to save orders in old session?',
      name: 'posOfSale_notifySaveOrder',
      desc: '',
      args: [],
    );
  }

  /// `You cannot create two sessions with ?`
  String get posOfSale_errCreateSession {
    return Intl.message(
      'You cannot create two sessions with ?',
      name: 'posOfSale_errCreateSession',
      desc: '',
      args: [],
    );
  }

  /// `Products will be delete. If you delete cart`
  String get posOfSale_confirmDeleteCart {
    return Intl.message(
      'Products will be delete. If you delete cart',
      name: 'posOfSale_confirmDeleteCart',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Cash Receipts`
  String get receipts_receipts {
    return Intl.message(
      'Cash Receipts',
      name: 'receipts_receipts',
      desc: '',
      args: [],
    );
  }

  /// `Receipt type`
  String get receipts_receiptsType {
    return Intl.message(
      'Receipt type',
      name: 'receipts_receiptsType',
      desc: '',
      args: [],
    );
  }

  /// `Payment type`
  String get receipts_paymentType {
    return Intl.message(
      'Payment type',
      name: 'receipts_paymentType',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get receipts_date {
    return Intl.message(
      'Date',
      name: 'receipts_date',
      desc: '',
      args: [],
    );
  }

  /// `Sender`
  String get receipts_sender {
    return Intl.message(
      'Sender',
      name: 'receipts_sender',
      desc: '',
      args: [],
    );
  }

  /// `Filter by receipt type`
  String get receipts_filterByReceipts {
    return Intl.message(
      'Filter by receipt type',
      name: 'receipts_filterByReceipts',
      desc: '',
      args: [],
    );
  }

  /// `Filter by status`
  String get filterByStatus {
    return Intl.message(
      'Filter by status',
      name: 'filterByStatus',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete receipt`
  String get receiptType_doYouWantDeleteReceipt {
    return Intl.message(
      'Do you want to delete receipt',
      name: 'receiptType_doYouWantDeleteReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Receipt was delete successful`
  String get receipts_deleteSuccessful {
    return Intl.message(
      'Receipt was delete successful',
      name: 'receipts_deleteSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Receipt was delete successful`
  String get receipts_deleteSuccessFul {
    return Intl.message(
      'Receipt was delete successful',
      name: 'receipts_deleteSuccessFul',
      desc: '',
      args: [],
    );
  }

  /// `Receipt has been added to the book. You cannot delete`
  String get receipts_cannotDeleteReceipt {
    return Intl.message(
      'Receipt has been added to the book. You cannot delete',
      name: 'receipts_cannotDeleteReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get draft {
    return Intl.message(
      'Draft',
      name: 'draft',
      desc: '',
      args: [],
    );
  }

  /// `Please enter date`
  String get receipts_pleaseEnterDate {
    return Intl.message(
      'Please enter date',
      name: 'receipts_pleaseEnterDate',
      desc: '',
      args: [],
    );
  }

  /// `Choose date`
  String get receipts_chooseDate {
    return Intl.message(
      'Choose date',
      name: 'receipts_chooseDate',
      desc: '',
      args: [],
    );
  }

  /// `Edit receipt`
  String get receipts_editReceipt {
    return Intl.message(
      'Edit receipt',
      name: 'receipts_editReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Add receipt`
  String get receipts_addReceipt {
    return Intl.message(
      'Add receipt',
      name: 'receipts_addReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to cancel Receipt?`
  String get receipts_cancelReceipt {
    return Intl.message(
      'Do you want to cancel Receipt?',
      name: 'receipts_cancelReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to add this receipt to the book?`
  String get receipts_confirmReceipt {
    return Intl.message(
      'Do you want to add this receipt to the book?',
      name: 'receipts_confirmReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get receipts_cancel {
    return Intl.message(
      'Cancel',
      name: 'receipts_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Receipt type and Payment type cannot be empty!`
  String get receipts_notifyAddEdit {
    return Intl.message(
      'Receipt type and Payment type cannot be empty!',
      name: 'receipts_notifyAddEdit',
      desc: '',
      args: [],
    );
  }

  /// `Export excel`
  String get export_excel {
    return Intl.message(
      'Export excel',
      name: 'export_excel',
      desc: '',
      args: [],
    );
  }

  /// `Payment receipts`
  String get paymentReceipt_paymentReceipts {
    return Intl.message(
      'Payment receipts',
      name: 'paymentReceipt_paymentReceipts',
      desc: '',
      args: [],
    );
  }

  /// `Payment receipt type`
  String get paymentReceipt_paymentReceiptType {
    return Intl.message(
      'Payment receipt type',
      name: 'paymentReceipt_paymentReceiptType',
      desc: '',
      args: [],
    );
  }

  /// `Filter by payment receipt type`
  String get paymentReceipt_filterByPaymentReceiptType {
    return Intl.message(
      'Filter by payment receipt type',
      name: 'paymentReceipt_filterByPaymentReceiptType',
      desc: '',
      args: [],
    );
  }

  /// `Receipt information`
  String get receipts_receiptInformation {
    return Intl.message(
      'Receipt information',
      name: 'receipts_receiptInformation',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete payment receipt`
  String get paymentReceipt_doYouWantToDeletePaymentReceipt {
    return Intl.message(
      'Do you want to delete payment receipt',
      name: 'paymentReceipt_doYouWantToDeletePaymentReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Payment receipt has been added to the book.You cannot delete`
  String get paymentReceipt_errorConfirmPaymentReceipt {
    return Intl.message(
      'Payment receipt has been added to the book.You cannot delete',
      name: 'paymentReceipt_errorConfirmPaymentReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Has entered the book`
  String get hasEnteredTheBook {
    return Intl.message(
      'Has entered the book',
      name: 'hasEnteredTheBook',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the date`
  String get paymentReceipt_pleaseEnterTheDate {
    return Intl.message(
      'Please enter the date',
      name: 'paymentReceipt_pleaseEnterTheDate',
      desc: '',
      args: [],
    );
  }

  /// `Payment receipt information`
  String get paymentReceipt_paymentReceiptInformation {
    return Intl.message(
      'Payment receipt information',
      name: 'paymentReceipt_paymentReceiptInformation',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to add to the book?`
  String get paymentReceipt_doYouWantToAddToTheBook {
    return Intl.message(
      'Do you want to add to the book?',
      name: 'paymentReceipt_doYouWantToAddToTheBook',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to cancel?`
  String get paymentReceipt_doYouWantToCancel {
    return Intl.message(
      'Do you want to cancel?',
      name: 'paymentReceipt_doYouWantToCancel',
      desc: '',
      args: [],
    );
  }

  /// `Content`
  String get content {
    return Intl.message(
      'Content',
      name: 'content',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Receiver`
  String get paymentReceipt_receiver {
    return Intl.message(
      'Receiver',
      name: 'paymentReceipt_receiver',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Contacts`
  String get contacts {
    return Intl.message(
      'Contacts',
      name: 'contacts',
      desc: '',
      args: [],
    );
  }

  /// `Add contact`
  String get addContact {
    return Intl.message(
      'Add contact',
      name: 'addContact',
      desc: '',
      args: [],
    );
  }

  /// `Contact was added successful`
  String get contact_addSuccess {
    return Intl.message(
      'Contact was added successful',
      name: 'contact_addSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Contact name cannot be empty!`
  String get receipts_contactIsEmpty {
    return Intl.message(
      'Contact name cannot be empty!',
      name: 'receipts_contactIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Edit payment receipt`
  String get paymentReceipt_edit {
    return Intl.message(
      'Edit payment receipt',
      name: 'paymentReceipt_edit',
      desc: '',
      args: [],
    );
  }

  /// `Add payment receipt`
  String get paymentReceipt_add {
    return Intl.message(
      'Add payment receipt',
      name: 'paymentReceipt_add',
      desc: '',
      args: [],
    );
  }

  /// `Payment receipt and Payment type cannot be empty.`
  String get paymentReceipt_notifyAddEdit {
    return Intl.message(
      'Payment receipt and Payment type cannot be empty.',
      name: 'paymentReceipt_notifyAddEdit',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Choose date`
  String get chooseDate {
    return Intl.message(
      'Choose date',
      name: 'chooseDate',
      desc: '',
      args: [],
    );
  }

  /// `Update successfully`
  String get updateSuccessful {
    return Intl.message(
      'Update successfully',
      name: 'updateSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Add successfully`
  String get addSuccessful {
    return Intl.message(
      'Add successfully',
      name: 'addSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Delete successfully`
  String get deleteSuccessful {
    return Intl.message(
      'Delete successfully',
      name: 'deleteSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to close?`
  String get confirmClose {
    return Intl.message(
      'Do you want to close?',
      name: 'confirmClose',
      desc: '',
      args: [],
    );
  }

  /// `Data is empty`
  String get noData {
    return Intl.message(
      'Data is empty',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Campaigns`
  String get liveCampaigns {
    return Intl.message(
      'Campaigns',
      name: 'liveCampaigns',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get liveCampaign_active {
    return Intl.message(
      'Active',
      name: 'liveCampaign_active',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get liveCampaign_allowActive {
    return Intl.message(
      'Active',
      name: 'liveCampaign_allowActive',
      desc: '',
      args: [],
    );
  }

  /// `New campaign`
  String get liveCampaign_newCampaign {
    return Intl.message(
      'New campaign',
      name: 'liveCampaign_newCampaign',
      desc: '',
      args: [],
    );
  }

  /// `Edit campaign`
  String get liveCampaign_editCampaign {
    return Intl.message(
      'Edit campaign',
      name: 'liveCampaign_editCampaign',
      desc: '',
      args: [],
    );
  }

  /// `There are no campaigns`
  String get liveCampaign_noCampaign {
    return Intl.message(
      'There are no campaigns',
      name: 'liveCampaign_noCampaign',
      desc: '',
      args: [],
    );
  }

  /// `There are no notes`
  String get liveCampaign_noNote {
    return Intl.message(
      'There are no notes',
      name: 'liveCampaign_noNote',
      desc: '',
      args: [],
    );
  }

  /// `Live streamed by `
  String get liveCampaign_liveStreamedBy {
    return Intl.message(
      'Live streamed by ',
      name: 'liveCampaign_liveStreamedBy',
      desc: '',
      args: [],
    );
  }

  /// `Campaign was added successfully`
  String get liveCampaign_addSuccess {
    return Intl.message(
      'Campaign was added successfully',
      name: 'liveCampaign_addSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Campaign was edited successfully`
  String get liveCampaign_editSuccess {
    return Intl.message(
      'Campaign was edited successfully',
      name: 'liveCampaign_editSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Campaign was edited failure`
  String get liveCampaign_editFailed {
    return Intl.message(
      'Campaign was edited failure',
      name: 'liveCampaign_editFailed',
      desc: '',
      args: [],
    );
  }

  /// `Save data failed`
  String get liveCampaign_saveFailed {
    return Intl.message(
      'Save data failed',
      name: 'liveCampaign_saveFailed',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete product`
  String get liveCampaign_deleteProduct {
    return Intl.message(
      'Do you want to delete product',
      name: 'liveCampaign_deleteProduct',
      desc: '',
      args: [],
    );
  }

  /// `There are no products`
  String get liveCampaign_noProduct {
    return Intl.message(
      'There are no products',
      name: 'liveCampaign_noProduct',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete order `
  String get purchaseOrder_deleteOrder {
    return Intl.message(
      'Do you want to delete order ',
      name: 'purchaseOrder_deleteOrder',
      desc: '',
      args: [],
    );
  }

  /// `Purchase order was deleted successfully`
  String get purchaseOrder_deleteSuccess {
    return Intl.message(
      'Purchase order was deleted successfully',
      name: 'purchaseOrder_deleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Purchase order information`
  String get purchaseOrder_orderInfo {
    return Intl.message(
      'Purchase order information',
      name: 'purchaseOrder_orderInfo',
      desc: '',
      args: [],
    );
  }

  /// `Purchase order was canceled`
  String get purchaseOrder_cancelPurchase {
    return Intl.message(
      'Purchase order was canceled',
      name: 'purchaseOrder_cancelPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Create invoice`
  String get purchaseOrder_createInvoice {
    return Intl.message(
      'Create invoice',
      name: 'purchaseOrder_createInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to confirm this order?`
  String get purchaseOrder_confirmOrder {
    return Intl.message(
      'Do you want to confirm this order?',
      name: 'purchaseOrder_confirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to copy this order?`
  String get purchaseOrder_confirmCopy {
    return Intl.message(
      'Do you want to copy this order?',
      name: 'purchaseOrder_confirmCopy',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get purchaseOrder_cancel {
    return Intl.message(
      'Cancel',
      name: 'purchaseOrder_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to cancel this order?`
  String get purchaseOrder_confirmCancel {
    return Intl.message(
      'Do you want to cancel this order?',
      name: 'purchaseOrder_confirmCancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm order`
  String get purchaseOrder_order {
    return Intl.message(
      'Confirm order',
      name: 'purchaseOrder_order',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get purchaseOrder_name {
    return Intl.message(
      'Name',
      name: 'purchaseOrder_name',
      desc: '',
      args: [],
    );
  }

  /// `Date warning`
  String get purchaseOrder_dateWarning {
    return Intl.message(
      'Date warning',
      name: 'purchaseOrder_dateWarning',
      desc: '',
      args: [],
    );
  }

  /// `Employee`
  String get purchaseOrder_employee {
    return Intl.message(
      'Employee',
      name: 'purchaseOrder_employee',
      desc: '',
      args: [],
    );
  }

  /// `Order was confirmed`
  String get purchaseOrder_orderConfirmed {
    return Intl.message(
      'Order was confirmed',
      name: 'purchaseOrder_orderConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Purchase order cannot confirm`
  String get purchaseOrder_cannotConfirm {
    return Intl.message(
      'Purchase order cannot confirm',
      name: 'purchaseOrder_cannotConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Add one or multi products to continue`
  String get purchaseOrder_addProduct {
    return Intl.message(
      'Add one or multi products to continue',
      name: 'purchaseOrder_addProduct',
      desc: '',
      args: [],
    );
  }

  /// `You need tp choose a partner`
  String get purchaseOrder_choosePartner {
    return Intl.message(
      'You need tp choose a partner',
      name: 'purchaseOrder_choosePartner',
      desc: '',
      args: [],
    );
  }

  /// `Partner is empty`
  String get purchaseOrder_partnerEmpty {
    return Intl.message(
      'Partner is empty',
      name: 'purchaseOrder_partnerEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to save this order?`
  String get purchaseOrder_confirmSaveOrder {
    return Intl.message(
      'Do you want to save this order?',
      name: 'purchaseOrder_confirmSaveOrder',
      desc: '',
      args: [],
    );
  }

  /// `Add purchase order`
  String get purchaseOrder_addPurchaseOrder {
    return Intl.message(
      'Add purchase order',
      name: 'purchaseOrder_addPurchaseOrder',
      desc: '',
      args: [],
    );
  }

  /// `Order have been confirmed. Only edit notes`
  String get purchaseOrder_notifyCannotEdit {
    return Intl.message(
      'Order have been confirmed. Only edit notes',
      name: 'purchaseOrder_notifyCannotEdit',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get purchaseOrder_change {
    return Intl.message(
      'Change',
      name: 'purchaseOrder_change',
      desc: '',
      args: [],
    );
  }

  /// `Other information`
  String get purchaseOrder_otherInfo {
    return Intl.message(
      'Other information',
      name: 'purchaseOrder_otherInfo',
      desc: '',
      args: [],
    );
  }

  /// `Date invoice`
  String get purchaseOrder_dateInvoice {
    return Intl.message(
      'Date invoice',
      name: 'purchaseOrder_dateInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Edit information`
  String get purchaseOrder_editInfo {
    return Intl.message(
      'Edit information',
      name: 'purchaseOrder_editInfo',
      desc: '',
      args: [],
    );
  }

  /// `Amount deposit`
  String get purchaseOrder_amountDeposit {
    return Intl.message(
      'Amount deposit',
      name: 'purchaseOrder_amountDeposit',
      desc: '',
      args: [],
    );
  }

  /// `There are no products. Press "Search products" to add`
  String get purchaseOrder_pressToAddProduct {
    return Intl.message(
      'There are no products. Press "Search products" to add',
      name: 'purchaseOrder_pressToAddProduct',
      desc: '',
      args: [],
    );
  }

  /// `Reduce`
  String get purchaseOrder_reduce {
    return Intl.message(
      'Reduce',
      name: 'purchaseOrder_reduce',
      desc: '',
      args: [],
    );
  }

  /// `Get partner information`
  String get purchaseOrder_getPartnerInfo {
    return Intl.message(
      'Get partner information',
      name: 'purchaseOrder_getPartnerInfo',
      desc: '',
      args: [],
    );
  }

  /// `existed`
  String get purchaseOrder_existed {
    return Intl.message(
      'existed',
      name: 'purchaseOrder_existed',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to add a new line.`
  String get purchaseOrder_addANewLine {
    return Intl.message(
      'Do you want to add a new line.',
      name: 'purchaseOrder_addANewLine',
      desc: '',
      args: [],
    );
  }

  /// `Filter condition`
  String get filterCondition {
    return Intl.message(
      'Filter condition',
      name: 'filterCondition',
      desc: '',
      args: [],
    );
  }

  /// `Filter by time`
  String get filterByTime {
    return Intl.message(
      'Filter by time',
      name: 'filterByTime',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Exception`
  String get exception {
    return Intl.message(
      'Exception',
      name: 'exception',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get processing {
    return Intl.message(
      'Processing',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `There are no products`
  String get noProduct {
    return Intl.message(
      'There are no products',
      name: 'noProduct',
      desc: '',
      args: [],
    );
  }

  /// `Search products`
  String get searchProduct {
    return Intl.message(
      'Search products',
      name: 'searchProduct',
      desc: '',
      args: [],
    );
  }

  /// `Access Settings-> App-> Tpos Mobile and Allow use camera`
  String get settingPermission {
    return Intl.message(
      'Access Settings-> App-> Tpos Mobile and Allow use camera',
      name: 'settingPermission',
      desc: '',
      args: [],
    );
  }

  /// `Please try to again!`
  String get pleaseTryToAgain {
    return Intl.message(
      'Please try to again!',
      name: 'pleaseTryToAgain',
      desc: '',
      args: [],
    );
  }

  /// `Choose partner`
  String get choosePartner {
    return Intl.message(
      'Choose partner',
      name: 'choosePartner',
      desc: '',
      args: [],
    );
  }

  /// `7 days ago`
  String get filter_7daysAgo {
    return Intl.message(
      '7 days ago',
      name: 'filter_7daysAgo',
      desc: '',
      args: [],
    );
  }

  /// `30 days ago`
  String get filter_30daysAgo {
    return Intl.message(
      '30 days ago',
      name: 'filter_30daysAgo',
      desc: '',
      args: [],
    );
  }

  /// `Full time`
  String get filter_fullTime {
    return Intl.message(
      'Full time',
      name: 'filter_fullTime',
      desc: '',
      args: [],
    );
  }

  /// `Scan barcode failed.`
  String get purchaseOrder_scanBarcodeFailed {
    return Intl.message(
      'Scan barcode failed.',
      name: 'purchaseOrder_scanBarcodeFailed',
      desc: '',
      args: [],
    );
  }

  /// `Add product failed!.`
  String get purchaseOrder_addProductFailed {
    return Intl.message(
      'Add product failed!.',
      name: 'purchaseOrder_addProductFailed',
      desc: '',
      args: [],
    );
  }

  /// `Not eligible to create an invoice`
  String get purchaseOrder_cannotCreateInvoice {
    return Intl.message(
      'Not eligible to create an invoice',
      name: 'purchaseOrder_cannotCreateInvoice',
      desc: '',
      args: [],
    );
  }

  /// `must have data.`
  String get purchaseOrder_mustHaveData {
    return Intl.message(
      'must have data.',
      name: 'purchaseOrder_mustHaveData',
      desc: '',
      args: [],
    );
  }

  /// `Purchase order was saved`
  String get purchaseOrder_orderSaved {
    return Intl.message(
      'Purchase order was saved',
      name: 'purchaseOrder_orderSaved',
      desc: '',
      args: [],
    );
  }

  /// `Save order failed.`
  String get purchaseOrder_orderSaveFailed {
    return Intl.message(
      'Save order failed.',
      name: 'purchaseOrder_orderSaveFailed',
      desc: '',
      args: [],
    );
  }

  /// `Cannot confirm order.`
  String get purchaseOrder_cannotConfirmOrder {
    return Intl.message(
      'Cannot confirm order.',
      name: 'purchaseOrder_cannotConfirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `Confirm purchase order failed!`
  String get purchaseOrder_confirmOrderFailed {
    return Intl.message(
      'Confirm purchase order failed!',
      name: 'purchaseOrder_confirmOrderFailed',
      desc: '',
      args: [],
    );
  }

  /// `Saving`
  String get saving {
    return Intl.message(
      'Saving',
      name: 'saving',
      desc: '',
      args: [],
    );
  }

  /// `Back to order`
  String get backToOrder {
    return Intl.message(
      'Back to order',
      name: 'backToOrder',
      desc: '',
      args: [],
    );
  }

  /// `Choose employee`
  String get purchaseOrder_chooseEmployee {
    return Intl.message(
      'Choose employee',
      name: 'purchaseOrder_chooseEmployee',
      desc: '',
      args: [],
    );
  }

  /// `No warnings`
  String get noWarnings {
    return Intl.message(
      'No warnings',
      name: 'noWarnings',
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