import 'package:brick_sqlite_abstract/annotations.dart';
import 'package:brick_sqlite_abstract/sqlite_model.dart';

@SqliteSerializable()
class PrimaryKeyField extends SqliteModel {
  final int primaryKey;

  PrimaryKeyField(this.primaryKey);
}
