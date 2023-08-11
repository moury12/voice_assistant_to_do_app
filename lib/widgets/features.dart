import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Features extends StatelessWidget {
   Features({Key? key,required this.title,required this.text,required this.color,}) : super(key: key);
String title, text;
Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 19).copyWith(top: 15),
      child: Container(alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 19),
          child: Column(
            children: [
              Align(alignment: Alignment.centerLeft,
                  child: Text(title,style: GoogleFonts.quattrocento(fontSize: 15,fontWeight: FontWeight.w600),)),
              SizedBox(height: 5,),
              Text(text,style: GoogleFonts.quattrocento(fontSize: 13),),
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: color,borderRadius: BorderRadius.vertical(top: Radius.circular(20),bottom: Radius.circular(20),)
        ),),
    );
  }
}
