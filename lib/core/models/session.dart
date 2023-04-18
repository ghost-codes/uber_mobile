import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@JsonSerializable()
class User {
  final String email;
  final String displayName;

  User(this.email, this.displayName);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Session {
  final bool isSignupComplete;
  User? user;
  MetaData? metadata;

  Session(this.isSignupComplete, {this.user, this.metadata});

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}

@JsonSerializable()
class MetaData {
  final String phoneNumber;
  final DateTime dateOfBirth;
  final DateTime createdDate;

  MetaData(this.phoneNumber, this.dateOfBirth, this.createdDate);

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);
  Map<String, dynamic> toJson() => _$MetaDataToJson(this);
}
