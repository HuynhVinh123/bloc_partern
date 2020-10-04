class StaticData {
  static const List<DeliveryCarrierService> viettelDeliveryCarrierService = [
    // Viettel
    DeliveryCarrierService(
        deliveryType: 'ViettelPost',
        id: 'SCOD',
        name: 'Giao hàng thu tiền (SCOD)'),
    DeliveryCarrierService(
        deliveryType: 'ViettelPost',
        id: 'VCN',
        name: 'Chuyển phát nhanh (VCN)'),
    DeliveryCarrierService(
        deliveryType: 'ViettelPost',
        id: 'PTN',
        name: 'Phát trong ngày nội tỉnh (PTN)'),
    DeliveryCarrierService(
        deliveryType: 'ViettelPost',
        id: 'PHT',
        name: 'Phát hỏa tốc nội tỉnh (PHT)'),
    DeliveryCarrierService(
        deliveryType: 'ViettelPost',
        id: 'PHS',
        name: 'Phát hôm sau nội tỉnh (PHS)'),
    DeliveryCarrierService(
        deliveryType: 'ViettelPost', id: 'VTK', name: 'Tiết kiệm (VTK)'),
    DeliveryCarrierService(
        deliveryType: 'ViettelPost',
        id: 'V60',
        name: 'Dịch vụ nhanh 60h (V60)'),
    DeliveryCarrierService(
        deliveryType: 'ViettelPost', id: 'VVT', name: 'Dịch vụ vận tải (VVT)'),
    DeliveryCarrierService(
        deliveryType: 'ViettelPost', id: 'VBS', name: 'Nhanh theo hộp (VBS)'),
    DeliveryCarrierService(
      deliveryType: 'ViettelPost',
      id: 'VBE',
      name: 'Tiết kiệm theo hộp (VBE)',
    ),
  ];
}

class DeliveryCarrierService {
  final String name;
  final String id;
  final String deliveryType;

  const DeliveryCarrierService({this.name, this.id, this.deliveryType});
  const DeliveryCarrierService.from(this.deliveryType, this.name, this.id);
}
