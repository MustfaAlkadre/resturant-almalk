class product {
   String name="";
   String image="";
   String detels="";
   bool inshpping_bag=false;
   bool isfavorite=false;
   bool istrender=false;
   bool ispopular=false;
   DateTime insertdate=DateTime(2017);
   int categoryid=0;
   int id=0;
   double rating=0;
   int price=0;
   int newprice = 0;
   String offernote="";
   DateTime offerstart=DateTime(2017);
   DateTime offerend=DateTime(2017);
   int countitem=0;

   product({
     required this.name,
     required this.image,
     required this.detels,
     this.inshpping_bag=false,
     this.isfavorite=false,
     this.istrender=false,
     this.ispopular=false,
     required this.insertdate,
     required this.categoryid,
     required this.id,
     required this.rating,
     required this.price,
     this.newprice=0,
     this.offernote="",
     this.countitem=0});
}