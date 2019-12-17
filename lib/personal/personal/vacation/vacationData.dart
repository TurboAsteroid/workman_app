class Vacation {
  Data data;
  String type;
  int tabn;

  Vacation({this.data, this.type, this.tabn});

  Vacation.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    type = json['type'];
    tabn = json['tabn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['type'] = this.type;
    data['tabn'] = this.tabn;
    return data;
  }
}

class Data {
  PeriodOfExistence periodOfExistence;
  List<PlannedDates> plannedDates;
  Debt debt;

  Data({this.periodOfExistence, this.plannedDates, this.debt});

  Data.fromJson(Map<String, dynamic> json) {
    periodOfExistence = json['period_of_existence'] != null
        ? new PeriodOfExistence.fromJson(json['period_of_existence'])
        : null;
    if (json['planned_dates'] != null) {
      plannedDates = new List<PlannedDates>();
      json['planned_dates'].forEach((v) {
        plannedDates.add(new PlannedDates.fromJson(v));
      });
    }
    debt = json['debt'] != null ? new Debt.fromJson(json['debt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.periodOfExistence != null) {
      data['period_of_existence'] = this.periodOfExistence.toJson();
    }
    if (this.plannedDates != null) {
      data['planned_dates'] = this.plannedDates.map((v) => v.toJson()).toList();
    }
    if (this.debt != null) {
      data['debt'] = this.debt.toJson();
    }
    return data;
  }
}

class PeriodOfExistence {
  String start;
  int company;
  String end;

  PeriodOfExistence({this.start, this.company, this.end});

  PeriodOfExistence.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    company = json['company'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['company'] = this.company;
    data['end'] = this.end;
    return data;
  }
}

class PlannedDates {
  int month;
  int year;
  int numberOfDays;
  int company;

  PlannedDates({this.month, this.year, this.numberOfDays, this.company});

  PlannedDates.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    year = json['year'];
    numberOfDays = json['number_of_days'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['year'] = this.year;
    data['number_of_days'] = this.numberOfDays;
    data['company'] = this.company;
    return data;
  }
}

class Debt {
  double debtLastPeriod;
  double currentPeriodDebt;
  double addidtionDays;

  Debt({this.debtLastPeriod, this.currentPeriodDebt, this.addidtionDays});

  Debt.fromJson(Map<String, dynamic> json) {
    debtLastPeriod = double.parse(json['debt_last_period'].toString());
    currentPeriodDebt = double.parse(json['current_period_debt'].toString());
    addidtionDays = double.parse(json['addidtion_days'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['debt_last_period'] = this.debtLastPeriod;
    data['current_period_debt'] = this.currentPeriodDebt;
    data['addidtion_days'] = this.addidtionDays;
    return data;
  }
}
