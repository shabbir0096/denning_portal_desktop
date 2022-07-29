class LoginModel {
  LoginModel({
    int? status,
    String? message,
    String? studentId,
    String? studentCode,
    String? name,
    String? email,
    String? address,
    String? phone,
    String? phoneFormatted,
    String? birthday,
    String? gender,
    String? image,
    bool? validity,
    String? academicYear,
    String? programmeName,
    String? schoolName,
    String? schoolLogo,
    String? studentQrcode,
    String? expiry,
    String? token,}){
    _status = status;
    _message = message;
    _studentId = studentId;
    _studentCode = studentCode;
    _name = name;
    _email = email;
    _address = address;
    _phone = phone;
    _phoneFormatted = phoneFormatted;
    _birthday = birthday;
    _gender = gender;
    _image = image;
    _validity = validity;
    _academicYear = academicYear;
    _programmeName = programmeName;
    _schoolName = schoolName;
    _schoolLogo = schoolLogo;
    _studentQrcode = studentQrcode;
    _expiry = expiry;
    _token = token;
  }

  LoginModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _studentId = json['student_id'];
    _studentCode = json['student_code'];
    _name = json['name'];
    _email = json['email'];
    _address = json['address'];
    _phone = json['phone'];
    _phoneFormatted = json['phone_formatted'];
    _birthday = json['birthday'];
    _gender = json['gender'];
    _image = json['image'];
    _validity = json['validity'];
    _academicYear = json['academic_year'];
    _programmeName = json['programme_name'];
    _schoolName = json['school_name'];
    _schoolLogo = json['school_logo'];
    _studentQrcode = json['student_qrcode'];
    _expiry = json['expiry'];
    _token = json['token'];
  }
  int? _status;
  String? _message;
  String? _studentId;
  String? _studentCode;
  String? _name;
  String? _email;
  String? _address;
  String? _phone;
  String? _phoneFormatted;
  String? _birthday;
  String? _gender;
  String? _image;
  bool? _validity;
  String? _academicYear;
  String? _programmeName;
  String? _schoolName;
  String? _schoolLogo;
  String? _studentQrcode;
  String? _expiry;
  String? _token;
  LoginModel copyWith({  int? status,
    String? message,
    String? studentId,
    String? studentCode,
    String? name,
    String? email,
    String? address,
    String? phone,
    String? phoneFormatted,
    String? birthday,
    String? gender,
    String? image,
    bool? validity,
    String? academicYear,
    String? programmeName,
    String? schoolName,
    String? schoolLogo,
    String? studentQrcode,
    String? expiry,
    String? token,
  }) => LoginModel(  status: status ?? _status,
    message: message ?? _message,
    studentId: studentId ?? _studentId,
    studentCode: studentCode ?? _studentCode,
    name: name ?? _name,
    email: email ?? _email,
    address: address ?? _address,
    phone: phone ?? _phone,
    phoneFormatted: phoneFormatted ?? _phoneFormatted,
    birthday: birthday ?? _birthday,
    gender: gender ?? _gender,
    image: image ?? _image,
    validity: validity ?? _validity,
    academicYear: academicYear ?? _academicYear,
    programmeName: programmeName ?? _programmeName,
    schoolName: schoolName ?? _schoolName,
    schoolLogo: schoolLogo ?? _schoolLogo,
    studentQrcode: studentQrcode ?? _studentQrcode,
    expiry: expiry ?? _expiry,
    token: token ?? _token,
  );
  int? get status => _status;
  String? get message => _message;
  String? get studentId => _studentId;
  String? get studentCode => _studentCode;
  String? get name => _name;
  String? get email => _email;
  String? get address => _address;
  String? get phone => _phone;
  String? get phoneFormatted => _phoneFormatted;
  String? get birthday => _birthday;
  String? get gender => _gender;
  String? get image => _image;
  bool? get validity => _validity;
  String? get academicYear => _academicYear;
  String? get programmeName => _programmeName;
  String? get schoolName => _schoolName;
  String? get schoolLogo => _schoolLogo;
  String? get studentQrcode => _studentQrcode;
  String? get expiry => _expiry;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['student_id'] = _studentId;
    map['student_code'] = _studentCode;
    map['name'] = _name;
    map['email'] = _email;
    map['address'] = _address;
    map['phone'] = _phone;
    map['phone_formatted'] = _phoneFormatted;
    map['birthday'] = _birthday;
    map['gender'] = _gender;
    map['image'] = _image;
    map['validity'] = _validity;
    map['academic_year'] = _academicYear;
    map['programme_name'] = _programmeName;
    map['school_name'] = _schoolName;
    map['school_logo'] = _schoolLogo;
    map['student_qrcode'] = _studentQrcode;
    map['expiry'] = _expiry;
    map['token'] = _token;
    return map;
  }

}