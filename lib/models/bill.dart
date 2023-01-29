import 'package:restaurant_almalk_app/models/detailbill.dart';

class bill {
  String address="";
  int id=0;
  int deliveryid=0;
  int deliverycomid=0;
  int status=0;
  double lat=0;
  double long=0;
  var regdate=DateTime(2017);
  List<detailbill> listdetailbill=[];
  bill({
    required this.id,
    required this.status,
    required this.long,
    required this.lat,
    required this.deliverycomid,
    required this.deliveryid,
    required this.address,
    required this.regdate,});
}