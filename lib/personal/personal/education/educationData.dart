class EducationData {
  List<Course> data;
  String type;
  int tabn;

  EducationData({this.data, this.type, this.tabn});

  EducationData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Course>();
      json['data'].forEach((v) {
        data.add(new Course.fromJson(v));
      });
    }
    type = json['type'];
    tabn = json['tabn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['tabn'] = this.tabn;
    return data;
  }
}

class Course {
  String date;
  String protocolNumber;
  String title;
  String department;

  Course({this.date, this.protocolNumber, this.title, this.department});

  Course.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    protocolNumber = json['protocol_number'];
    title = json['title'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['protocol_number'] = this.protocolNumber;
    data['title'] = this.title;
    data['department'] = this.department;
    return data;
  }
}
