import 'dart:convert' as convert;
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/models/bill.dart';
import 'package:restaurant_almalk_app/models/category.dart';
import 'package:restaurant_almalk_app/models/deliverycomp.dart';
import 'package:restaurant_almalk_app/models/detailbill.dart';
import 'package:restaurant_almalk_app/models/products.dart';
import 'package:restaurant_almalk_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

  String api_image = "http://192.168.43.68:8000";
  String api = "http://192.168.43.68:8000/api/";

  getproducts(String token_val) async {
    var list = [];
    var s=await SharedPreferences.getInstance();
    var lf=s.getStringList("favorite");
    List<String> favoritelist=lf!=null?lf:[];
    List<product> listproduct = [];
    var url = api+"food/getproducts";
    var response = await http.post(Uri.parse(url), body:{
      token: token_val});
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<
          String,
          dynamic>;
      list = jsonResponse["data"];
      try{list.forEach((element) {
        var np=element["Food_Name"];
        String name=np!=null?np:"bnjhgvkf";
        listproduct.add(product(
          isfavorite: favoritelist.contains(name),
            name: element["Food_Name"],
            image: api_image+element["Food_Image"],
            detels: element["Food_Detels"],
            insertdate: DateTime.parse(element["Food_Create_Date"]),
            categoryid: element["Food_Category_Id"],
            id: element["id"],
            rating: element["Food_Rate"],
            price: element["Food_Price"]));
      });}catch(_){
        print("2");
      }
      url = api+'food/getoffers';
      response = await http.post(Uri.parse(url), body: {
        token: token_val});
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        list = jsonResponse["data"];
        list.forEach((element) {
          listproduct.firstWhere((e) => e.id == element["Food_Id"]).istrender=true;
          listproduct.firstWhere((e) => e.id == element["Food_Id"]).newprice=element["Offer_Newprice"];
          listproduct.firstWhere((e) => e.id == element["Food_Id"]).offernote=element["Offer_Note"];
          listproduct.firstWhere((e) => e.id == element["Food_Id"]).offerstart=DateTime.parse(element["Offer_Start"]);
          listproduct.firstWhere((e) => e.id == element["Food_Id"]).offerend=DateTime.parse(element["Offer_End"]);
        });}
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    return listproduct;
    }

  getcategories(String token_val) async {
  var list = [];
  List<category> listcategories = [];
  var url = api+"food/getcategories";
  var response = await http.post(Uri.parse(url), body:{
    token: token_val});
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as Map<
        String,
        dynamic>;
    list = jsonResponse["data"];
    try{list.forEach((element) {
      listcategories.add(
          category(
          name: element["Category_Name"],
          image: api_image+element["Category_Image"],
          categoryid: element["Category_Id"]-1));
      });
    }catch(_){
      print("2");}
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return listcategories;
}

  getdeliverycompanies(String token_val) async {
  var list = [];
  List<deliverycopm> listcompanies = [];
  var url = api+"bill/getdeliverycompanies";
  var response = await http.post(Uri.parse(url), body:{
    token: token_val});
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as Map<
        String,
        dynamic>;
    list = jsonResponse["data"];
    try{list.forEach((element) {
      listcompanies.add(
          deliverycopm(
              phone: element["Delivery_Comphone"],
              id:element["Delivery_Comid"] ,
              name: element["Delivery_Comname"]));
    });
    }catch(_){
      print("2");}
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return listcompanies;
}

  getbills(String token_val) async {
  var list = [];
  List<bill> listbill = [];
  var url = api+"bill/getbills";
  var body={token: token_val};
  var response = await http.post(Uri.parse(url), body:body);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    list = jsonResponse["data"];
    try{list.forEach((element)
    {
      listbill.add(
          bill(id: element["id"],
              status:element["Bill_Status"],
              long: element['Long'],
              lat: element['Lat'],
              deliverycomid: element['Delivery_Comid']==null?0:element['Delivery_Comid'],
              deliveryid: element['Delivery_Id']==null?0:element['Delivery_Id'],
              address: element['Bill_Address'],
              regdate:DateTime.parse(element['Bill_Regdate'])));
    });
    }catch(_){
      print("2");}
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return listbill;
}

  getbilldetails(String token_val,int billid) async {
  var list = [];
  List<detailbill> listbilldetails = [];
  var url = api+"bill/getdetailbill";
  var body={token: token_val};
  var header={Bill_Id:billid.toString()};
  var response = await http.post(Uri.parse(url),headers:header , body:body);

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as Map<
        String,
        dynamic>;
    list = jsonResponse["data"];
    try{list.forEach((element) {
      listbilldetails.add(
        detailbill(
            id: element['id'],
            billid: billid,
            foodid: element['Food_Id'],
            foodcount: element['Food_Count'])
      );
    });
    }catch(_){
      print("4");}
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  return listbilldetails;
}

  setbill(String token_val,bill b) async {
    var url = api + "bill/setbill";
    int id=0;
    var header = {
      Delivery_Id: b.deliveryid.toString(),
      Bill_Address: b.address,
      Delivery_Comid: b.deliverycomid.toString(),
      Lat: b.lat.toString(),
      Long: b.long.toString()};
    var response = await http.post(Uri.parse(url), headers: header, body: {
      token: token_val});
   if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<
          String,
          dynamic>;
      id = jsonResponse["data"];
    }
   return id;
  }

  setdetailbill(String token_val,detailbill d) async {
      var url = api+"bill/setdetailbill";
      var header={
        Bill_Id:d.billid.toString(),
        Food_Id:d.foodid.toString(),
        Food_Count:d.foodcount.toString(),};
      var response = await http.post(Uri.parse(url),headers: header, body:{
        token: token_val});
      if(response.statusCode==200) {
        var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
        int id = jsonResponse["data"];
        d.id = id;
      }
  }

  removebill(String token_val,int billid,int cid) async {
  var url = api+"bill/removebill";
  var header={Bill_Id:billid.toString()};
  var response = await http.post(Uri.parse(url),headers: header, body:{
    token: token_val});
  if(response.statusCode==200)
    print('Request failed with status: ${response.statusCode}.');
}

  logoutuser(String token_val) async {
  var url = api+"user/logout";
  var response = await http.post(Uri.parse(url), body:{
    token: token_val});
  if(response.statusCode==200)
    print('Request failed with status: ${response.statusCode}.');
}

  loginuser(String email,String password) async {
  var url = api+"user/login";
  Map<String, dynamic> list={};
  user u=user(id: 0,
      name: "",
      image: "",
      phone: 0,
      email: "",
      password: "",
      block: 0,
      regdate: DateTime.now());
  var header={Customer_Email:email};
  var response = await http.post(Uri.parse(url),headers: header, body:{
    Customer_Password:password,});
  if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<
        String,
        dynamic>;
    list = jsonResponse["data"];
    try{
          u=user(id: list['customer_Id'],
              name: list['Customer_Name'],
              phone: list['Customer_Phone'],
              image: list['Customer_Image'],
              email: list['Customer_Email'],
              password: list['Customer_Password'],
              block: list['Customer_Block'],
              regdate: DateTime.parse(list['Customer_Regdate'].toString()),
              token: list['Customer_Token']);
    }catch(_){
      return u;}
   }else {
    return u;
  }
  return u;
}

  registeruser(user u) async {
  var url = api+"user/register";
  var list;
  var header={
    Customer_Email:u.email,
    Customer_Phone:u.phone.toString(),
    Customer_Name:u.name,};
  var response = await http.post(Uri.parse(url),headers: header, body:{
    Customer_Password:u.password,});
  if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    list = jsonResponse["data"];
    try{
      u.token=list['Customer_Token'];
      u.id=list['customer_Id'];
    }catch(_){
      print("4");}
  }else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

  changeusername(String token_val,String name,String password) async {
  var url = api+"user/changename";
  var header={
    Customer_Password:password,
    Customer_Name:name,};
  var response = await http.post(Uri.parse(url), body:{
    token: token_val},headers: header);
  if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    return jsonResponse["status"];
  }else return false;
}

  changeuserphone(String token_val,int phone,String password) async {
  var url = api+"user/changephone";
  var header={
    Customer_Password:password,
    Customer_Phone:phone.toString(),};
  var response = await http.post(Uri.parse(url), body:{
    token: token_val},headers: header);
  if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    return jsonResponse["status"];
  }else return false;
}

  changeuseremail(String token_val,String email,String password) async {
  var url = api+"user/changeemail";
  var header={
    Customer_Password:password,
    Customer_Email:email,};
  var response = await http.post(Uri.parse(url), body:{
    token: token_val},headers: header);
  if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    return jsonResponse["status"];
  }else return false;
}

  changeuserpassword(String token_val,String newpass,String oldpass) async {
  var url = api+"user/changepassword";
  var header={
    New_Customer_Password:newpass,
    Old_Customer_Password:oldpass,};
  var response = await http.post(Uri.parse(url), body:{
    token: token_val},headers: header);
  if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    return jsonResponse["status"];
  }else return false;
}