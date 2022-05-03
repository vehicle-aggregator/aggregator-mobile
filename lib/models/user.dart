import 'package:intl/intl.dart';

class User{
  String name;
  String surname;
  int id;
  String email;
  String gender;
  DateTime birthDate;
  String lastname;
  int balance;

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
  }
}