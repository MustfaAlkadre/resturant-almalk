import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/category/requestdetels.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/models/bill.dart';

class myrequest extends StatefulWidget {
  @override
  _myrequestState createState() => _myrequestState();
}

class _myrequestState extends State<myrequest> {
  double w = 0, h = 0;
  bool page=true;
  List<bill> list1=[];
  List<bill> list2=[];

  getbill(BuildContext context)async{
    var t=Provider.of<mainProvider>(context).user1.token;
    Provider.of<mainProvider>(context).listbill=await getbills(t);
  }
  
  @override
  Widget build(BuildContext context) {
    list2=Provider.of<mainProvider>(context).listbill.where((element) => element.status<5).toList();
    list1=Provider.of<mainProvider>(context).listbill.where((element) => element.status==5).toList();
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: backgroundColor2,
        appBar: AppBar(
          shadowColor:  shadowColor,
          leading: Text(""),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: iconColor1,
                ))
          ],
          title: Center(
              child: Text(
            "طلباتي",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: textColor3),
          )),
          backgroundColor: headerColor2,
        ),
        body: Provider.of<mainProvider>(context).listbill.isEmpty?FutureBuilder(
            future: getbill(context),
            builder:(context,v){
              if(v.connectionState==ConnectionState.waiting)
                return Center(child:CircularProgressIndicator(),);
              list2=Provider.of<mainProvider>(context).listbill.where((element) => element.status<5).toList();
              list1=Provider.of<mainProvider>(context).listbill.where((element) => element.status==5).toList();
              return bodyr(context);
            }):bodyr(context),
    );
  }

  Widget bodyr(BuildContext context){
    return ListView(
      children:[
        Container(
          padding:EdgeInsets.all(5) ,
          color: primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  padding:EdgeInsets.all(5) ,
                  decoration: page?null:BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: buttonColor1,
                  ),
                  child:MaterialButton(
                    onPressed: (){setState(() {
                      page=false;
                    });},
                    child:Row(
                      children: [
                        Text("طلبات سابقة",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: textColor3)),
                        Icon(Icons.check,color: iconColor1)
                      ],
                    ),
                  )
              ),
              Container(
                  padding:EdgeInsets.all(5) ,
                  decoration:page? BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: buttonColor1,
                  ):null,
                  child:MaterialButton(
                    onPressed: (){setState(() {
                      page=true;
                    });},
                    child:Row(
                      children: [
                        Text("قيد التنفيذ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: textColor3)),
                        Icon(Icons.play_arrow_rounded,color: iconColor1,)
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
        reqbody(context),
      ],
    );
  }

  Widget requestitem(bill b){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor2,
        borderRadius: BorderRadius.circular(20),
        boxShadow:[ BoxShadow(color:shadowColor,offset: Offset(-5,10),blurRadius: 7 ) ] ,
      ),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(b.id.toString()+"رقم الفاتورة : ",style: TextStyle(fontWeight:FontWeight.w600 ,fontSize: 16,color: textColor3),),
          Text(b.address+"العنوان : ",style: TextStyle(fontWeight:FontWeight.w600 ,fontSize: 16,color: textColor3)),
          Text(b.regdate.toString()+"تاريخ الفاتورة : ",style: TextStyle(fontWeight:FontWeight.w600 ,fontSize: 16,color: textColor3))
        ],
      ),
    ) ;
  }
  
  Widget reqbody(BuildContext context){
    List<bill> list=page?list2:list1;
    return list.isEmpty? Center(heightFactor:h/50,child: Container(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow:[ BoxShadow(color:shadowColor,offset: Offset(-3,5),blurRadius: 10 ) ] ,
          ),
          child: Text("لا يوجد طلبات سابقة",style: TextStyle(fontWeight:FontWeight.w600 ,fontSize: 16,color: textColor3),),
        )):Column(
          children: [
            ...list.map((e) => MaterialButton(
                onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=>reqdetels(e))),
                child: requestitem(e))).toList(),
          ],
        );
  }
}
