import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

//importation des pages où on veut aller
import './notes.dart';
import './about.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meteo.ly',
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset("assets/gif/meteo.ly.gif"),
        nextScreen: Home(),
        splashIconSize: 150.0,
        splashTransition: SplashTransition.slideTransition,
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  //déclaration du controleur pour le textfield. permettra de récupérer plus tard laa valeur saisie dans le champ
  final townController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //différentes variables utilisées
  var temp;
  var description;
  var country;
  var cityName;
  var humidity;
  var windSpeed;

  //nettoyage du controleur quand on ne fait plus appel au controleur
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    townController.dispose();
    super.dispose();
  }

  //fonction faisant appel à l'api d'openweathermap pour récupérer les données
  Future getWeatherData(String t) async {
    var url = 'http://api.openweathermap.org/data/2.5/weather?q=' +
        t +
        '&units=metric' +
        '&appid=de5dbb37c3fdb43bd734c38a6c64bc3d' +
        '&lang=fr';

    http.Response response = await http.get(url);
    var result = jsonDecode(response.body);
    print(result);
    if (response.statusCode == 200) {
      setState(() {
        this.temp = result['main']['temp'];
        this.description = result['weather'][0]['description'];
        this.country = result['sys']['country'];
        this.humidity = result['main']['humidity'];
        this.windSpeed = result['wind']['speed'];
        this.cityName = result['name'];
      });
    } else {
      setState(() {
        this.temp = null;
        this.description = null;
        this.country = null;
        this.humidity = null;
        this.windSpeed = null;
        this.cityName = null;
      });
    }
  }

  //constructeur permettant de lancer toutes choses dès le démarrage de l'application
  @override
  void initeState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //branches de l'application
    return Scaffold(
        //key pour appeler le scaffold
        key: _scaffoldKey,
        //barre de navigation un peu comme les headers
        appBar: AppBar(
          title: Text("Meteo.ly"),
          leading: IconButton(
            icon: Image.asset('assets/images/meteolyicon.png'),
            /* onPressed: (){
              //en cliquant sur l'icone on fait appel au drawer
              _scaffoldKey.currentState.openDrawer();
            },*/
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        //Side bare menu
        endDrawer: new Drawer(
          child: ListView(
            children: <Widget>[
              new DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                    Colors.red,
                    Colors.redAccent,
                    Colors.redAccent,
                    Colors.red,
                  ]),
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Image.asset("assets/images/meteolyicon.png",
                          height: 100, width: 100),
                      Text(
                        "Meteo.Ly",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                ),
              ),
              new ListTile(
                title: new Text('Notes'),
                //en appuyant sur notes on iras sur sa page
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new NotePage()));
                },
              ),
              new Divider(
                color: Colors.black45,
                height: 0.50,
              ),
              new ListTile(
                title: new Text('A propos'),
                //en appuyant sur notes on iras sur sa page
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new AboutPage()));
                },
              ),
            ],
          ),
        ),
        //corps de l'application
        body: new Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 10.0, top: 0.0),
                    child: TextField(
                      //assignation du controlleur au TextField
                      controller: townController,
                      //decoration permet de customiser le champs de texte
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              //customisation avant la sélection du champs de texte
                              borderSide: BorderSide(color: Colors.grey[200]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(55))),
                          focusedBorder: OutlineInputBorder(
                              //customisation pendant que le champs de texte est sélectionné
                              borderSide: BorderSide(color: Colors.grey[200]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(55))),
                          filled: true,
                          fillColor: Colors.grey[200],
                          suffixIcon: Icon(Icons.search),
                          hintText: ("Une ville ?"),
                          hintStyle: TextStyle(color: Colors.black45),
                          suffixStyle: TextStyle(color: Colors.black45)),
                      cursorColor: Colors.black,
                    ),
                  ),
                  new Container(
                    //marge en haut du boutton
                    margin: EdgeInsets.only(top: 0.0),
                    //Declaration du boutton
                    child: RaisedButton(
                      elevation: 10.0,
                      padding: EdgeInsets.only(
                          left: 50.0, right: 50.0, top: 10.0, bottom: 10.0),
                      color: Colors.yellowAccent,
                      textColor: Colors.white,
                      //Action à effectuer en cas d'appui du boutton
                      onPressed: () {
                        getWeatherData(townController.text);
                      },
                      child: Text(
                        "Go!",
                        style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0),
                      ),
                      //Permet d'arrondir les bords de mon boutton
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60.0),
                          side: BorderSide(color: Colors.red)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      temp != null ? temp.toString() + " °" : "N/A",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(cityName != null ? cityName.toString() : "N/A",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                      title: Text("Température :"),
                      trailing:
                          Text(temp != null ? temp.toString() + " °" : "N/A"),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.cloudRain),
                      title: Text("Temps :"),
                      trailing: Text(
                          description != null ? description.toString() : "N/A"),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.water),
                      title: Text("Humidité :"),
                      trailing:
                          Text(humidity != null ? humidity.toString() : "N/A"),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.wind),
                      title: Text("Vitesse du vent :"),
                      trailing: Text(
                          windSpeed != null ? windSpeed.toString() : "N/A"),
                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.globe),
                      title: Text("Pays :"),
                      trailing:
                          Text(country != null ? country.toString() : "N/A"),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
