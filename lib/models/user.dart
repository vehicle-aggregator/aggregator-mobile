class User{
  String name;
  String surname;
  int id;
  String email;
  String gender;
  DateTime birthDate;
  String lastname;

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

  User.fromJson(Map<String, dynamic> json){
    this.lastname = json["last_name"];
    this.gender = json['gender'];
    this.name = json['name'];
    this.surname = json['middle_name'];
    //print('date --> ${json['birthday'].toString().replaceAll("T"," ").substring(0,19)}');
    this.birthDate = DateTime.parse(json['birthday']);
    //this.birthDate = DateTime.parse(json['birthday'].toString().replaceAll("T"," ").substring(0,19));
    this.id = json['ID'];
    this.email = json['email'];
  }
}