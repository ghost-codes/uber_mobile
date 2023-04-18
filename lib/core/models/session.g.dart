// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['email'] as String,
      json['displayName'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'displayName': instance.displayName,
    };

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      json['isSignupComplete'] as bool,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      metadata: json['metadata'] == null
          ? null
          : MetaData.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'isSignupComplete': instance.isSignupComplete,
      'user': instance.user,
      'metadata': instance.metadata,
    };

MetaData _$MetaDataFromJson(Map<String, dynamic> json) => MetaData(
      json['phoneNumber'] as String,
      DateTime.parse(json['dateOfBirth'] as String),
      DateTime.parse(json['createdDate'] as String),
    );

Map<String, dynamic> _$MetaDataToJson(MetaData instance) => <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'createdDate': instance.createdDate.toIso8601String(),
    };
