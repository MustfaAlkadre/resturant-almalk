import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
class myaccount extends StatefulWidget {
  @override
  _myaccountState createState() => _myaccountState();
}

class _myaccountState extends State<myaccount> {
  double w = 0,
      h = 0;
  var picker=ImagePicker();
  var file=new File("file:///A:/Users/nano/Pictures/Camera%20Roll/WIN_20211108_12_49_40_Pro.jpg");



  getImage() async {
    var p=await picker.pickMultiImage();
    Provider.of<mainProvider>(context).user1.image=p.first.path;
    print(Provider.of<mainProvider>(context).user1.image);
  }

  showd_dialog(){
    var ad=AlertDialog(
      backgroundColor: backgroundColor1,
      title: Text("اختيار صورة من:",style: TextStyle(color: textColor3),),
      alignment: Alignment.centerRight,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: dividerColor1,thickness: 2.0,height:10),
          SizedBox(height: 8.0),
          Container(
            width: 2*w/3,
            color: primaryColor,
            child: ListTile(
              title:Text("المعرض",style: TextStyle(color: textColor3),) ,
              leading: Icon(Icons.image,color: iconColor4),
              onTap: (){
                getImage();
                Navigator.of(context).pop();
              },
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: 2*w/3,
            color: primaryColor,
            child: ListTile(
              title:Text("كاميرا",style: TextStyle(color: textColor3)) ,
              leading: Icon(Icons.camera_enhance_rounded,color: iconColor4),
              onTap: (){
                getImage();
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
    showDialog(context: context, builder: (_)=>ad);
  }


  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Center(
            child:MaterialButton(
              onPressed: showd_dialog ,
              child:showimage(Provider.of<mainProvider>(context).user1.image),
          ),
        ),
        field("الاسم",Provider.of<mainProvider>(context).user1.name),
        field("الرقم",Provider.of<mainProvider>(context).user1.phone.toString()),
        field("الايميل",Provider.of<mainProvider>(context).user1.email),
      ],
    );
  }
  Widget field(String name,String v){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
       children: [
         Text(name,style:TextStyle(fontSize: 22,color: textColor1,fontWeight: FontWeight.bold) ,),
         Text(v,style:TextStyle(fontSize: 20,color: hintColor1,fontWeight: FontWeight.w700) ,),
         Divider(color: dividerColor1,thickness: 2.0),
       ],
      ),
    );
  }

  Widget showimage(String path){
    return path!=""? Container(
    height: h/3,
    child: Icon(Icons.account_circle,size: w/2,color: primaryColor),
    ):  Image(image:FileImage(new File(path)));
  }
}
