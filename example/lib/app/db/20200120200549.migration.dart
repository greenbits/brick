// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20200120200549_up = [
  InsertTable("Customer"),
  InsertTable("Pizza"),
  InsertColumn("id", Column.integer, onTable: "Customer", unique: true),
  InsertColumn("first_name", Column.varchar, onTable: "Customer"),
  InsertColumn("last_name", Column.varchar, onTable: "Customer"),
  InsertColumn("pizzas", Column.varchar, onTable: "Customer"),
  InsertColumn("id", Column.integer, onTable: "Pizza", unique: true),
  InsertColumn("toppings", Column.varchar, onTable: "Pizza"),
  InsertForeignKey("Pizza", "Customer", foreignKeyColumn: "customer_Customer_brick_id"),
  InsertColumn("frozen", Column.boolean, onTable: "Pizza"),
];

const List<MigrationCommand> _migration_20200120200549_down = [
  DropTable("Customer"),
  DropTable("Pizza"),
  DropColumn("id", onTable: "Customer"),
  DropColumn("first_name", onTable: "Customer"),
  DropColumn("last_name", onTable: "Customer"),
  DropColumn("pizzas", onTable: "Customer"),
  DropColumn("id", onTable: "Pizza"),
  DropColumn("toppings", onTable: "Pizza"),
  DropColumn("frozen", onTable: "Pizza"),
  DropColumn("customer_Customer_brick_id", onTable: "Pizza")
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20200120200549',
  up: _migration_20200120200549_up,
  down: _migration_20200120200549_down,
)
class Migration20200120200549 extends Migration {
  const Migration20200120200549()
      : super(
          version: 20200120200549,
          up: _migration_20200120200549_up,
          down: _migration_20200120200549_down,
        );
}