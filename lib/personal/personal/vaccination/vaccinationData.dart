class VaccinationData {
  List<ListOfVacData> data;
  String type;
  int tabn;

  VaccinationData({this.data, this.type, this.tabn});

  VaccinationData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ListOfVacData>();
      json['data'].forEach((v) {
        data.add(new ListOfVacData.fromJson(v));
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

class ListOfVacData {
  int code;
  List<VacData> data;
  String name;

  ListOfVacData({this.code, this.data, this.name});

  ListOfVacData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<VacData>();
      json['data'].forEach((v) {
        data.add(new VacData.fromJson(v));
      });
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    return data;
  }
}

class VacData {
  String dateVaccination;
  String dose;
  int vaccineResponseCode;
  String series;
  String manufacturingPlant;
  String nameVaccine;
  int nameVaccineCode;
  int typeVaccinationCode;
  String vaccineResponse;
  String typeVaccination;
  String shelfLife;

  VacData(
      {this.dateVaccination,
      this.dose,
      this.vaccineResponseCode,
      this.series,
      this.manufacturingPlant,
      this.nameVaccine,
      this.nameVaccineCode,
      this.typeVaccinationCode,
      this.vaccineResponse,
      this.typeVaccination,
      this.shelfLife});

  VacData.fromJson(Map<String, dynamic> json) {
    dateVaccination = json['date_vaccination'];
    dose = json['dose'];
    vaccineResponseCode = json['vaccine_response_code'];
    series = json['series'];
    manufacturingPlant = json['manufacturing_plant'];
    nameVaccine = json['name_vaccine'];
    nameVaccineCode = json['name_vaccine_code'];
    typeVaccinationCode = json['type_vaccination_code'];
    vaccineResponse = json['vaccine_response'];
    typeVaccination = json['type_vaccination'];
    shelfLife = json['shelf_life'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_vaccination'] = this.dateVaccination;
    data['dose'] = this.dose;
    data['vaccine_response_code'] = this.vaccineResponseCode;
    data['series'] = this.series;
    data['manufacturing_plant'] = this.manufacturingPlant;
    data['name_vaccine'] = this.nameVaccine;
    data['name_vaccine_code'] = this.nameVaccineCode;
    data['type_vaccination_code'] = this.typeVaccinationCode;
    data['vaccine_response'] = this.vaccineResponse;
    data['type_vaccination'] = this.typeVaccination;
    data['shelf_life'] = this.shelfLife;
    return data;
  }
}
