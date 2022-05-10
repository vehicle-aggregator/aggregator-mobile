import 'package:intl/intl.dart';

class Man{
  String name;
  String surname;
  String lastname;
  DateTime birthDate;
}

class User{
  String name;
  String surname;
  int id;
  String email;
  String gender;
  DateTime birthDate;
  String lastname;
  int balance;
  List<Passenger> passengers = [];

  User();

  discharge(){
    this.lastname = null;
    this.surname = null;
    this.name = null;
    this.email = null;
    this.gender = null;
    this.birthDate = null;
    this.id = null;
  }


  User.fromToken(){
    //TODO
  }

  Map<String, dynamic> toJson({String password = ''}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastname'] = this.lastname;
    data['name'] = this.name;
    data['middlename'] = this.surname;
    data['birthday'] = DateFormat("yyyy-MM-dd").format(this.birthDate);
    data['coins'] = 0;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['password'] = password;
    return data;
  }

  User.fromJson(Map<String, dynamic> json){
    this.lastname = json["last_name"];
    this.gender = json['gender'];
    this.name = json['name'];
    this.surname = json['middle_name'];

    this.birthDate = DateTime.parse(json['birthday']);
    this.id = json['ID'];
    this.email = json['email'];
    this.balance = json['CasualUser'] == null ? null : json['CasualUser'][0]['Balance'];
    this.passengers = [];
    var passengers = json['CasualUser'] == null ? null : json['CasualUser'][0]['Passenger'];
    passengers.forEach((e) {
      this.passengers.add(Passenger.fromJson(e));
    });
  }
}

class Passenger extends Man{
  int id;
  String docdetail;
  String doctype;
  bool me = false;

  Passenger();
  Passenger.fromJson(Map<String, dynamic> json){
    print('AAAAAAAAA ==> ${json['LastName']}');
    print('---> ${json['ID'] is int}');
    this.id = json['ID'];
    // this.doctype = json['DocumentTypeP'];
    // this.docdetail = json['DocumentDetail'];
    this.lastname = json['LastName'];
    this.surname = json['MiddleName'];
    this.name = json['Name'];
    this.birthDate = DateTime.parse(json['Birthday']);
  }

  bool isValid(){
    return
      this.surname != null && this.surname != '' &&
      this.name != null && this.name != '' &&
      this.lastname != null && this.lastname != '' &&
      this.birthDate != null &&
      this.docdetail != null && this.docdetail != '' &&
      this.doctype != null && this.doctype != ''
    ;
  }
}