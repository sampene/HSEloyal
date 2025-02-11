class LoginResponse {
  Data data;
  String message;

  LoginResponse({this.data, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
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
  String userId;
  String accessToken;

  Data({this.userId, this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.userId;
    data['access_token'] = this.accessToken;
    return data;
  }
}