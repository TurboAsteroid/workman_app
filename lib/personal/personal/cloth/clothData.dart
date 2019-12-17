class ClothData {
  List<Get> get;
  List<Got> got;

  ClothData({this.get, this.got});

  ClothData.fromJson(Map<String, dynamic> json) {
    if (json['get'] != null) {
      get = new List<Get>();
      json['get'].forEach((v) {
        get.add(new Get.fromJson(v));
      });
    }
    if (json['got'] != null) {
      got = new List<Got>();
      json['got'].forEach((v) {
        got.add(new Got.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.get != null) {
      data['get'] = this.get.map((v) => v.toJson()).toList();
    }
    if (this.got != null) {
      data['got'] = this.got.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Get {
  String tYPE;
  int tN;
  String pERNR;
  int kODNORM;
  String vIDSP;
  String zAMVIDSP;
  String wGBEZ;
  int qUOTA;
  String qUOM;
  int nDJAR;
  int nDPER;
  String zINDIZN;
  String dESCRIPT;
  int mATNR;
  int aQUANT;
  String aUOM;
  String sROK;
  Null aKTIV;
  Null dEAKTIV;
  int pERCENTWEAR;
  String gSBER;
  String zZTNORM;
  String zSPDSIZ;

  Get(
      {this.tYPE,
        this.tN,
        this.pERNR,
        this.kODNORM,
        this.vIDSP,
        this.zAMVIDSP,
        this.wGBEZ,
        this.qUOTA,
        this.qUOM,
        this.nDJAR,
        this.nDPER,
        this.zINDIZN,
        this.dESCRIPT,
        this.mATNR,
        this.aQUANT,
        this.aUOM,
        this.sROK,
        this.aKTIV,
        this.dEAKTIV,
        this.pERCENTWEAR,
        this.gSBER,
        this.zZTNORM,
        this.zSPDSIZ});

  Get.fromJson(Map<String, dynamic> json) {
    tYPE = json['TYPE'];
    tN = json['TN'];
    pERNR = json['PERNR'];
    kODNORM = json['KODNORM'];
    vIDSP = json['VIDSP'];
    zAMVIDSP = json['ZAM_VIDSP'];
    wGBEZ = json['WGBEZ'];
    qUOTA = json['QUOTA'];
    qUOM = json['QUOM'];
    nDJAR = json['NDJAR'];
    nDPER = json['NDPER'];
    zINDIZN = json['ZINDIZN'];
    dESCRIPT = json['DESCRIPT'];
    mATNR = json['MATNR'];
    aQUANT = json['AQUANT'];
    aUOM = json['AUOM'];
    sROK = json['SROK'];
    aKTIV = json['AKTIV'];
    dEAKTIV = json['DEAKTIV'];
    pERCENTWEAR = json['PERCENTWEAR'];
    gSBER = json['GSBER'];
    zZTNORM = json['ZZTNORM'];
    zSPDSIZ = json['ZSPDSIZ'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TYPE'] = this.tYPE;
    data['TN'] = this.tN;
    data['PERNR'] = this.pERNR;
    data['KODNORM'] = this.kODNORM;
    data['VIDSP'] = this.vIDSP;
    data['ZAM_VIDSP'] = this.zAMVIDSP;
    data['WGBEZ'] = this.wGBEZ;
    data['QUOTA'] = this.qUOTA;
    data['QUOM'] = this.qUOM;
    data['NDJAR'] = this.nDJAR;
    data['NDPER'] = this.nDPER;
    data['ZINDIZN'] = this.zINDIZN;
    data['DESCRIPT'] = this.dESCRIPT;
    data['MATNR'] = this.mATNR;
    data['AQUANT'] = this.aQUANT;
    data['AUOM'] = this.aUOM;
    data['SROK'] = this.sROK;
    data['AKTIV'] = this.aKTIV;
    data['DEAKTIV'] = this.dEAKTIV;
    data['PERCENTWEAR'] = this.pERCENTWEAR;
    data['GSBER'] = this.gSBER;
    data['ZZTNORM'] = this.zZTNORM;
    data['ZSPDSIZ'] = this.zSPDSIZ;
    return data;
  }
}

class Got {
  String tYPE;
  int tN;
  String pERNR;
  int kODNORM;
  String vIDSP;
  String zAMVIDSP;
  String wGBEZ;
  int qUOTA;
  String qUOM;
  int nDJAR;
  int nDPER;
  String zINDIZN;
  String dESCRIPT;
  int mATNR;
  int aQUANT;
  String aUOM;
  String sROK;
  String aKTIV;
  String dEAKTIV;
  int pERCENTWEAR;
  String gSBER;
  String zZTNORM;
  String zSPDSIZ;

  Got(
      {this.tYPE,
        this.tN,
        this.pERNR,
        this.kODNORM,
        this.vIDSP,
        this.zAMVIDSP,
        this.wGBEZ,
        this.qUOTA,
        this.qUOM,
        this.nDJAR,
        this.nDPER,
        this.zINDIZN,
        this.dESCRIPT,
        this.mATNR,
        this.aQUANT,
        this.aUOM,
        this.sROK,
        this.aKTIV,
        this.dEAKTIV,
        this.pERCENTWEAR,
        this.gSBER,
        this.zZTNORM,
        this.zSPDSIZ});

  Got.fromJson(Map<String, dynamic> json) {
    tYPE = json['TYPE'];
    tN = json['TN'];
    pERNR = json['PERNR'];
    kODNORM = json['KODNORM'];
    vIDSP = json['VIDSP'];
    zAMVIDSP = json['ZAM_VIDSP'];
    wGBEZ = json['WGBEZ'];
    qUOTA = json['QUOTA'];
    qUOM = json['QUOM'];
    nDJAR = json['NDJAR'];
    nDPER = json['NDPER'];
    zINDIZN = json['ZINDIZN'];
    dESCRIPT = json['DESCRIPT'];
    mATNR = json['MATNR'];
    aQUANT = json['AQUANT'];
    aUOM = json['AUOM'];
    sROK = json['SROK'];
    aKTIV = json['AKTIV'];
    dEAKTIV = json['DEAKTIV'];
    pERCENTWEAR = json['PERCENTWEAR'];
    gSBER = json['GSBER'];
    zZTNORM = json['ZZTNORM'];
    zSPDSIZ = json['ZSPDSIZ'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TYPE'] = this.tYPE;
    data['TN'] = this.tN;
    data['PERNR'] = this.pERNR;
    data['KODNORM'] = this.kODNORM;
    data['VIDSP'] = this.vIDSP;
    data['ZAM_VIDSP'] = this.zAMVIDSP;
    data['WGBEZ'] = this.wGBEZ;
    data['QUOTA'] = this.qUOTA;
    data['QUOM'] = this.qUOM;
    data['NDJAR'] = this.nDJAR;
    data['NDPER'] = this.nDPER;
    data['ZINDIZN'] = this.zINDIZN;
    data['DESCRIPT'] = this.dESCRIPT;
    data['MATNR'] = this.mATNR;
    data['AQUANT'] = this.aQUANT;
    data['AUOM'] = this.aUOM;
    data['SROK'] = this.sROK;
    data['AKTIV'] = this.aKTIV;
    data['DEAKTIV'] = this.dEAKTIV;
    data['PERCENTWEAR'] = this.pERCENTWEAR;
    data['GSBER'] = this.gSBER;
    data['ZZTNORM'] = this.zZTNORM;
    data['ZSPDSIZ'] = this.zSPDSIZ;
    return data;
  }
}
