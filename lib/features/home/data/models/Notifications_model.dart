class NotificationModel {
  NotificationModel({
    this.status,
    this.notifications = const [],
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['message'] == []) {
      notifications = json['message'];
    }
    if (json['message'] != null) {
      json['message'].forEach((v) {
        notifications.add(Data.fromJson(v));
      });
    }
  }
  String? status;
  List<Data> notifications = [];
}

class Data {
  Data(
      {this.NotificationID,
      this.Title,
      this.Description,
      this.IsRead,
      this.IsDelete,
      this.link,
      this.paramters,
      this.Date});

  Data.fromJson(dynamic json) {
    NotificationID = json['NotificationID'];
    Title = json['Title'];
    Description = json['Description'];
    IsRead = json['IsRead'];
    IsDelete = json['IsDelete'];
    category = json['Category'];
    link = json["Link"];
    paramters = json['Paramters'];
    Date = json['Date'] != null ? DateTime.parse(json["Date"]) : null;
  }
  int? NotificationID;
  String? Title;
  String? Description;
  bool? IsRead;
  bool? IsDelete;
  DateTime? Date;

  String? title;
  String? description;
  int? studentId;
  String? studentName;
  dynamic? icon;
  dynamic? link;
  dynamic? createdBy;
  DateTime? creationDate;
  dynamic? updatedBy;
  dynamic? updateDate;
  String? paramters;
  dynamic? category;
  bool? isArabic;
}
