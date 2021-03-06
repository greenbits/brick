import 'package:brick_offline_first_abstract/annotations.dart';
import 'package:brick_rest/rest.dart' show Rest, RestSerializable;

final output = r'''
Future<NullableField> _$NullableFieldFromRest(Map<String, dynamic> data,
    {required RestProvider provider,
    OfflineFirstRepository? repository}) async {
  return NullableField(
      restFalse: data['rest_false'] as String?,
      nullableRestTrue: data['nullable_rest_true'] == null
          ? null
          : data['nullable_rest_true'] as String?,
      restTrue: data['rest_true'] as String,
      sqliteFalse: data['sqlite_false'] as String?,
      sqliteTrue: data['sqlite_true'] as String?);
}

Future<Map<String, dynamic>> _$NullableFieldToRest(NullableField instance,
    {required RestProvider provider,
    OfflineFirstRepository? repository}) async {
  return {
    'rest_false': instance.restFalse,
    'nullable_rest_true': instance.nullableRestTrue,
    'rest_true': instance.restTrue,
    'sqlite_false': instance.sqliteFalse,
    'sqlite_true': instance.sqliteTrue
  };
}

Future<NullableField> _$NullableFieldFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstRepository? repository}) async {
  return NullableField(
      restFalse: data['rest_false'] as String?,
      nullableRestTrue: data['nullable_rest_true'] as String?,
      restTrue: data['rest_true'] as String,
      sqliteFalse: data['sqlite_false'] as String?,
      sqliteTrue:
          data['sqlite_true'] == null ? null : data['sqlite_true'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$NullableFieldToSqlite(NullableField instance,
    {required SqliteProvider provider,
    OfflineFirstRepository? repository}) async {
  return {
    'rest_false': instance.restFalse,
    'nullable_rest_true': instance.nullableRestTrue,
    'rest_true': instance.restTrue,
    'sqlite_false': instance.sqliteFalse,
    'sqlite_true': instance.sqliteTrue
  };
}
''';

@ConnectOfflineFirstWithRest(
  restConfig: RestSerializable(nullable: false),
  sqliteConfig: SqliteSerializable(nullable: false),
)
class NullableField {
  NullableField({
    this.restFalse,
    this.nullableRestTrue,
    required this.restTrue,
    this.sqliteFalse,
    this.sqliteTrue,
  });

  @Rest(nullable: false)
  final String? restFalse;

  @Rest(nullable: true)
  final String? nullableRestTrue;

  @Rest(nullable: true)
  final String restTrue;

  @Sqlite(nullable: false)
  final String? sqliteFalse;

  @Sqlite(nullable: true)
  final String? sqliteTrue;
}
