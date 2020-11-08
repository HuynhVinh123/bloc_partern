abstract class MigrationBase {
  // Version before
  String startVersion;
  String endVersion;
  Future up();
}
