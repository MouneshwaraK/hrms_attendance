class BadyModel {
  String? date;
  List<String>? birthdayNames;

  BadyModel({this.date, this.birthdayNames});

  BadyModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    birthdayNames = json['birthday_names'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['birthday_names'] = birthdayNames;
    return data;
  }
}
