class AuthCode {
  String documentId;
  Map<String, dynamic> data;

  AuthCode(this.documentId, this.data);

  String get code => data['code'];
  String get profileId => data['profile]'];
  bool get used => data['used'];
}
