
class FeeModel {
  FeeModel({
      int? status, 
      String? message, 
      String? studentId, 
      Fees? fees,}){
    _status = status;
    _message = message;
    _studentId = studentId;
    _fees = fees;
}

  FeeModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _studentId = json['student_id'];
    _fees = json['fees'] != null ? Fees.fromJson(json['fees']) : null;
  }
  int? _status;
  String? _message;
  String? _studentId;
  Fees? _fees;
FeeModel copyWith({  int? status,
  String? message,
  String? studentId,
  Fees? fees,
}) => FeeModel(  status: status ?? _status,
  message: message ?? _message,
  studentId: studentId ?? _studentId,
  fees: fees ?? _fees,
);
  int? get status => _status;
  String? get message => _message;
  String? get studentId => _studentId;
  Fees? get fees => _fees;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['student_id'] = _studentId;
    if (_fees != null) {
      map['fees'] = _fees?.toJson();
    }
    return map;
  }

}

class Fees {
  Fees({
      List<Paid>? paid, 
      List<Unpaid>? unpaid,}){
    _paid = paid;
    _unpaid = unpaid;
}

  Fees.fromJson(dynamic json) {
    if (json['paid'] != null) {
      _paid = [];
      json['paid'].forEach((v) {
        _paid?.add(Paid.fromJson(v));
      });
    }
    if (json['unpaid'] != null) {
      _unpaid = [];
      json['unpaid'].forEach((v) {
        _unpaid?.add(Unpaid.fromJson(v));
      });
    }
  }
  List<Paid>? _paid;
  List<Unpaid>? _unpaid;
Fees copyWith({  List<Paid>? paid,
  List<Unpaid>? unpaid,
}) => Fees(  paid: paid ?? _paid,
  unpaid: unpaid ?? _unpaid,
);
  List<Paid>? get paid => _paid;
  List<Unpaid>? get unpaid => _unpaid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_paid != null) {
      map['paid'] = _paid?.map((v) => v.toJson()).toList();
    }
    if (_unpaid != null) {
      map['unpaid'] = _unpaid?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// payment_receipt_no : "DLS-2021-5929"
/// amount : "10000"
/// issuance_date : "2022-03-02 05:58:20"
/// payment_deadline : "2022-03-22 00:00:00"
/// payment_date : null
/// payment_status : "unpaid"
/// year : "2021-2022"

class Unpaid {
  Unpaid({
      String? paymentReceiptNo, 
      String? amount, 
      String? issuanceDate, 
      String? paymentDeadline, 
      dynamic paymentDate, 
      String? paymentStatus, 
      String? year,}){
    _paymentReceiptNo = paymentReceiptNo;
    _amount = amount;
    _issuanceDate = issuanceDate;
    _paymentDeadline = paymentDeadline;
    _paymentDate = paymentDate;
    _paymentStatus = paymentStatus;
    _year = year;
}

  Unpaid.fromJson(dynamic json) {
    _paymentReceiptNo = json['payment_receipt_no'];
    _amount = json['amount'];
    _issuanceDate = json['issuance_date'];
    _paymentDeadline = json['payment_deadline'];
    _paymentDate = json['payment_date'];
    _paymentStatus = json['payment_status'];
    _year = json['year'];
  }
  String? _paymentReceiptNo;
  String? _amount;
  String? _issuanceDate;
  String? _paymentDeadline;
  dynamic _paymentDate;
  String? _paymentStatus;
  String? _year;
Unpaid copyWith({  String? paymentReceiptNo,
  String? amount,
  String? issuanceDate,
  String? paymentDeadline,
  dynamic paymentDate,
  String? paymentStatus,
  String? year,
}) => Unpaid(  paymentReceiptNo: paymentReceiptNo ?? _paymentReceiptNo,
  amount: amount ?? _amount,
  issuanceDate: issuanceDate ?? _issuanceDate,
  paymentDeadline: paymentDeadline ?? _paymentDeadline,
  paymentDate: paymentDate ?? _paymentDate,
  paymentStatus: paymentStatus ?? _paymentStatus,
  year: year ?? _year,
);
  String? get paymentReceiptNo => _paymentReceiptNo;
  String? get amount => _amount;
  String? get issuanceDate => _issuanceDate;
  String? get paymentDeadline => _paymentDeadline;
  dynamic get paymentDate => _paymentDate;
  String? get paymentStatus => _paymentStatus;
  String? get year => _year;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_receipt_no'] = _paymentReceiptNo;
    map['amount'] = _amount;
    map['issuance_date'] = _issuanceDate;
    map['payment_deadline'] = _paymentDeadline;
    map['payment_date'] = _paymentDate;
    map['payment_status'] = _paymentStatus;
    map['year'] = _year;
    return map;
  }

}

/// payment_receipt_no : "DLS-2021-5253"
/// amount : "100000"
/// issuance_date : "2021-10-18 03:45:47"
/// payment_deadline : "2021-10-20 00:00:00"
/// payment_date : "2021-10-18 08:09:31"
/// payment_status : "paid"
/// year : "2021-2022"

class Paid {
  Paid({
      String? paymentReceiptNo, 
      String? amount, 
      String? issuanceDate, 
      String? paymentDeadline, 
      String? paymentDate, 
      String? paymentStatus, 
      String? year,}){
    _paymentReceiptNo = paymentReceiptNo;
    _amount = amount;
    _issuanceDate = issuanceDate;
    _paymentDeadline = paymentDeadline;
    _paymentDate = paymentDate;
    _paymentStatus = paymentStatus;
    _year = year;
}

  Paid.fromJson(dynamic json) {
    _paymentReceiptNo = json['payment_receipt_no'];
    _amount = json['amount'];
    _issuanceDate = json['issuance_date'];
    _paymentDeadline = json['payment_deadline'];
    _paymentDate = json['payment_date'];
    _paymentStatus = json['payment_status'];
    _year = json['year'];
  }
  String? _paymentReceiptNo;
  String? _amount;
  String? _issuanceDate;
  String? _paymentDeadline;
  String? _paymentDate;
  String? _paymentStatus;
  String? _year;
Paid copyWith({  String? paymentReceiptNo,
  String? amount,
  String? issuanceDate,
  String? paymentDeadline,
  String? paymentDate,
  String? paymentStatus,
  String? year,
}) => Paid(  paymentReceiptNo: paymentReceiptNo ?? _paymentReceiptNo,
  amount: amount ?? _amount,
  issuanceDate: issuanceDate ?? _issuanceDate,
  paymentDeadline: paymentDeadline ?? _paymentDeadline,
  paymentDate: paymentDate ?? _paymentDate,
  paymentStatus: paymentStatus ?? _paymentStatus,
  year: year ?? _year,
);
  String? get paymentReceiptNo => _paymentReceiptNo;
  String? get amount => _amount;
  String? get issuanceDate => _issuanceDate;
  String? get paymentDeadline => _paymentDeadline;
  String? get paymentDate => _paymentDate;
  String? get paymentStatus => _paymentStatus;
  String? get year => _year;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_receipt_no'] = _paymentReceiptNo;
    map['amount'] = _amount;
    map['issuance_date'] = _issuanceDate;
    map['payment_deadline'] = _paymentDeadline;
    map['payment_date'] = _paymentDate;
    map['payment_status'] = _paymentStatus;
    map['year'] = _year;
    return map;
  }

}