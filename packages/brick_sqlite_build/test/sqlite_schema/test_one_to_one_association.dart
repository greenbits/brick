import 'package:brick_sqlite_abstract/annotations.dart';
import 'package:brick_sqlite_abstract/sqlite_model.dart';
import '../__helpers__.dart';

@ConnectAnnotation()
class SqliteAssoc extends SqliteModel {
  @Sqlite(ignore: true)
  final int key = -1;
}

final output = r'''
// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite_abstract/db.dart';
// ignore: unused_import
import 'package:brick_sqlite_abstract/db.dart' show Migratable;

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final Set<Migration> migrations = Set.from([]);

/// A consumable database structure including the latest generated migration.
final schema = Schema(0,
    generatorVersion: 1,
    tables: Set<SchemaTable>.from([
      SchemaTable("SqliteAssoc",
          columns: Set.from([
            SchemaColumn("_brick_id", int,
                autoincrement: true, nullable: false, isPrimaryKey: true)
          ])),
      SchemaTable("OneToOneAssocation",
          columns: Set.from([
            SchemaColumn("_brick_id", int,
                autoincrement: true, nullable: false, isPrimaryKey: true),
            SchemaColumn("assoc_SqliteAssoc_brick_id", int,
                isForeignKey: true, foreignTableName: "SqliteAssoc"),
            SchemaColumn("assoc2_SqliteAssoc_brick_id", int,
                isForeignKey: true, foreignTableName: "SqliteAssoc")
          ]))
    ]));
''';

@ConnectAnnotation()
class OneToOneAssocation extends SqliteModel {
  final SqliteAssoc assoc;
  final SqliteAssoc assoc2;

  OneToOneAssocation({this.assoc, this.assoc2});
}
