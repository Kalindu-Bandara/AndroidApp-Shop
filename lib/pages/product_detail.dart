import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sofrwere_project/services/constant.dart';
import 'package:sofrwere_project/services/database.dart';
import 'package:sofrwere_project/services/shared_pref.dart';
import 'package:sofrwere_project/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class ProductDetail extends StatefulWidget {
  //const ProductDetail({super.key});//remove this in adding function to product details
  String image,name,detail,price;
  ProductDetail({required this.detail,required this.image,required this.name,required this.price});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String? name,mail,image;

  getthesharedpref()async{
    name=await SharedPreferenceHelper().getUserName();
    mail=await SharedPreferenceHelper().getUserEmail();
    image=await SharedPreferenceHelper().getUserImage();
    setState(() {
      
    });
  }

  ontheload()async{
    await getthesharedpref();
    setState(() {
      
    });
  }
  @override
  void initState() {
    super.initState();
    ontheload();
  }


  Map<String,dynamic>?paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFfef5f1),
      body: Container(
        padding: const EdgeInsets.only(top: 50.0), // Only top padding needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned(
                  left: 20, // Ensures the back button stays properly aligned
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.arrow_back_ios_outlined),
                    ),
                  ),
                ),
                Center(
                  child: Image.network(
                    widget.image,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0), // Added right padding for consistency
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: AppWidget.boldTextFeildStyle(),
                        ),
                        Text(
                  "\$"+widget.price,
                  style: TextStyle(
                    color: Color(0xFFfd6f3e),
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                      ],
                    ),
                    SizedBox(height: 20.0,),
                  Text("Details",style: AppWidget.semiboldTextFeildStyle(),),
                  SizedBox(height: 20,),
                  Text(widget.detail),  
                  SizedBox(height: 60.0,),
                  GestureDetector(
                    onTap: () {
                      makePayment(widget.price);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(color: Color(0xfffd6f3e),borderRadius:BorderRadius.circular(10.0)),
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: Text("Buy Now",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)),
                    ),
                  )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> makePayment(String amount)async{
    try{
      paymentIntent=await createPaymentIntent(amount,'LKR');
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent?['client_secret'],
        style: ThemeMode.dark,merchantDisplayName: 'Kalindu'
      )).then((value){});

      displayPaymentSheet();

    }catch(e,s){
      print('exception:$e$s');
    }
  }
  displayPaymentSheet()async{
    try{
      await Stripe.instance.presentPaymentSheet().then((value)async{
        Map<String,dynamic>orderInfoMap={
          "Product":widget.name,
          "Price":widget.price,
          "Name":name,
          "Email":mail,
          "Image":image,
          "ProductImage":widget.image,
          "Status": "On the way"
        };
        await DatabaseMethods().orderDetails(orderInfoMap);
        showDialog(context: context, builder: (_)=>AlertDialog(
          content:Column(mainAxisSize: MainAxisSize.min,
          children: [Row(
            children: [
              Icon(Icons.check_circle,color: Colors.green,),
              Text("Payment Successful")
            ],
          )],
          )
        ));
        paymentIntent=null;
      }).onError((error,stackTrace){
        print("Error is :---> $error $stackTrace");
      });
    }on StripeException catch(e){
      print("Error is :--->$e");
      showDialog(context: context, builder: (_)=>AlertDialog(
        content:Text("Cancelled"),
      ));
    }catch(e){
      print('$e');
    }
  }
  createPaymentIntent(String amount,String currency)async{
    try{
      Map<String,dynamic> body={
        'amount':calculateAmount(amount),
        'currency':currency,
        'payment_method_types[]':'card'

      };

      var response = await http.post(Uri.parse(
        'https://api.stripe.com/v1/payment_intents'),headers: {'Authorization':'Bearer $secretkey',
        'Content-Type':'application/x-www-form-urlencoded',
        },body: body,
        );
        return jsonDecode(response.body);
    }catch(err){
      print('err charging user:${err.toString()}');
    }
  }
  calculateAmount(String amount){
    final calculatedAmount=(int.parse(amount)*100);
    return calculatedAmount.toString();
  }

}
