class Profile {
  String documentId;
  Map<String, dynamic> data;

  Profile(this.documentId, this.data);

  String get name => data['name'];
  String get email => data['email'];
  bool get isAdmin => data['is_admin'];
  String get phone => data['phone'];

  String displayName() {
    var _name = name;
    // if (isAdmin) {
    //   _name += ' (Admin)';
    // }
    return _name;
  }
}
