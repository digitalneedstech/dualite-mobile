import 'package:flutter/material.dart';

class HelpWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: ()=>Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF2D388A),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Help",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                SizedBox()
              ],
            ),
            Expanded(child: SizedBox()),
            Center(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("We’re open to resolve your queries, "
                      "review and accept constructive  criticism. "
                      "Please send your queries on the following:",style: TextStyle(fontSize: 18.0),),
                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("perspectiveteam101@gmail.com",textAlign:TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  )
                ],
              ),
            ),),
            Expanded(flex:2,child: SizedBox()),
          ],
        ),
      ),
    );
  }
}