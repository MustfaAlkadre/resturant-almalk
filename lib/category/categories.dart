import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/drawer/drawer.dart';
import 'package:restaurant_almalk_app/home/search.dart';
import 'package:restaurant_almalk_app/models/category.dart';
import 'package:restaurant_almalk_app/product/product.dart';
import 'package:restaurant_almalk_app/models/products.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:restaurant_almalk_app/shopping_bag/shopping_bag.dart';

class mycategory extends StatefulWidget {
  @override
  _mycategoryState createState() => _mycategoryState();
}

class _mycategoryState extends State<mycategory> {
  double w = 0,
      h = 0;
  List<product> list1=[];
  List<product> list2=[],list3=[];

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
    int cid=Provider.of<mainProvider>(context).selectedcaregory;
    list1 = Provider.of<mainProvider>(context).listproduct.where((element) => element.categoryid==cid).toList();
    list3=[];list2=[];
    for(int i=list1.length;i>0;i--){
      if(i%2!=0)
        list2.add(list1[i-1]);
      else
        list3.add(list1[i-1]);
    };
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar:  AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 30.0),
          child: Text("الفئات",style: TextStyle(fontWeight: FontWeight.bold,fontSize:22,color: textColor3 ),),
        ),
        shadowColor: shadowColor,
        backgroundColor: headerColor1,
        leading:Container(
          child: Row(
              children:[
                IconButton(
                  iconSize: 30,
                  onPressed: null,
                  icon: Container(
                    child: Stack(
                      children: [
                        Positioned(
                          top: -10,
                          left: -10,
                          child: Container(
                            margin: EdgeInsets.only(left: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10) ,
                            ),
                            child: IconButton(onPressed:()=> Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=>shopping_bag())
                            ),
                              icon: Icon(Icons.shopping_bag_outlined,color: iconColor1),),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: 2 , right: 2),
                            decoration: BoxDecoration(
                              color:buttonColor3 ,
                              borderRadius: BorderRadius.circular(10) ,
                            ),
                            child: Text(Provider.of<mainProvider>(context).count.toString(),style: TextStyle(color: Colors.white),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed:() => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>search())),
                    child: Container(child: Icon(Icons.search,color: iconColor1)),
                  ),
                ),
              ]
          ),
        ),
        leadingWidth: 120,
        actions: [
          Padding(padding: EdgeInsets.only(right: 5,top: 5),
            child: IconButton(
              icon: Icon(Icons.menu , color: iconColor1),
              onPressed: () {
                z.toggle!();
              },
            ),
          ),
        ],
      ),
      body:Column(
        children: [
          categories(context),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Container(
                      width: w/2,
                      child: Column(
                        children: [
                          ...list2.map((e) => minicard(e),).toList()
                        ],),
                    ),
                    Container(
                      width:w/2 ,
                      child: Column(
                        children: [
                          ...list3.map((e) =>minicard(e),).toList()
                        ],),
                    ),
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categories(BuildContext context) {
    List list2 = Provider.of<mainProvider>(context).listcategory;
    return Column(
      children: [ Container(
        height: h / 10,
        child:ListView.builder(
            reverse: true,
            scrollDirection: Axis.horizontal,
            itemCount: list2.length,
            itemBuilder: (context, index) {
              return  categoryitem(context,list2[list2.length-index-1]);
            }),
      ),
      Divider(height: 1,thickness: 1,color: hintColor1,)
      ],
    );
  }

  Widget categoryitem(BuildContext context, category c) {
    return Container(
        decoration:c.categoryid==Provider.of<mainProvider>(context).selectedcaregory?BoxDecoration(
          border:Border.all(color:dividerColor1,width: 1 ),):null,
        child: Column(
          children: [
            MaterialButton(
              onPressed: (){
                setState(() {
                  Provider.of<mainProvider>(context,listen: false).categoryselected(c.categoryid);
                  list1=[];
                  list2=[];
                  list3=[];
                });
              },
              child:Image(fit: BoxFit.fill,width:w/9 ,height: w/9,image: NetworkImage(c.image)),),
            Text(
              c.name,
              style: TextStyle(color: hintColor1, fontSize: 12),
            ),
          ],
        ),
      );
  }

  Widget minicard(product p) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        children: [
          MaterialButton(
            onPressed: ()=>Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>myproduct(p))),
            height: h / 5,
            child: Container(
              width: 4 * w / 9,
              height: h / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image:
                DecorationImage(fit: BoxFit.fill, image: NetworkImage(p.image)),
              ),
              child: Text(""),
            ),
          ),
          Positioned(
            left: 9,
            top: h/5-h/11,
            child: Container(
              width: 4 * w / 9 - 10,
              height: h / 11,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black38,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      p.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 13),
                    child: p.newprice == 0
                        ? Text(
                      p.price.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          p.newprice.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellowAccent),
                        ),
                        Text(
                          p.price.toString(),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          p.rating.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.star, color: Colors.yellowAccent),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}
