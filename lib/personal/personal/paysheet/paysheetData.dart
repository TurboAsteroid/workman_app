class PaysheetData {
  List<MainData> data;
  int month;
  int year;
  String type;

  PaysheetData({this.data, this.month, this.year, this.type});

  PaysheetData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<MainData>();
      json['data'].forEach((v) {
        data.add(new MainData.fromJson(v));
      });
    }
    month = json['month'];
    year = json['year'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['month'] = this.month;
    data['year'] = this.year;
    data['type'] = this.type;
    return data;
  }
}

class MainData {
  WorkingTimeFundPlan workingTimeFundPlan;
  Rate rate;
  InsurancePremiums insurancePremiums;
  AccrualsPerMonth accrualsPerMonth;
  List<dynamic> taxes;
  Company company;
  Payroll payroll;
  Department department;
  Employee employee;
  RetentionsPerMonth retentionsPerMonth;

  MainData(
      {this.workingTimeFundPlan,
        this.rate,
        this.insurancePremiums,
        this.accrualsPerMonth,
        this.taxes,
        this.company,
        this.payroll,
        this.department,
        this.employee,
        this.retentionsPerMonth});

  MainData.fromJson(Map<String, dynamic> json) {
    workingTimeFundPlan = json['working_time_fund_plan'] != null
        ? new WorkingTimeFundPlan.fromJson(json['working_time_fund_plan'])
        : null;
    rate = json['rate'] != null ? new Rate.fromJson(json['rate']) : null;
    insurancePremiums = json['insurance_premiums'] != null
        ? new InsurancePremiums.fromJson(json['insurance_premiums'])
        : null;
    accrualsPerMonth = json['accruals_per_month'] != null
        ? new AccrualsPerMonth.fromJson(json['accruals_per_month'])
        : null;
    if (json['taxes'] != null) {
      taxes = new List<List<dynamic>>();
      json['taxes'].forEach((v) {
        List<dynamic> taxes1 = new List<dynamic>();
        v.forEach((vv) {
          taxes1.add(Data.fromJson(vv));
        });
        taxes.add(taxes1);
      });
    }
    company =
    json['company'] != null ? new Company.fromJson(json['company']) : null;
    payroll =
    json['payroll'] != null ? new Payroll.fromJson(json['payroll']) : null;
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
    retentionsPerMonth = json['retentions_per_month'] != null
        ? new RetentionsPerMonth.fromJson(json['retentions_per_month'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.workingTimeFundPlan != null) {
      data['working_time_fund_plan'] = this.workingTimeFundPlan.toJson();
    }
    if (this.rate != null) {
      data['rate'] = this.rate.toJson();
    }
    if (this.insurancePremiums != null) {
      data['insurance_premiums'] = this.insurancePremiums.toJson();
    }
    if (this.accrualsPerMonth != null) {
      data['accruals_per_month'] = this.accrualsPerMonth.toJson();
    }
    if (this.taxes != null) {
//      data['taxes'] = this.taxes.map((v) => v.toJson()).toList();
    }
    if (this.company != null) {
      data['company'] = this.company.toJson();
    }
    if (this.payroll != null) {
      data['payroll'] = this.payroll.toJson();
    }
    if (this.department != null) {
      data['department'] = this.department.toJson();
    }
    if (this.employee != null) {
      data['employee'] = this.employee.toJson();
    }
    if (this.retentionsPerMonth != null) {
      data['retentions_per_month'] = this.retentionsPerMonth.toJson();
    }
    return data;
  }
}

class Department {
  int code;
  String hint;
  String name;

  Department({this.code, this.hint, this.name});

  Department.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    hint = json['hint'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['hint'] = this.hint;
    data['name'] = this.name;
    return data;
  }
}

class Payroll {
  String hint;
  String name;
  String wageSlipName;
  String value;

  Payroll({this.hint, this.name, this.wageSlipName, this.value});

  Payroll.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    name = json['name'];
    wageSlipName = json['wage_slip_name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hint'] = this.hint;
    data['name'] = this.name;
    data['wage_slip_name'] = this.wageSlipName;
    data['value'] = this.value;
    return data;
  }
}

class WorkingTimeFundPlan {
  String hint;
  String name;
  String wageSlipName;
  int value;

  WorkingTimeFundPlan({this.hint, this.name, this.wageSlipName, this.value});

  WorkingTimeFundPlan.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    name = json['name'];
    wageSlipName = json['wage_slip_name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hint'] = this.hint;
    data['name'] = this.name;
    data['wage_slip_name'] = this.wageSlipName;
    data['value'] = this.value;
    return data;
  }
}

class Rate {
  String hint;
  String name;
  String wageSlipName;
  String value;

  Rate({this.hint, this.name, this.wageSlipName, this.value});

  Rate.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    name = json['name'];
    wageSlipName = json['wage_slip_name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hint'] = this.hint;
    data['name'] = this.name;
    data['wage_slip_name'] = this.wageSlipName;
    data['value'] = this.value;
    return data;
  }
}

class InsurancePremiums {
  List<Data> data;
  String hint;
  String name;
  String wageSlipName;

  InsurancePremiums({this.data, this.hint, this.name, this.wageSlipName});

  InsurancePremiums.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    hint = json['hint'];
    name = json['name'];
    wageSlipName = json['wage_slip_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['hint'] = this.hint;
    data['name'] = this.name;
    data['wage_slip_name'] = this.wageSlipName;
    return data;
  }
}

class Data {
  String name;
  String value;

  Data({this.name, this.value});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class TotalRetentions {
  String hint;
  String name;
  String wageSlipName;
  String value;

  TotalRetentions({this.hint, this.name, this.wageSlipName, this.value});

  TotalRetentions.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    name = json['name'];
    wageSlipName = json['wage_slip_name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hint'] = this.hint;
    data['name'] = this.name;
    data['wage_slip_name'] = this.wageSlipName;
    data['value'] = this.value;
    return data;
  }
}

class TotalAccrued {
  String hint;
  String name;
  String wageSlipName;
  String value;

  TotalAccrued({this.hint, this.name, this.wageSlipName, this.value});

  TotalAccrued.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    name = json['name'];
    wageSlipName = json['wage_slip_name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hint'] = this.hint;
    data['name'] = this.name;
    data['wage_slip_name'] = this.wageSlipName;
    data['value'] = this.value;
    return data;
  }
}

class AccrualsPerMonth {
  List<dynamic> data;
  TotalAccrued totalAccrued;
  String hint;
  String name;
  String wageSlipName;

  AccrualsPerMonth(
      {this.data, this.totalAccrued, this.hint, this.name, this.wageSlipName});

  AccrualsPerMonth.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<List<dynamic>>();
      json['data'].forEach((v) {
        List<dynamic> data1 = new List<dynamic>();
        v.forEach((vv) {
          data1.add(Data.fromJson(vv));
        });
        data.add(data1);
      });
    }
    totalAccrued = json['total_accrued'] != null
        ? new TotalAccrued.fromJson(json['total_accrued'])
        : null;
    hint = json['hint'];
    name = json['name'];
    wageSlipName = json['wage_slip_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
//      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.totalAccrued != null) {
      data['total_accrued'] = this.totalAccrued.toJson();
    }
    data['hint'] = this.hint;
    data['name'] = this.name;
    data['wage_slip_name'] = this.wageSlipName;
    return data;
  }
}

class Company {
  int code;
  String hint;
  String name;

  Company({this.code, this.hint, this.name});

  Company.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    hint = json['hint'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['hint'] = this.hint;
    data['name'] = this.name;
    return data;
  }
}

class Employee {
  String hint;
  String wageSlipName;
  String fullname;
  int staffNumber;

  Employee({this.hint, this.wageSlipName, this.fullname, this.staffNumber});

  Employee.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    wageSlipName = json['wage_slip_name'];
    fullname = json['fullname'];
    staffNumber = json['staff_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hint'] = this.hint;
    data['wage_slip_name'] = this.wageSlipName;
    data['fullname'] = this.fullname;
    data['staff_number'] = this.staffNumber;
    return data;
  }
}

class RetentionsPerMonth {
  List<dynamic> data;
  String hint;
  String name;
  String wageSlipName;
  TotalRetentions totalRetentions;

  RetentionsPerMonth(
      {this.data,
        this.hint,
        this.name,
        this.wageSlipName,
        this.totalRetentions});

  RetentionsPerMonth.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<List<dynamic>>();
      json['data'].forEach((v) {
        List<dynamic> data1 = new List<dynamic>();
        v.forEach((vv) {
          data1.add(Data.fromJson(vv));
        });
        data.add(data1);
      });
    }
    hint = json['hint'];
    name = json['name'];
    wageSlipName = json['wage_slip_name'];
    totalRetentions = json['total_retentions'] != null
        ? new TotalRetentions.fromJson(json['total_retentions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
//      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['hint'] = this.hint;
    data['name'] = this.name;
    data['wage_slip_name'] = this.wageSlipName;
    if (this.totalRetentions != null) {
      data['total_retentions'] = this.totalRetentions.toJson();
    }
    return data;
  }
}


//import 'package:json_annotation/json_annotation.dart';
//
//part 'pd.g.dart';
//
//@JsonSerializable()
//class PaysheetData {
//  List<MainData> data;
//  int month;
//  int year;
//  String type;
//
//  PaysheetData({this.data, this.month, this.year, this.type});
//
//  factory PaysheetData.fromJson(Map<String, dynamic> json) =>
//      _$PaysheetDataFromJson(json);
//
//  Map<String, dynamic> toJson() => _$PaysheetDataToJson(this);
//}
//
//@JsonSerializable()
//class MainData {
//  WorkingTimeFundPlan workingTimeFundPlan;
//  Rate rate;
//  InsurancePremiums insurancePremiums;
//  AccrualsPerMonth accrualsPerMonth;
//  List<Taxes> taxes;
//  Company company;
//  Payroll payroll;
//  Department department;
//  Employee employee;
//  RetentionsPerMonth retentionsPerMonth;
//
//  MainData(
//      {this.workingTimeFundPlan, this.rate, this.insurancePremiums, this.accrualsPerMonth, this.taxes, this.company, this.payroll, this.department, this.employee, this.retentionsPerMonth});
//
//  factory MainData.fromJson(Map<dynamic, dynamic> json) =>
//      _$MainDataFromJson(json);
//
//  Map<String, dynamic> toJson() => _$MainDataToJson(this);
//
//}
//
//@JsonSerializable()
//class WorkingTimeFundPlan {
//  String hint;
//  String name;
//  String wageSlipName;
//  int value;
//
//  WorkingTimeFundPlan({this.name, this.wageSlipName, this.value, this.hint});
//
//  factory WorkingTimeFundPlan.fromJson(Map<String, dynamic> json) =>
//      _$WorkingTimeFundPlanFromJson(json);
//
//  Map<String, dynamic> toJson() => _$WorkingTimeFundPlanToJson(this);
//}
//
//@JsonSerializable()
//class Rate {
//  String hint;
//  String name;
//  String wageSlipName;
//  String value;
//
//  Rate({this.name, this.wageSlipName, this.value, this.hint});
//
//  factory Rate.fromJson(Map<String, dynamic> json) => _$RateFromJson(json);
//
//  Map<String, dynamic> toJson() => _$RateToJson(this);
//}
//
//@JsonSerializable()
//class InsurancePremiums {
//  List<Data> data;
//  String hint;
//  String name;
//  String wageSlipName;
//
//  InsurancePremiums({this.data, this.hint, this.name, this.wageSlipName});
//
//  factory InsurancePremiums.fromJson(Map<String, dynamic> json) =>
//      _$InsurancePremiumsFromJson(json);
//
//  Map<String, dynamic> toJson() => _$InsurancePremiumsToJson(this);
//}
//
//@JsonSerializable()
//class Data {
//  String name;
//  String value;
//
//  Data({this.name, this.value});
//
//  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
//
//  Map<String, dynamic> toJson() => _$DataToJson(this);
//}
//
//@JsonSerializable()
//class Company {
//  int code;
//  String hint;
//  String name;
//
//  Company({this.code, this.hint, this.name});
//
//  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
//
//  Map<String, dynamic> toJson() => _$CompanyToJson(this);
//}
//
//@JsonSerializable()
//class Payroll {
//  String hint;
//  String name;
//  String wageSlipName;
//  String value;
//
//  Payroll({this.hint, this.name, this.wageSlipName, this.value});
//
//  factory Payroll.fromJson(Map<String, dynamic> json) => _$PayrollFromJson(json);
//
//  Map<String, dynamic> toJson() => _$PayrollToJson(this);
//}
//
//@JsonSerializable()
//class Department {
//  int code;
//  String hint;
//  String name;
//
//  Department({this.code, this.hint, this.name});
//
//  factory Department.fromJson(Map<String, dynamic> json) => _$DepartmentFromJson(json);
//
//  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
//}
//
//@JsonSerializable()
//class Employee {
//  String hint;
//  String wageSlipName;
//  String fullname;
//  int staffNumber;
//
//  Employee({this.hint, this.wageSlipName, this.fullname, this.staffNumber});
//
//  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
//
//  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
//}
//
//@JsonSerializable()
//class RetentionsPerMonth {
//  List<ArrData> data;
//  String hint;
//  String name;
//  String wageSlipName;
//  TotalRetentions totalRetentions;
//
//  RetentionsPerMonth(
//      {this.hint, this.name, this.wageSlipName, this.totalRetentions});
//
//  factory RetentionsPerMonth.fromJson(Map<String, dynamic> json) => _$RetentionsPerMonthFromJson(json);
//
//  Map<String, dynamic> toJson() => _$RetentionsPerMonthToJson(this);
//}
//
//@JsonSerializable()
//class TotalRetentions {
//  String hint;
//  String name;
//  String wageSlipName;
//  String value;
//
//  TotalRetentions({this.hint, this.name, this.wageSlipName, this.value});
//
//  factory TotalRetentions.fromJson(Map<String, dynamic> json) => _$TotalRetentionsFromJson(json);
//
//  Map<String, dynamic> toJson() => _$TotalRetentionsToJson(this);
//}
//
//@JsonSerializable()
//class AccrualsPerMonth {
//  List<ArrData> data;
//  TotalAccrued totalAccrued;
//  String hint;
//  String name;
//  String wageSlipName;
//
//  AccrualsPerMonth(
//      {this.data, this.totalAccrued, this.hint, this.name, this.wageSlipName});
//
//  factory AccrualsPerMonth.fromJson(Map<String, dynamic> json) => _$AccrualsPerMonthFromJson(json);
//
//  Map<String, dynamic> toJson() => _$AccrualsPerMonthToJson(this);
//}
//@JsonSerializable()
//class TotalAccrued {
//  String hint;
//  String name;
//  String wageSlipName;
//  String value;
//
//  TotalAccrued({this.hint, this.name, this.wageSlipName, this.value});
//
//  factory TotalAccrued.fromJson(Map<String, dynamic> json) => _$TotalAccruedFromJson(json);
//
//  Map<String, dynamic> toJson() => _$TotalAccruedToJson(this);
//}
//
//@JsonSerializable()
//class ArrData {
//  List<Data> data;
//
//  ArrData({this.data});
//
//  factory ArrData.fromJson(Map<String, dynamic> json) => _$ArrDataFromJson(json);
//
//  Map<String, dynamic> toJson() => _$ArrDataToJson(this);
//}
//
//@JsonSerializable()
//class Taxes {
//  List<ArrData> data;
//
//  Taxes({this.data});
//
//  factory Taxes.fromJson(Map<String, dynamic> json) => _$TaxesFromJson(json);
//
//  Map<String, dynamic> toJson() => _$TaxesToJson(this);
//}