import 'package:brick_sqlite_abstract/annotations.dart';
import 'package:brick_sqlite_abstract/sqlite_model.dart';

final output = r'''
// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite_abstract/db.dart';
// ignore: unused_import
import 'package:brick_sqlite_abstract/db.dart' show Migratable;

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final Set<Migration> migrations = <Migration>{};

/// A consumable database structure including the latest generated migration.
final schema = Schema(0, generatorVersion: 1, tables: <SchemaTable>{
  SchemaTable('IndexAnnotation', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', int,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('non_unique', String),
    SchemaColumn('unique', String, unique: true)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['non_unique'], unique: false),
    SchemaIndex(columns: ['unique'], unique: true)
  })
});
''';

/// [SqliteSerializable] **does not** produce code.
/// A `const` class is required from an non-relative import,
/// and [SqliteSerializable] was arbitrarily chosen for this test.
/// This will do nothing outside of this exact test suite.
@SqliteSerializable()
class IndexAnnotation extends SqliteModel {
  @Sqlite(index: true)
  final String nonUnique;

  @Sqlite(index: true, unique: true)
  final String unique;

  IndexAnnotation({this.nonUnique, this.unique});
}