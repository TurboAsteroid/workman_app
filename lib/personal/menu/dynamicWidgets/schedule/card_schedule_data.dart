class CardScheduleData {
  String header;
  String subheader;
  String scheduleName;
  String description;
  List<Schedule> schedule;

  CardScheduleData(
      {this.header,
        this.subheader,
        this.scheduleName,
        this.description,
        this.schedule});

  CardScheduleData.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    subheader = json['subheader'];
    scheduleName = json['scheduleName'];
    description = json['description'];
    if (json['schedule'] != null) {
      schedule = new List<Schedule>();
      json['schedule'].forEach((v) {
        schedule.add(new Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['header'] = this.header;
    data['subheader'] = this.subheader;
    data['scheduleName'] = this.scheduleName;
    data['description'] = this.description;
    if (this.schedule != null) {
      data['schedule'] = this.schedule.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schedule {
  String name;
  String datetime;

  Schedule({this.name, this.datetime});

  Schedule.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['datetime'] = this.datetime;
    return data;
  }
}