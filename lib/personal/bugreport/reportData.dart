class Report {
  String phone;
  String version;
  String errorDesc;

  Report(
      {
        this.version,
        this.errorDesc,
        this.phone});

  Report.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    version = json['version'];
    errorDesc = json['error_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['version'] = this.version;
    data['error_desc'] = this.errorDesc;
    return data;
  }
}
