import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_almalk_app/config.dart';
import 'package:restaurant_almalk_app/connectDataBase/connectedControlar.dart';
import 'package:restaurant_almalk_app/models/bill.dart';
import 'package:restaurant_almalk_app/models/detailbill.dart';
import 'package:restaurant_almalk_app/models/products.dart';
import 'package:restaurant_almalk_app/provider/mainProvider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class reqdetels extends StatefulWidget {
  bill b;

  reqdetels(bill this.b);

  @override
  _reqdetelsState createState() => _reqdetelsState(b);
}

class _reqdetelsState extends State<reqdetels> {
  bill b;
  double w = 0, h = 0;

  _reqdetelsState(bill this.b);

  getbilldet(BuildContext context) async {
    var t=Provider.of<mainProvider>(context).user1.token;
    Provider.of<mainProvider>(context).listbill.firstWhere((e) => e.id==b.id).listdetailbill=
        await getbilldetails(t,b.id);
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor2,
      appBar: AppBar(
        shadowColor: shadowColor,
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
          "تفاصل الفاتورة",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: textColor3),
        )),
        backgroundColor: headerColor2,
      ),
      body: Provider.of<mainProvider>(context).listbill.firstWhere((e) => e.id==b.id).listdetailbill.isEmpty
          ? FutureBuilder(
              future: getbilldet(context),
              builder: (context, v) {
                if (v.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return bodyd(context);
              })
          : bodyd(context),
    );
  }

  Widget bodyd(BuildContext context) {
    int totalprice=1000;
    List<detailbill> list=Provider.of<mainProvider>(context).listbill.firstWhere((e) => e.id==b.id).listdetailbill;
    var ts =
        TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: textColor3);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Text(
            b.id.toString() + "رقم الفاتورة : ",
            style: ts,
          ),
          Text(b.address + "العنوان : ", style: ts),
          Text(b.regdate.toString() + "تاريخ الفاتورة : ", style: ts),
          ...list.map((e) {
            product p=Provider.of<mainProvider>(context).listproduct.firstWhere((element) => element.id==e.foodid);
            String name=p.name;
            int price=p.newprice>0?p.newprice:p.price;
            price*=e.foodcount;
            totalprice+=price;
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Text("الطعام : ${name}", style: ts),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(price.toString()+"السعر : ", style: ts),
                      Text(e.foodcount.toString()+"العدد : ", style: ts),
                    ]),
              ],
            );
          } ).toList(),
          Text("اجرة التوصيل : 1000", style: ts),
          Text(totalprice.toString()+"السعر النهائي : ", style: ts),
          Text("الوقت المتوقع : 25د", style: ts),
          Text("الوقت المتوقع للتوصيل : 15د", style: ts),
          timelineitem(b.status,
              title: "تم تأكيد الطلبية",
              icon: Icons.shopping_bag,
              numstep: 0,
              isfirst: true),
          timelineitem(b.status,
              title: "انتظار دور الطلب",
              icon: Icons.watch_later_outlined,
              numstep: 1),
          timelineitem(b.status,
              title: "يتم تجهيز الطلب", icon: Icons.restaurant, numstep: 2),
          timelineitem(b.status,
              title: "الطلب جاهز", icon: Icons.fastfood, numstep: 3),
          timelineitem(b.status,
              title: "بتم توصيل الطلبية",
              icon: Icons.delivery_dining,
              numstep: 4),
          timelineitem(b.status,
              title: "تم استلام الطلب بنجاح",
              icon: Icons.check_circle,
              islast: true,
              numstep: 5),
          MaterialButton(
            onPressed: null,
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(b.status > 1 ? "تتبع الطلب" : "الغاء الطلب",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16)),
              width: w / 2,
              height: h / 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: buttonColor3,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget timelineitem(int step,
      {bool isfirst = false,
      bool islast = false,
      required int numstep,
      required String title,
      required IconData icon}) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(right: w / 3),
      child: TimelineTile(
        isLast: islast,
        isFirst: isfirst,
        beforeLineStyle: numstep <= step
            ? LineStyle(color: iconColor2)
            : LineStyle(color: iconColor4),
        afterLineStyle: numstep == 5
            ? null
            : numstep < step
                ? LineStyle(color: iconColor2)
                : LineStyle(color: iconColor4),
        indicatorStyle: IndicatorStyle(
            width: 50,
            height: 50,
            color: numstep <= step ? iconColor2 : iconColor4,
            indicator: Icon(Icons.check_circle,
                size: 35, color: numstep <= step ? iconColor2 : iconColor4)),
        hasIndicator: true,
        alignment: TimelineAlign.end,
        startChild: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(icon, color: iconColor4),
            SizedBox(
              width: 10,
            ),
            Text(title,
                style: TextStyle(
                    color: textColor3.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
