
class GroupMessageModel {
  GroupMessageModel({
      int? status, 
      String? message, 
      String? studentId, 
      List<Messages>? messages,}){
    _status = status;
    _message = message;
    _studentId = studentId;
    _messages = messages;
}

  GroupMessageModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _studentId = json['student_id'];
    if (json['messages'] != null) {
      _messages = [];
      json['messages'].forEach((v) {
        _messages?.add(Messages.fromJson(v));
      });
    }
  }
  int? _status;
  String? _message;
  String? _studentId;
  List<Messages>? _messages;
GroupMessageModel copyWith({  int? status,
  String? message,
  String? studentId,
  List<Messages>? messages,
}) => GroupMessageModel(  status: status ?? _status,
  message: message ?? _message,
  studentId: studentId ?? _studentId,
  messages: messages ?? _messages,
);
  int? get status => _status;
  String? get message => _message;
  String? get studentId => _studentId;
  List<Messages>? get messages => _messages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['student_id'] = _studentId;
    if (_messages != null) {
      map['messages'] = _messages?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// group_message_thread_id : "1"
/// group_message_thread_code : "40d9b797415a1a3"
/// group_name : "all_students"
/// history : [{"group_message_id":"5","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"Hi everyone!&nbsp;","timestamp":"1652095385","read_status":null,"attached_file_name":null},{"group_message_id":"6","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"Hi everyone!&nbsp;","timestamp":"1652095713","read_status":null,"attached_file_name":null},{"group_message_id":"7","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"Hi everyone!&nbsp;","timestamp":"1652099217","read_status":null,"attached_file_name":null},{"group_message_id":"8","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"new message","timestamp":"1652099350","read_status":null,"attached_file_name":null},{"group_message_id":"9","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"new message","timestamp":"1652099486","read_status":null,"attached_file_name":null},{"group_message_id":"10","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"new message","timestamp":"1652099489","read_status":null,"attached_file_name":null},{"group_message_id":"11","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"new message","timestamp":"1652099504","read_status":null,"attached_file_name":null},{"group_message_id":"12","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"new message","timestamp":"1652099716","read_status":null,"attached_file_name":null},{"group_message_id":"13","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"new message","timestamp":"1652099749","read_status":null,"attached_file_name":null},{"group_message_id":"14","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"new message","timestamp":"1652099989","read_status":null,"attached_file_name":null},{"group_message_id":"15","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"hello again","timestamp":"1652100019","read_status":null,"attached_file_name":null},{"group_message_id":"16","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"hello again","timestamp":"1652100073","read_status":null,"attached_file_name":null},{"group_message_id":"17","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"hi guys","timestamp":"1652100135","read_status":null,"attached_file_name":null},{"group_message_id":"18","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"hello 1234","timestamp":"1652100165","read_status":null,"attached_file_name":null},{"group_message_id":"19","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"yes 1","timestamp":"1652100225","read_status":null,"attached_file_name":null},{"group_message_id":"20","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"yes 1","timestamp":"1652100299","read_status":null,"attached_file_name":null},{"group_message_id":"21","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"yes 1","timestamp":"1652100324","read_status":null,"attached_file_name":null},{"group_message_id":"22","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"yes 1","timestamp":"1652100339","read_status":null,"attached_file_name":null},{"group_message_id":"23","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"yes 1","timestamp":"1652100385","read_status":null,"attached_file_name":null},{"group_message_id":"24","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"yes 1","timestamp":"1652100413","read_status":null,"attached_file_name":null},{"group_message_id":"25","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"teacher-1","type":"teacher","sender_id":"1","sender_name":"Abdul Qadir Naeem"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"no class today","timestamp":"1652860145","read_status":null,"attached_file_name":null},{"group_message_id":"26","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"teacher-1","type":"teacher","sender_id":"1","sender_name":"Abdul Qadir Naeem"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"no class today","timestamp":"1652860337","read_status":null,"attached_file_name":null},{"group_message_id":"27","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"teacher-1","type":"teacher","sender_id":"1","sender_name":"Abdul Qadir Naeem"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"hello every1","timestamp":"1652867520","read_status":null,"attached_file_name":null},{"group_message_id":"28","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"teacher-1","type":"teacher","sender_id":"1","sender_name":"Abdul Qadir Naeem"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"hello every1","timestamp":"1652868161","read_status":null,"attached_file_name":null},{"group_message_id":"29","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"student-26","type":"student","sender_id":"26","sender_name":"Muhammad Samaim"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"next","timestamp":"1652872162","read_status":null,"attached_file_name":null},{"group_message_id":"30","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"teacher-1","type":"teacher","sender_id":"1","sender_name":"Abdul Qadir Naeem"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"new update","timestamp":"1652879324","read_status":null,"attached_file_name":null},{"group_message_id":"31","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"teacher-2","type":"teacher","sender_id":"2","sender_name":"Huzaifa Muqadam"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"classes will start at 11 am from tomorrow","timestamp":"1652879604","read_status":null,"attached_file_name":null},{"group_message_id":"32","group_message_thread_code":"40d9b797415a1a3","sender_data":{"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"},"reciever_data":{"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"},"message":"All classes will commence from Monday 23rd May.","timestamp":"1652955262","read_status":null,"attached_file_name":null}]

class Messages {
  Messages({
      String? groupMessageThreadId, 
      String? groupMessageThreadCode, 
      String? groupName, 
      List<History>? history,}){
    _groupMessageThreadId = groupMessageThreadId;
    _groupMessageThreadCode = groupMessageThreadCode;
    _groupName = groupName;
    _history = history;
}

  Messages.fromJson(dynamic json) {
    _groupMessageThreadId = json['group_message_thread_id'];
    _groupMessageThreadCode = json['group_message_thread_code'];
    _groupName = json['group_name'];
    if (json['history'] != null) {
      _history = [];
      json['history'].forEach((v) {
        _history?.add(History.fromJson(v));
      });
    }
  }
  String? _groupMessageThreadId;
  String? _groupMessageThreadCode;
  String? _groupName;
  List<History>? _history;
Messages copyWith({  String? groupMessageThreadId,
  String? groupMessageThreadCode,
  String? groupName,
  List<History>? history,
}) => Messages(  groupMessageThreadId: groupMessageThreadId ?? _groupMessageThreadId,
  groupMessageThreadCode: groupMessageThreadCode ?? _groupMessageThreadCode,
  groupName: groupName ?? _groupName,
  history: history ?? _history,
);
  String? get groupMessageThreadId => _groupMessageThreadId;
  String? get groupMessageThreadCode => _groupMessageThreadCode;
  String? get groupName => _groupName;
  List<History>? get history => _history;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['group_message_thread_id'] = _groupMessageThreadId;
    map['group_message_thread_code'] = _groupMessageThreadCode;
    map['group_name'] = _groupName;
    if (_history != null) {
      map['history'] = _history?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// group_message_id : "5"
/// group_message_thread_code : "40d9b797415a1a3"
/// sender_data : {"sender":"admin-1","type":"admin","sender_id":"1","sender_name":"Denning Law School"}
/// reciever_data : {"reciever":"student-26","type":"student","reciever_id":"26","reciever_name":"Muhammad Samaim"}
/// message : "Hi everyone!&nbsp;"
/// timestamp : "1652095385"
/// read_status : null
/// attached_file_name : null

class History {
  History({
      String? groupMessageId, 
      String? groupMessageThreadCode, 
      SenderData? senderData, 
      RecieverData? recieverData, 
      String? message, 
      String? timestamp, 
      dynamic readStatus, 
      dynamic attachedFileName,}){
    _groupMessageId = groupMessageId;
    _groupMessageThreadCode = groupMessageThreadCode;
    _senderData = senderData;
    _recieverData = recieverData;
    _message = message;
    _timestamp = timestamp;
    _readStatus = readStatus;
    _attachedFileName = attachedFileName;
}

  History.fromJson(dynamic json) {
    _groupMessageId = json['group_message_id'];
    _groupMessageThreadCode = json['group_message_thread_code'];
    _senderData = json['sender_data'] != null ? SenderData.fromJson(json['sender_data']) : null;
    _recieverData = json['reciever_data'] != null ? RecieverData.fromJson(json['reciever_data']) : null;
    _message = json['message'];
    _timestamp = json['timestamp'];
    _readStatus = json['read_status'];
    _attachedFileName = json['attached_file_name'];
  }
  String? _groupMessageId;
  String? _groupMessageThreadCode;
  SenderData? _senderData;
  RecieverData? _recieverData;
  String? _message;
  String? _timestamp;
  dynamic _readStatus;
  dynamic _attachedFileName;
History copyWith({  String? groupMessageId,
  String? groupMessageThreadCode,
  SenderData? senderData,
  RecieverData? recieverData,
  String? message,
  String? timestamp,
  dynamic readStatus,
  dynamic attachedFileName,
}) => History(  groupMessageId: groupMessageId ?? _groupMessageId,
  groupMessageThreadCode: groupMessageThreadCode ?? _groupMessageThreadCode,
  senderData: senderData ?? _senderData,
  recieverData: recieverData ?? _recieverData,
  message: message ?? _message,
  timestamp: timestamp ?? _timestamp,
  readStatus: readStatus ?? _readStatus,
  attachedFileName: attachedFileName ?? _attachedFileName,
);
  String? get groupMessageId => _groupMessageId;
  String? get groupMessageThreadCode => _groupMessageThreadCode;
  SenderData? get senderData => _senderData;
  RecieverData? get recieverData => _recieverData;
  String? get message => _message;
  String? get timestamp => _timestamp;
  dynamic get readStatus => _readStatus;
  dynamic get attachedFileName => _attachedFileName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['group_message_id'] = _groupMessageId;
    map['group_message_thread_code'] = _groupMessageThreadCode;
    if (_senderData != null) {
      map['sender_data'] = _senderData?.toJson();
    }
    if (_recieverData != null) {
      map['reciever_data'] = _recieverData?.toJson();
    }
    map['message'] = _message;
    map['timestamp'] = _timestamp;
    map['read_status'] = _readStatus;
    map['attached_file_name'] = _attachedFileName;
    return map;
  }

}

/// reciever : "student-26"
/// type : "student"
/// reciever_id : "26"
/// reciever_name : "Muhammad Samaim"

class RecieverData {
  RecieverData({
      String? reciever, 
      String? type, 
      String? recieverId, 
      String? recieverName,}){
    _reciever = reciever;
    _type = type;
    _recieverId = recieverId;
    _recieverName = recieverName;
}

  RecieverData.fromJson(dynamic json) {
    _reciever = json['reciever'];
    _type = json['type'];
    _recieverId = json['reciever_id'];
    _recieverName = json['reciever_name'];
  }
  String? _reciever;
  String? _type;
  String? _recieverId;
  String? _recieverName;
RecieverData copyWith({  String? reciever,
  String? type,
  String? recieverId,
  String? recieverName,
}) => RecieverData(  reciever: reciever ?? _reciever,
  type: type ?? _type,
  recieverId: recieverId ?? _recieverId,
  recieverName: recieverName ?? _recieverName,
);
  String? get reciever => _reciever;
  String? get type => _type;
  String? get recieverId => _recieverId;
  String? get recieverName => _recieverName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reciever'] = _reciever;
    map['type'] = _type;
    map['reciever_id'] = _recieverId;
    map['reciever_name'] = _recieverName;
    return map;
  }

}

/// sender : "admin-1"
/// type : "admin"
/// sender_id : "1"
/// sender_name : "Denning Law School"

class SenderData {
  SenderData({
      String? sender, 
      String? type, 
      String? senderId, 
      String? senderName,}){
    _sender = sender;
    _type = type;
    _senderId = senderId;
    _senderName = senderName;
}

  SenderData.fromJson(dynamic json) {
    _sender = json['sender'];
    _type = json['type'];
    _senderId = json['sender_id'];
    _senderName = json['sender_name'];
  }
  String? _sender;
  String? _type;
  String? _senderId;
  String? _senderName;
SenderData copyWith({  String? sender,
  String? type,
  String? senderId,
  String? senderName,
}) => SenderData(  sender: sender ?? _sender,
  type: type ?? _type,
  senderId: senderId ?? _senderId,
  senderName: senderName ?? _senderName,
);
  String? get sender => _sender;
  String? get type => _type;
  String? get senderId => _senderId;
  String? get senderName => _senderName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sender'] = _sender;
    map['type'] = _type;
    map['sender_id'] = _senderId;
    map['sender_name'] = _senderName;
    return map;
  }

}