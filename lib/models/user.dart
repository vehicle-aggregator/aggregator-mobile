class User{
  String name;
  String surname;
  String id;
  String email;
  String gender;
  DateTime birthDate;
  String login;

  discharge(){
    this.login = null;
    this.surname = null;
    this.name = null;
    this.email = null;
    this.gender = null;
    this.birthDate = null;
    this.id = null;
  }
}