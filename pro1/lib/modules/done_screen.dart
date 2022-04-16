import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
List posst=[];
class Done_Screen extends StatefulWidget {
@override
  State<Done_Screen> createState() => _Done_ScreenState();
}

class _Done_ScreenState extends State<Done_Screen> {

  @override
  Widget build(BuildContext context) {
    setState(() {
      posst=posst;
      getpostt();
    });
    return Container(
      child: ListView.builder(itemCount: posst.length,itemBuilder: (context,i){
        return Text('${posst[i]['userId']}');
      }),
    );
  }
  Future getpostt() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/albums');
    var responsable = await http.get(url);
    var res = jsonDecode(responsable.body);
    posst.addAll(res);
    print(posst);
  }

}
