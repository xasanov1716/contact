class ContactModel {
  final String name;
  final String phone;
  final String contactId;
  final int creationDate;
  final String email;
  final String image;

  ContactModel(
      {required this.phone,
      required this.name,
      required this.image,
      required this.email,
      required this.contactId,
      required this.creationDate,});

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
      phone: json['phone'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      email: json['email'] as String? ?? '',
      creationDate: json['creationDate'] as int? ?? 0,
      contactId: json['contactId'] as String? ?? '');

  ContactModel copyWith({
    String? name,
    String? phone,
    String? contactId,
    String? image,
    String? email,
    int? creationDate,
  }) =>
      ContactModel(
          phone: phone ?? this.phone,
          name: name ?? this.name,
          image: image ?? this.image,
          email: email ?? this.email,
          contactId: contactId ?? this.contactId,
          creationDate: creationDate ?? this.creationDate,
          );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'image': image,
        'email': email,
        'contactId': contactId,
        'creationDate': creationDate,
      };
}

class ContactModelFields {
  static const String id = '_id';
  static const String name = '_name';
  static const String phone = "_phone";
  static const String email = '_email';
  static const String image = '_image';
  static const String creationDate = '_creation_date';

  static const tableName = 'contacts';
}

class ContactModelSql {
  final String name;
  final String phone;
  final String image;
  final String email;
  final int creationDate;
  int? id;

  ContactModelSql(
      {required this.name,
      required this.phone,
      required this.email,
      required this.image,
      required this.creationDate,
      this.id});

  factory ContactModelSql.fromJson(Map<String, dynamic> json) =>
      ContactModelSql(
          name: json[ContactModelFields.name] as String? ?? '',
          phone: json[ContactModelFields.phone] as String? ?? '',
          email: json[ContactModelFields.email] as String? ?? '',
          image: json[ContactModelFields.image] as String? ?? '',
          id: json[ContactModelFields.id] as int? ?? 0,
          creationDate: json[ContactModelFields.creationDate] as int? ?? 0);

  ContactModelSql copyWith(
          {String? name, String? phone, int? creationDate, int? id,String? image, String? email}) =>
      ContactModelSql(
          name: name ?? this.name,
          phone: phone ?? this.phone,
          email: email ?? this.email,
          image: image ?? this.image,
          id: id ?? this.id,
          creationDate: creationDate ?? this.creationDate);

  Map<String, dynamic> toJson() => {
        ContactModelFields.name: name,
        ContactModelFields.phone: phone,
        ContactModelFields.email: email,
        ContactModelFields.image: image,
        ContactModelFields.creationDate: creationDate,
        ContactModelFields.id: id
      };
}
