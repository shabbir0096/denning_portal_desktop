
class SubjectsModel {
  SubjectsModel({
      int? status, 
      String? message, 
      String? studentId, 
      List<Subjects>? subjects,}){
    _status = status;
    _message = message;
    _studentId = studentId;
    _subjects = subjects;
}

  SubjectsModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _studentId = json['student_id'];
    if (json['subjects'] != null) {
      _subjects = [];
      json['subjects'].forEach((v) {
        _subjects?.add(Subjects.fromJson(v));
      });
    }
  }
  int? _status;
  String? _message;
  String? _studentId;
  List<Subjects>? _subjects;
SubjectsModel copyWith({  int? status,
  String? message,
  String? studentId,
  List<Subjects>? subjects,
}) => SubjectsModel(  status: status ?? _status,
  message: message ?? _message,
  studentId: studentId ?? _studentId,
  subjects: subjects ?? _subjects,
);
  int? get status => _status;
  String? get message => _message;
  String? get studentId => _studentId;
  List<Subjects>? get subjects => _subjects;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['student_id'] = _studentId;
    if (_subjects != null) {
      map['subjects'] = _subjects?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// class_id : "3"
/// subject_id : "29"
/// section_id : "160"
/// subject_name : "Developing English Language Skills"
/// section_name : "Developing English Language Skills 1"
/// section_short_name : "DELS 1"

class Subjects {
  Subjects({
      String? classId, 
      String? subjectId, 
      String? sectionId, 
      String? subjectName, 
      String? sectionName, 
      String? sectionShortName,}){
    _classId = classId;
    _subjectId = subjectId;
    _sectionId = sectionId;
    _subjectName = subjectName;
    _sectionName = sectionName;
    _sectionShortName = sectionShortName;
}

  Subjects.fromJson(dynamic json) {
    _classId = json['class_id'];
    _subjectId = json['subject_id'];
    _sectionId = json['section_id'];
    _subjectName = json['subject_name'];
    _sectionName = json['section_name'];
    _sectionShortName = json['section_short_name'];
  }
  String? _classId;
  String? _subjectId;
  String? _sectionId;
  String? _subjectName;
  String? _sectionName;
  String? _sectionShortName;
Subjects copyWith({  String? classId,
  String? subjectId,
  String? sectionId,
  String? subjectName,
  String? sectionName,
  String? sectionShortName,
}) => Subjects(  classId: classId ?? _classId,
  subjectId: subjectId ?? _subjectId,
  sectionId: sectionId ?? _sectionId,
  subjectName: subjectName ?? _subjectName,
  sectionName: sectionName ?? _sectionName,
  sectionShortName: sectionShortName ?? _sectionShortName,
);
  String? get classId => _classId;
  String? get subjectId => _subjectId;
  String? get sectionId => _sectionId;
  String? get subjectName => _subjectName;
  String? get sectionName => _sectionName;
  String? get sectionShortName => _sectionShortName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['class_id'] = _classId;
    map['subject_id'] = _subjectId;
    map['section_id'] = _sectionId;
    map['subject_name'] = _subjectName;
    map['section_name'] = _sectionName;
    map['section_short_name'] = _sectionShortName;
    return map;
  }

}