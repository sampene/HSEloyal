class UserInfoResponse {
  Data data;
  String message;

  UserInfoResponse({this.data, this.message});

  UserInfoResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String lastName;
  double balance;
  String firstName;
  String email;

  Data({this.lastName, this.balance, this.firstName, this.email});

  Data.fromJson(Map<String, dynamic> json) {
    lastName = json['last_name'];
    balance = json['balance'];
    firstName = json['first_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_name'] = this.lastName;
    data['balance'] = this.balance;
    data['first_name'] = this.firstName;
    data['email'] = this.email;
    return data;
  }
}