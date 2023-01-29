import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/product/product.dart';
import 'package:restaurant_almalk_app/models/products.dart';
import 'package:restaurant_almalk_app/drawer/drawer.dart';
import 'package:restaurant_almalk_app/home/mainscreen.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
class tender extends StatefulWidget {
  const tender({Key? key}) : super(key: key);

  @override
  _tenderState createState() => _tenderState();
}

class _tenderState extends State<tender> {
  double w = 0,
      h = 0;


  @override
  Widget build(BuildContext context) {
    w = MediaQuery
        .of(context)
        .size
        .width;
    h = MediaQuery
        .of(context)
        .size
        .height;

    List<product> list = Provider.of<mainProvider>(context).listproduct.where((element) => element.istrender==true && element.categoryid!=0).toList();

    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: largcard(list[index]),
          );
        },)


      /* SingleChildScrollView(
      child: Column(
        children: [
          ...list.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: e,
          )).toList()
      ],),
    )*/;
  }

  Widget largcard(product p) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              width: w -40,
              height: h / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: cardColor2,
                boxShadow:[
                  BoxShadow(offset:Offset(-4, 10),color: shadowColor,blurRadius: 7),
                ] ,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right:w/2+10),
                    child: Text(
                      p.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right:w/2+ 10),
                    child: Text(
                      p.detels,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: hintColor1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right:w/2+ 13),
                    child: p.newprice == 0
                        ? Text(
                      p.price.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor1),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          p.newprice.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor1),
                        ),
                        Text(
                          p.price.toString(),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: lineThroughColor1,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: hintColor1),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right:w/2+ 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          p.rating.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor3),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.star, color:iconColor2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            child: Container(
              child: MaterialButton(
                onPressed: ()=>Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>myproduct(p))),
                height: h / 5,
                child: Container(
                  width: w / 2 - 20,
                  height: h / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image:
                    DecorationImage(fit: BoxFit.fill, image: NetworkImage(p.image)),
                  ),
                  child: Text(""),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}

