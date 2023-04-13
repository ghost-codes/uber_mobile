class Error {
  const Error(
    this.message,
    this.code, {
    this.fields,
  });

  factory Error.fromJson(Map<String, dynamic> datamap) {
    final _fieldsData = datamap['fields'];
    return Error(
      datamap['message'],
      datamap['code'],
      fields: _fieldsData == null
          ? null
          : (_fieldsData as Iterable).map((e) => Field.fromJson(e)).toList(),
    );
  }

  final int? code;
  final String? message;
  final List<Field>? fields;

  String? get displayMessage {
    final fields = this.fields ?? [];
    if (fields.isEmpty) return message;

    var messages = [];
    for (final field in fields) {
      messages.add('${field.field![0].toUpperCase()}${field.field!.substring(1)} ${field.message}');
    }

    return messages.join('\n');
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'fields': fields,
      };
}

class Field {
  const Field({this.field, this.message});

  factory Field.fromJson(Map<String, dynamic> datamap) {
    return Field(
      field: datamap['field'],
      message: datamap['message'],
    );
  }

  final String? field;
  final String? message;

  Map<String, dynamic> toJson() => {
        'field': field,
        'message': message,
      };
}
