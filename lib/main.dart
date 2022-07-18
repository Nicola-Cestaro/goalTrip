import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await Firebase.initializeApp();
  FirebaseFirestore.instance.doc("/budget/InS0oRu84h6Fpcn99wZf").get().then((data){
    runApp(MyApp(data: data));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.data}) : super(key: key);

  final DocumentSnapshot data;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giretto Islanda',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(data: data),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,required this.data}) : super(key: key);

  final DocumentSnapshot data;
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  bool hasAdded = false;

  @override
  void initState(){
    super.initState();
    DateTime now = widget.data.get("lastAdd").toDate();
    if(now.difference(DateTime.now()).inHours < 16){
      hasAdded = true;
    }
    widget.data.reference.update({
      "visite": FieldValue.increment(1)
    });
  }

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("img/background.jpg"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 30,
                child: Container(
                  width: screenSize.width * 0.9,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: const Text(
                    "Budget Giretto Ring Road\nper due persone",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                )
              ),
              Positioned(
                top: 250,
                child: Column(
                  children: [
                    Text(
                      hasAdded == true ? "${widget.data.get("total") + 10}\$/5000\$" : "${widget.data.get("total")}\$/5000\$",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: screenSize.height / 2,
                      width: 100,
                      child: LiquidLinearProgressIndicator(
                        value: 1/5000*widget.data.get("total"), // Defaults to 0.5.
                        valueColor: AlwaysStoppedAnimation(Colors.black87), // Defaults to the current Theme's accentColor.
                        backgroundColor: Colors.transparent, // Defaults to the current Theme's backgroundColor.
                        borderColor: Colors.black26,
                        borderWidth: 5.0,
                        direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: ElevatedButton(
                  onPressed: () {
                    if(hasAdded == false){
                      widget.data.reference.update({
                        "total": FieldValue.increment(10),
                        "lastAdd": DateTime.now()
                      });
                      hasAdded = true;
                      setState((){});
                    } else {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Container(
                          height: 200,
                          color: Colors.teal,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ehi :) mi spiace ma puoi cliccare il bottone solo una volta al giorno",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    primary: Colors.black87,
                                    shadowColor: Colors.black87,
                                    elevation: 16,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    )
                                ),
                                child: Container(
                                  height: 50,
                                  width: 300,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Ho Capito, ci vediamo domani",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      primary: Colors.teal,
                      shadowColor: Colors.black87,
                      elevation: 16,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  child: Container(
                    height: 50,
                    width: 130,
                    alignment: Alignment.center,
                    child: const Text(
                      "Aggiungi 10\$",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
