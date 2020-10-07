enum FastSaleOrderState {
  open, //Đã xác nhận
  draft, //nháp
  cancel, // hủy bỏ
  paid, // Đã thanh toán
  na, //không xác định
}

enum SaleOrderState {
  no, //Không cần lập hóa đơn
  toinvoice, //Chờ lập hóa đơn
  invoiced, // Đã tạo hóa đơn
  na, //không xác định
}
