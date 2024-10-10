import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecefe8),
      body:Container(
        margin: EdgeInsets.only(top:50.0,),
        child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,  //change the alignment
          children: [
           Image.asset("images/headphone.PNG"),
           Padding(
             padding: const EdgeInsets.only(left: 20.0),
             child: Text(
              'Explore\nThe Best\n Products ',
              style:TextStyle(
                color: Colors.black,
                fontSize: 40.0,
                fontWeight:FontWeight.bold) ,
                ),
           ),
           Row(
            mainAxisAlignment: MainAxisAlignment.end,
             children: [
               Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.all(25),
                decoration:BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,) ,
                child: Text(
                  'Next',
                  style:TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight:FontWeight.bold),
                    ),  
               ),
             ],
           ) 
          ],
        ),
      )
    );
  }
}