enum FailureType {
  server,
  network,
  maintenance(errorKey: 'maintenance'),
  deserialized,
  unknown;

  final String? errorKey;

  const FailureType({this.errorKey});
}
