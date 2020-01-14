// Heavily, heavily inspired by [Aqueduct](https://github.com/stablekernel/aqueduct/blob/master/aqueduct/lib/src/db/schema/schema_builder.dart)
// Unfortunately, some key differences such as inability to use mirrors and the sqlite vs postgres capabilities make DIY a more palatable option than retrofitting
import 'package:meta/meta.dart' show required, visibleForTesting;

import 'migration.dart';
import 'migration_commands.dart';
import 'migration_manager.dart';
import 'schema/schema_column.dart';
import 'schema/schema_table.dart';

export 'package:brick_sqlite_abstract/src/db/schema/schema_table.dart';
export 'package:brick_sqlite_abstract/src/db/schema/schema_column.dart';
export 'package:brick_sqlite_abstract/src/db/schema/schema_difference.dart';

class Schema {
  /// The last version successfully migrated to SQLite.
  /// This should be before or equal to [MigrationManager]'s `#version`.
  /// if [MigrationManager] is used.
  final int version;

  final Set<SchemaTable> tables;

  /// Version used to produce this scheme
  final int generatorVersion;

  Schema(this.version, {@required this.tables, this.generatorVersion = GENERATOR_VERSION});

  static const int GENERATOR_VERSION = 1;

  @visibleForTesting
  static List<MigrationCommand> expandMigrations(Set<Migration> migrations) {
    final sorted = migrations.toList();
    sorted.sort((a, b) {
      if (a.version == b.version) {
        return 0;
      }

      return a.version > b.version ? 1 : -1;
    });

    return sorted.map((m) => m.up).expand((c) => c).toList().cast<MigrationCommand>();
  }

  /// Create a schema from a set of migrations. If [version] is not provided,
  /// the highest migration version will be used
  factory Schema.fromMigrations(Set<Migration> migrations, [int version]) {
    assert((version == null) || (version != null && version > -1));
    version = version ?? MigrationManager.latestMigrationVersion(migrations);
    final commands = expandMigrations(migrations);
    final tables = commands.fold(<SchemaTable>{}, _commandToSchema);

    return Schema(
      version,
      tables: tables,
    );
  }

  /// A sub-function of [fromMigrations], convert a migration command into a `SchemaObject`.
  static Set<SchemaTable> _commandToSchema(Set<SchemaTable> tables, MigrationCommand command) {
    SchemaTable findTable(String tableName) {
      return tables.firstWhere(
        (s) => s.name == tableName,
        orElse: () => throw StateError('Table $tableName must be inserted first'),
      );
    }

    if (command is InsertTable) {
      tables.add(SchemaTable(command.name));

      final table = tables.firstWhere((s) => s.name == command.name);
      table.columns.add(SchemaColumn(
        InsertTable.PRIMARY_KEY_COLUMN,
        int,
        autoincrement: true,
        nullable: false,
        isPrimaryKey: true,
      ));
    } else if (command is RenameTable) {
      final table = findTable(command.oldName);
      tables.add(SchemaTable(command.newName, columns: table.columns..toSet()));
      tables.remove(table);
    } else if (command is DropTable) {
      final table = findTable(command.name);
      tables.remove(table);
    } else if (command is InsertColumn) {
      final table = findTable(command.onTable);
      table.columns.add(SchemaColumn(
        command.name,
        Migration.toDartPrimitive(command.definitionType),
        autoincrement: command.autoincrement,
        defaultValue: command.defaultValue,
        isPrimaryKey: false,
        nullable: command.nullable,
        unique: command.unique,
      ));
    } else if (command is RenameColumn) {
      final table = findTable(command.onTable);
      final column = table.columns.firstWhere(
        (s) => s.name == command.oldName,
        orElse: () => throw StateError('Column ${command.oldName} must be inserted first'),
      );
      final newColumn = column..name = command.newName;

      table.columns.add(newColumn);
      table.columns.remove(column);
    } else if (command is DropColumn) {
      final table = findTable(command.onTable);
      final column = table.columns.firstWhere(
        (s) => s.name == command.name,
        orElse: () => throw StateError('Column ${command.name} must be inserted first'),
      );
      table.columns.remove(column);
    } else if (command is InsertForeignKey) {
      final table = findTable(command.localTableName);
      table.columns.add(SchemaColumn(
        command.foreignKeyColumn,
        int,
        isForeignKey: true,
        foreignTableName: command.foreignTableName,
      ));
    } else {
      throw FallThroughError();
    }

    return tables;
  }

  /// Output for generator
  String get forGenerator {
    final tableString = tables
        .map((t) => t.forGenerator.replaceAll('\n\t', '\n\t\t\t').replaceAll('\n)', '\n\t\t)'))
        .join(',\n\t\t');

    return '''Schema(
\t$version,
\tgeneratorVersion: $generatorVersion,
\ttables: Set<SchemaTable>.from([
\t\t$tableString
\t])
)'''
        .replaceAll('\t', '  ');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Schema && version == other?.version && tables == other?.tables;

  @override
  int get hashCode => version.hashCode ^ tables.hashCode;
}
