# tpos_mobile

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:l

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.



/// Luồng khởi động ứng dụng tpos

Mở app
Kiểm tra đăng nhập
(Có): Mở homePage
(Không): Kiểm tra số lần đăng nhập
(> 1): Mở LoginPage
(=0): Mở màn hinh intro giới thiệu

Mở homePage
1. Kiểm tra token xem còn sử dụng được không?
(Có) :
1.1 : Lấy thông tin công ty hiện tại
1.2 : Kiểm tra thông báo mới
1.3 : Tải thông tin phân quyền
(Không): Đăng xuất-> Trở lại LoginPage