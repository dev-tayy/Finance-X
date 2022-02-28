import 'package:contacts_service/contacts_service.dart';

class Contact {
  Contact(
    this.displayName,
    this.emails,
    this.givenName,
    this.middleName,
    this.phones,
  );
  
  String? displayName;
  String? givenName;
  String? middleName;
  List<Item> emails;
  List<Item> phones;
}
