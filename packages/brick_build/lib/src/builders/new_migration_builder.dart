import 'package:brick_build/src/builders/sqlite_base_builder.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// Create a new [Migration] from the contents of all [ConnectOfflineFirst] models
class NewMigrationBuilder extends SqliteBaseBuilder {
  @override
  final outputExtension = '.migration_builder.dart';

  NewMigrationBuilder(AnnotationSuperGenerator generator) : super(generator);

  @override
  Future<void> build(BuildStep buildStep) async {
    final libraryReader = LibraryReader(await buildStep.inputLibrary);
    final fieldses = await sqliteFieldsFromBuildStep(buildStep);
    final now = DateTime.now().toUtc();
    final timestamp = [now.month, now.day, now.hour, now.minute, now.second]
        .map(_padToTwo)
        .toList()
        .cast<String>()
        .join('');
    final version = int.parse('${now.year}$timestamp');
    final output = schemaGenerator.createMigration(libraryReader, fieldses, version: version);

    if (output == null) {
      return null;
    }

    final stopwatch = Stopwatch();
    stopwatch.start();

    // in a perfect world, the schema would not be edited in such a brittle way
    // however, reruning the schema generator here doesn't pick up the new migration
    // because it uses the LibraryReader from before the migration is created.
    // this should be revisited in a few build versions to make this flow less brittle
    // and more predictable by using the same schema generator to do all the heavy lifting
    final newPart = "show Migratable;\npart '$version.migration.dart';";
    final newSetPiece = 'final Set<Migration> migrations = Set.from([\n  Migration$version(),';

    await replaceWithinFile(
      'db/schema.g.dart',
      'final Set<Migration> migrations = Set.from([',
      newSetPiece,
    );
    await replaceWithinFile(
      'db/schema.g.dart',
      'show Migratable;',
      newPart,
    );
    await manuallyUpsertAppFile('db/$version.migration.dart', output);
    await buildStep.writeAsString(buildStep.inputId.changeExtension(outputExtension), output);
    await replaceWithinFile(
      'db/schema.g.dart',
      RegExp(r'final schema = Schema\(([\d]+|null),'),
      'final schema = Schema($version,',
    );
    logStopwatch('Generated new migration (db/$version.migration.dart)', stopwatch);
  }
}

String _padToTwo(int value) => value.toString().padLeft(2, '0');
