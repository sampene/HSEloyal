class QR_Data {
  num sum;
  num cashBack;
  String address;

  QR_Data({this.sum, this.cashBack, this.address});

  QR_Data.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
    cashBack = json['cash_back'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sum'] = this.sum;
    data['cash_back'] = this.cashBack;
    data['address'] = this.address;
    return data;
  }
}