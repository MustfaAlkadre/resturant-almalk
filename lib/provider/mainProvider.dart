import 'package:flutter/material.dart';
import 'package:restaurant_almalk_app/category/changedata.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:restaurant_almalk_app/models/bill.dart';
import 'package:restaurant_almalk_app/models/category.dart';
import 'package:restaurant_almalk_app/models/deliverycomp.dart';
import 'package:restaurant_almalk_app/models/detailbill.dart';
import 'package:restaurant_almalk_app/models/products.dart';
import 'package:restaurant_almalk_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mainProvider with ChangeNotifier{
  int count=0;
  int selectedcaregory=2;
  user user1=user(id: 0,
      phone: 0,
      name: "",
      image: "",
      email: "",
      password: "",
      block: 0,
      regdate: DateTime.now());
  List<category> listcategory=[];
  List<product> listproduct=[];
  List<bill> listbill=[];
  List<product> listsearch=[];
  List<deliverycopm> listcompanies=[];


  changeuserdata(int index,String text){
    if(index==1)
      user1.name=text;
    else if(index==2)
      user1.phone=int.parse(text);
    else if(index==3)
      user1.email=text;
    else
      user1.password=text;
  }


  SaveDataOfUser(SharedPreferences s){
    s.setString("name",user1.name);
    s.setString("email",user1.email);
    s.setString("token", user1.token);
    s.setString("password",user1.password);
    s.setString("regdate", user1.regdate.toString());
    s.setInt("id", user1.id);
    s.setInt("phone",user1.phone);
    s.setInt("block",user1.block);
  }

  RemoveUserDataUser(SharedPreferences s){
    s.remove("name");
    s.remove("email");
    s.remove("token");
    s.remove("password");
    s.remove("regdate");
    s.remove("id");
    s.remove("phone");
    s.remove("block");
  }

  LoadUserData(SharedPreferences s){
    var name =  s.getString("name");
    var email =  s.getString("email") ;
    var token =  s.getString("token");
    var password =  s.getString("password");
    var regdate = s.getString("regdate");
    var id = s.getInt("id");
    var phone = s.getInt("phone");
    var block = s.getInt("block");
    user1.name=name!=null?name:"";
    user1.email=email!=null?email:"";
    user1.token=token!=null?token:"";
    user1.password=password!=null?password:"";
    user1.regdate=DateTime.parse(regdate!=null?regdate:"2017-12-12");
    user1.id=id!=null?id:0;
    user1.phone=phone!=null?phone:0;
    user1.block=block!=null?block:0;
  }

  addProductCount(int id){
    listproduct.firstWhere((element) => element.id==id).countitem++;
    if(!listproduct.firstWhere((element) => element.id==id).inshpping_bag)
      listproduct.firstWhere((element) => element.id==id).inshpping_bag=true;
    count++;
    notifyListeners();
  }

  subProductCount(int id){
    if(listproduct.firstWhere((element) => element.id==id).countitem>0){
      if(listproduct.firstWhere((element) => element.id==id).countitem==1)
        listproduct.firstWhere((element) => element.id==id).inshpping_bag=false;
      listproduct.firstWhere((element) => element.id==id).countitem--;
      count--;
    }
    notifyListeners();
  }

  removeProduct(int id){
    count-=listproduct.firstWhere((element) => element.id==id).countitem;
    listproduct.firstWhere((element) => element.id==id).inshpping_bag=false;
    listproduct.firstWhere((element) => element.id==id).countitem=0;
    notifyListeners();
  }

  categoryselected(int id){
    listcategory.forEach((element)=> element.isselected=false);
    listcategory.firstWhere((element) => element.categoryid==id).isselected=true;
    selectedcaregory=id;
    notifyListeners();
  }

  switchfavorite(int id)async{
    var s=await SharedPreferences.getInstance();
    var lf=s.getStringList("favorite");

    List<String> favoritelist=lf!=null?lf:[];
    var name=listproduct.firstWhere((element) => element.id==id).name;
    listproduct.firstWhere((element) => element.id==id).isfavorite?
      favoritelist.remove(name):favoritelist.add(name);
    s.setStringList("favorite", favoritelist);
    listproduct.firstWhere((element) => element.id==id).isfavorite=!listproduct.firstWhere((element) => element.id==id).isfavorite;
    notifyListeners();
  }




  search(String s){
    listsearch=listproduct.where((element) => element.name.contains(s)).toList();
    notifyListeners();
  }



  switchthemedata()async{
    var s=await SharedPreferences.getInstance();
    s.setBool("isdark", isdark);
    notifyListeners();
  }


  switchtheme(){
    primaryColor= isdark?Colors.teal.shade900:Colors.tealAccent;
    backgroundColor1=isdark?Colors.black.withOpacity(0.7): Colors.white;
    backgroundColor2=isdark?Colors.black.withOpacity(0.7): Colors.grey[100];
    backgroundColor3=isdark?Colors.red: Colors.red;
    buttonColor1=isdark?Colors.lime:Colors.lime[200] ;
    buttonColor2=isdark?Colors.black.withOpacity(0.7):Colors.white ;
    buttonColor3=isdark?Colors.red:Colors.red ;
    shadowColor=isdark?Colors.white38: Colors.black38;
    hintColor1=isdark?Colors.white70:Colors.grey[300] ;
    headerColor1=isdark?Colors.black.withOpacity(0.7):Colors.white ;
    headerColor2=isdark?Colors.black.withOpacity(0.4):Colors.white70 ;
    iconColor1=isdark?Colors.white:Colors.black ;
    iconColor2=isdark?Colors.yellowAccent:Colors.yellowAccent ;
    iconColor3=isdark?Colors.black:Colors.white ;
    iconColor4=isdark?Colors.black.withOpacity(0.2):Colors.grey ;
    textColor1=isdark?Colors.lime:Colors.lime ;
    textColor2=isdark?Colors.black:Colors.white ;
    textColor3=isdark?Colors.white:Colors.black ;
    cardColor1=isdark?Colors.black.withOpacity(0.4):Colors.grey[100] ;
    cardColor2=isdark?Colors.black.withOpacity(0.7):Colors.white ;
    lineThroughColor1=isdark?Colors.white:Colors.black ;
    dividerColor1=isdark?Colors.white:Colors.black ;
    dividerColor2=isdark?Colors.grey:Colors.grey ;
    notifyListeners();
  }


}