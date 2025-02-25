class BadyModel {
  String? date;
  List<String>? birthdayNames;

  BadyModel({this.date, this.birthdayNames});

  BadyModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    birthdayNames = json['birthday_names'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['birthday_names'] = this.birthdayNames;
    return data;
  }
}
