enum SyncStatus {
  synced('synced'),
  pendingCreate('pending_create'),
  pendingUpdate('pending_update'),
  pendingDelete('pending_delete');

  final String value;
  const SyncStatus(this.value);

  static SyncStatus fromValue(String value) {
    return SyncStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => SyncStatus.synced,
    );
  }
}
