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

  /// `Sort`
  String get sort {
    return Intl.message(
      'Sort',
      name: 'sort',
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

  /// `Total amount`
  String get totalAmount {
    return Intl.message(
      'Total amount',
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

  /// `Filter by status`
  String get filterByStatus {
    return Intl.message(
      'Filter by status',
      name: 'filterByStatus',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete this line?`
  String get deleteLine {
    return Intl.message(
      'Do you want to delete this line?',
      name: 'deleteLine',
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

  /// `Please enter the date`
  String get paymentReceipt_pleaseEnterTheDate {
    return Intl.message(
      'Please enter the date',
      name: 'paymentReceipt_pleaseEnterTheDate',
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

  /// `Payment receipt information`
  String get paymentReceipt_paymentReceiptInformation {
    return Intl.message(
      'Payment receipt information',
      name: 'paymentReceipt_paymentReceiptInformation',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to add to the book`
  String get paymentReceipt_doYouWantToAddToTheBook {
    return Intl.message(
      'Do you want to add to the book',
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

  /// `Export Excel`
  String get exportExcel {
    return Intl.message(
      'Export Excel',
      name: 'exportExcel',
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