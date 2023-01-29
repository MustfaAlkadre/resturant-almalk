class user {
  String name="";
  int phone=0;
  String password="";
  String email="";
  String image="";
  DateTime regdate=DateTime(2017);
  int id=0;
  int block=0;
  String token="";
  user({
     this.id=0,
    required this.phone,
    required this.name,
     this.image="",
    required this.email,
    required this.password,
     this.block=0,
    required this.regdate,
    this.token=""});
}

