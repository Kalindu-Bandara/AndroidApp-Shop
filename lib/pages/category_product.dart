import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sofrwere_project/pages/product_detail.dart';
import 'package:sofrwere_project/services/database.dart';
import 'package:sofrwere_project/widget/support_widget.dart';

class CategoryProduct extends StatefulWidget {
  //Remove that====>const CategoryProduct({super.key});
  String category;
  CategoryProduct({required this.category});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  Stream? CategoryStream;

  getontheload()async{
    CategoryStream=await DatabaseMethods().getProducts(widget.category);
    setState(() {
      
    });
  }

  @override
  void initState() {
    getontheload();
    super.initState();
    
  }

  Widget allproduct() {
    return StreamBuilder(
      stream: CategoryStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];

                  return Container(
                    
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Image.network(
                          ds["Image"],
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          ds["Name"],
                          style: AppWidget.semiboldTextFeildStyle(),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              "\$"+ ds["Price"],
                              style: const TextStyle(
                                  color: Color(0xFFfd6f3e),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 50.0,
                            ),
                            GestureDetector(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(detail: ds["Detail"], image: ds["Image"], name: ds["Name"], price:ds["Price"] )));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFfd6f3e),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
      ),
      body: Container(
        child: Column(
          children: [Expanded(child: allproduct())],
        ),
      ),
    );
  }
}
