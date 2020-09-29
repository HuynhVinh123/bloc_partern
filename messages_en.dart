// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(hotline) => "Hotline${hotline}";

  static m1(expiredDay) =>
      "Your account has only ${expiredDay} to expire. Please renew soon";

  static m2(channelId) =>
      "The facebook sale channel (${channelId}) already exists.";

  final messages = _notInlinedMessages(_notInlinedMessages);

  static _notInlinedMessages(_) => <String, Function>{
        "aboutApplication": MessageLookupByLibrary.simpleMessage("About"),
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "addNewPage": MessageLookupByLibrary.simpleMessage("Add new page"),
        "appTitle":
            MessageLookupByLibrary.simpleMessage("TPOS Sale Management"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "checkForUpdate":
            MessageLookupByLibrary.simpleMessage("Check for update"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "config_SaleOnlineSetting":
            MessageLookupByLibrary.simpleMessage("Sale online settings"),
        "config_SaleSettings":
            MessageLookupByLibrary.simpleMessage("Sale settings"),
        "config_printers": MessageLookupByLibrary.simpleMessage("Printers"),
        "connectedChannel":
            MessageLookupByLibrary.simpleMessage("ConnectedChannel"),
        "createFastSaleOrder":
            MessageLookupByLibrary.simpleMessage("Create new sale order"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deliverySaleOrders":
            MessageLookupByLibrary.simpleMessage("Delivery sale orders"),
        "dialogActionOk": MessageLookupByLibrary.simpleMessage("Đồng ý"),
        "dialogValidateFail": MessageLookupByLibrary.simpleMessage(
            "Required field have not been entered"),
        "dialog_canNotConnectToServer": MessageLookupByLibrary.simpleMessage(
            "Không thể kết nối tới máy chủ"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "facebookChannel":
            MessageLookupByLibrary.simpleMessage("Facebook channel"),
        "facebookOrder": MessageLookupByLibrary.simpleMessage("Facebook Order"),
        "function": MessageLookupByLibrary.simpleMessage("Function"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "homePage": MessageLookupByLibrary.simpleMessage("Home page"),
        "hotline": m0,
        "introPage_loginButtonTitle":
            MessageLookupByLibrary.simpleMessage("Login"),
        "introPage_page1Description": MessageLookupByLibrary.simpleMessage(
            "Selling at stores and selling online via Facebook..."),
        "introPage_page1Title":
            MessageLookupByLibrary.simpleMessage("Comprehensive management"),
        "introPage_page2Description": MessageLookupByLibrary.simpleMessage(
            "Push order directly to multiple delivery carrier linked to TPOS App"),
        "introPage_page2Title": MessageLookupByLibrary.simpleMessage(
            "Connect 12+ delivery partners"),
        "introPage_page3Description": MessageLookupByLibrary.simpleMessage(
            "Clear revenue and profit report helps shop owners manage cash flow effectively"),
        "introPage_page3Title":
            MessageLookupByLibrary.simpleMessage("Full report"),
        "introPage_registerButtonTitle":
            MessageLookupByLibrary.simpleMessage("Register"),
        "liveCampaign": MessageLookupByLibrary.simpleMessage("Live Campaign"),
        "loadMore": MessageLookupByLibrary.simpleMessage("Load more"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginFacebook": MessageLookupByLibrary.simpleMessage("Login facebook"),
        "loginPage_loginButtonTitle":
            MessageLookupByLibrary.simpleMessage("Đăng nhập"),
        "loginPage_loginFailTitle":
            MessageLookupByLibrary.simpleMessage("Authentication failed"),
        "loginPage_registerButtonTitle": MessageLookupByLibrary.simpleMessage(
            "Dont\'t have account? Sign up now"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "menuGroupType_category":
            MessageLookupByLibrary.simpleMessage("Categories"),
        "menuGroupType_fastSaleOrder":
            MessageLookupByLibrary.simpleMessage("Fast sale"),
        "menuGroupType_inventory":
            MessageLookupByLibrary.simpleMessage("Warehouse"),
        "menuGroupType_posOrder":
            MessageLookupByLibrary.simpleMessage("Pos of sale"),
        "menuGroupType_saleOnline":
            MessageLookupByLibrary.simpleMessage("Sale online"),
        "menuGroupType_setting":
            MessageLookupByLibrary.simpleMessage("Settings"),
        "menu_CloseOrderLivestram":
            MessageLookupByLibrary.simpleMessage("Close the order"),
        "menu_FacebookSaleChannel":
            MessageLookupByLibrary.simpleMessage("Facebook sale channel"),
        "menu_LiveCampaign":
            MessageLookupByLibrary.simpleMessage("Live campaign"),
        "menu_SaleOnlineOrder":
            MessageLookupByLibrary.simpleMessage("Sale online orders"),
        "menu_addCustomer":
            MessageLookupByLibrary.simpleMessage("Add customer"),
        "menu_addProduct": MessageLookupByLibrary.simpleMessage("Add product"),
        "menu_allFeature": MessageLookupByLibrary.simpleMessage("All features"),
        "menu_cashReceipt":
            MessageLookupByLibrary.simpleMessage("Cash Receipt"),
        "menu_createFastSaleOrder":
            MessageLookupByLibrary.simpleMessage("Create sale order"),
        "menu_customMenu": MessageLookupByLibrary.simpleMessage("Custom"),
        "menu_customer": MessageLookupByLibrary.simpleMessage("Customers"),
        "menu_customerGroup":
            MessageLookupByLibrary.simpleMessage("Customer categories"),
        "menu_deliveryCarrier":
            MessageLookupByLibrary.simpleMessage("Delivery carriers"),
        "menu_deliverySaleOrders":
            MessageLookupByLibrary.simpleMessage("Delivery sale orders"),
        "menu_fastSaleOrders":
            MessageLookupByLibrary.simpleMessage("Fast sale orders"),
        "menu_import":
            MessageLookupByLibrary.simpleMessage("Inventory receiving voucher"),
        "menu_paymentReceipt":
            MessageLookupByLibrary.simpleMessage("Payment Receipt"),
        "menu_paymentType":
            MessageLookupByLibrary.simpleMessage("Payment type"),
        "menu_posOfSale": MessageLookupByLibrary.simpleMessage("Pos of sale"),
        "menu_product": MessageLookupByLibrary.simpleMessage("Products"),
        "menu_productGroup":
            MessageLookupByLibrary.simpleMessage("Product categories"),
        "menu_purchaseOrder":
            MessageLookupByLibrary.simpleMessage("Purchase order"),
        "menu_quotation": MessageLookupByLibrary.simpleMessage("Quotations"),
        "menu_receiptType":
            MessageLookupByLibrary.simpleMessage("Receipt type"),
        "menu_saleChannels":
            MessageLookupByLibrary.simpleMessage("Sale channels"),
        "menu_search": MessageLookupByLibrary.simpleMessage("Search"),
        "menu_settingPrinter":
            MessageLookupByLibrary.simpleMessage("Print configuration"),
        "menu_settingSaleOrder":
            MessageLookupByLibrary.simpleMessage("Sale setting"),
        "menu_supplier": MessageLookupByLibrary.simpleMessage("Suppliers"),
        "notification": MessageLookupByLibrary.simpleMessage("Notification"),
        "notifyExpire": m1,
        "otherReport": MessageLookupByLibrary.simpleMessage("Other report"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "personal": MessageLookupByLibrary.simpleMessage("Personal"),
        "posOrder": MessageLookupByLibrary.simpleMessage("Pos order"),
        "printConfiguration":
            MessageLookupByLibrary.simpleMessage("Print configuration"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy policy"),
        "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "saleOnline_checkboxOnlyTenComment":
            MessageLookupByLibrary.simpleMessage("Only show > 10 comments"),
        "saleOnline_existsNotify": m2,
        "saleOrders": MessageLookupByLibrary.simpleMessage("Sale orders"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "saveWithName": MessageLookupByLibrary.simpleMessage("Save with name"),
        "selectFacebookSaleChannel":
            MessageLookupByLibrary.simpleMessage("Select sale channel"),
        "selectLanguage":
            MessageLookupByLibrary.simpleMessage("Select language"),
        "sendEmailFeedback":
            MessageLookupByLibrary.simpleMessage("Send a feedback email"),
        "setting": MessageLookupByLibrary.simpleMessage("Settings"),
        "statistics": MessageLookupByLibrary.simpleMessage("Statistics"),
        "thisMonth": MessageLookupByLibrary.simpleMessage("This month"),
        "thisYear": MessageLookupByLibrary.simpleMessage("This year"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "voteForApp": MessageLookupByLibrary.simpleMessage("Vote our app"),
        "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
        "loginPage_forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot password?"),
        "changePassword_oldPassword":
            MessageLookupByLibrary.simpleMessage("Old password"),
        "changePassword_newPassword":
            MessageLookupByLibrary.simpleMessage("New password"),
        "changePassword_confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm password"),
        "changePassword_confirm":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "changePassword_changePassword":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "changePassword_isNotEmpty":
            MessageLookupByLibrary.simpleMessage("Password cannot be empty!"),
        "changePassword_characterLength6":
            MessageLookupByLibrary.simpleMessage("Your password must be between 6-36 characters"),
        "changePassword_characterLength36":
            MessageLookupByLibrary.simpleMessage("Your password must be between 6-36 characters"),
        "changePassword_confirmPasswordError":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "forgotPassword_Send": MessageLookupByLibrary.simpleMessage("Send"),
        "forgotPassword_Notify": MessageLookupByLibrary.simpleMessage(
            "Enter the email connected to your account.Check email and change password."),
        "fbPostShare_Reverse": MessageLookupByLibrary.simpleMessage("Reverse"),
        "fbPostShare_Total": MessageLookupByLibrary.simpleMessage("Total"),
        "fbPostShare_NumberOfSharingPeople":
            MessageLookupByLibrary.simpleMessage("Number of sharing people"),
        "fbPostShare_SharePersonally":
            MessageLookupByLibrary.simpleMessage("Share personally"),
        "fbPostShare_ShareToGroup":
            MessageLookupByLibrary.simpleMessage("Share to group"),
        "fbPostShare_NumberOfShare":
            MessageLookupByLibrary.simpleMessage("Number of share"),
        "fbPostShare_Reload": MessageLookupByLibrary.simpleMessage("Reload"),
        "fbPostShare_NotFoundShare": MessageLookupByLibrary.simpleMessage(
            "Not found. Please try to again!"),
        "fbPostShare_CloseContinue":
            MessageLookupByLibrary.simpleMessage("Close & Continue"),
        "reportOrder_invoiceStatistics":
            MessageLookupByLibrary.simpleMessage("Invoice statistics"),
        "reportOrder_Overview":
            MessageLookupByLibrary.simpleMessage("Overview"),
        "reportOrder_Sell": MessageLookupByLibrary.simpleMessage("Sell"),
        "reportOrder_promotionDiscount":
            MessageLookupByLibrary.simpleMessage("Promotion + Discount"),
        "reportOrder_amountTotal":
            MessageLookupByLibrary.simpleMessage("Amount total"),
        "reportOrder_Discount":
            MessageLookupByLibrary.simpleMessage("Discount"),
        "reportOrder_Promotion":
            MessageLookupByLibrary.simpleMessage("Promotion"),
        "reportOrder_Detail": MessageLookupByLibrary.simpleMessage("Detail"),
        "reportOrder_fastSaleOrder":
            MessageLookupByLibrary.simpleMessage("Fast sale order"),
        "reportOrder_Invoices":
            MessageLookupByLibrary.simpleMessage("Invoices"),
        "reportOrder_Debt": MessageLookupByLibrary.simpleMessage("Debt"),
        "reportOrder_Partner":
            MessageLookupByLibrary.simpleMessage("Partner"),
        "reportOrder_Employee":
            MessageLookupByLibrary.simpleMessage("Employee"),
        "reportOrder_Company": MessageLookupByLibrary.simpleMessage("Company"),
        "reportOrder_invoiceType":
            MessageLookupByLibrary.simpleMessage("Invoice type"),
    "reportOrder_deliveryStatistics": MessageLookupByLibrary.simpleMessage("Delivery statistics"),
    "reportOrder_collectionAmount": MessageLookupByLibrary.simpleMessage("Collection amount"),
    "reportOrder_Paid": MessageLookupByLibrary.simpleMessage("Paid"),
    "reportOrder_Delivering": MessageLookupByLibrary.simpleMessage("Delivering"),
    "reportOrder_refundedOrder": MessageLookupByLibrary.simpleMessage("Refunded Order"),
    "reportOrder_controlFailed": MessageLookupByLibrary.simpleMessage("The control was not successful"),
    "reportOrder_Deposit": MessageLookupByLibrary.simpleMessage("Deposit"),
    "reportOrder_Invoice": MessageLookupByLibrary.simpleMessage("Invoice"),
    "reportOrder_deliveryInvoices": MessageLookupByLibrary.simpleMessage("Delivery invoices"),
    "reportOrder_deliveryControl": MessageLookupByLibrary.simpleMessage("Delivery control"),
    "reportOrder_deliveryStatus": MessageLookupByLibrary.simpleMessage("Delivery status"),
    "reportOrder_controlStatus": MessageLookupByLibrary.simpleMessage("Control status"),
    "reportOrder_deliveryPartner": MessageLookupByLibrary.simpleMessage("Delivery partner"),
    "reportOrder_deliveryPartnerType": MessageLookupByLibrary.simpleMessage("Delivery partner type"),

      };
}
