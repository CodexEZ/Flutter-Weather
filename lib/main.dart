import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:untitled1/loading.dart';
import "dart:io";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Random random = new Random();
  bool load= false;
  var loc="";
  late TextEditingController location= TextEditingController();
  var bg=["https://images.wallpapersden.com/image/download/forest-mountains-sunset-cool-weather-minimalism_am5oZWuUmZqaraWkpJRobWllrWdma2U.jpg",
    "https://images.wallpapersden.com/image/download/switzerland-surselva-sunset_bWZoZ2qUmZqaraWkpJRnZ2hnrWZnams.jpg",
    "https://images.wallpapersden.com/image/download/sunset-new-zealand_bWVuaWaUmZqaraWkpJRnZWltrWdlaW0.jpg",
    "https://images.wallpapersden.com/image/download/sunset-hd-fanart-2021_bG5pbm6UmZqaraWkpJRnZWVlrWZmZ2o.jpg"
          ];
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var city;
  var locate;
  int x=0;
  Future timeout()async{
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white54,
        title: Text("Connection timed out"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future getLocation()async{

    x=random.nextInt(4);

    print("LOca");
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;


    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      locate=_locationData;
    });
    getlocWeather(locate);


  }
  Future getlocWeather(var local)async{
    load=true;
    http.Response response= await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=${local.latitude}&lon=${local.longitude}&units=metric&appid=5e749d88f2df02cacc9be6abf8088531")).timeout(const Duration(seconds: 10));
    if(response.statusCode == 200){
      print("Success");
    }
    else{
      timeout();

      setState(() {
        load=false;
      });
    }
    var results=jsonDecode(response.body);

    print(results);
    setState(() {
      this.temp=results['main']['temp'];
      this.description=results['weather'][0]['description'];
      this.currently=results['weather'][0]['main'];
      this.humidity=results['main']['humidity'];
      this.windSpeed=results['wind']['speed'];
      this.city=results['name'];
      load=false;
    });
    print(temp);

  }
  Future getWeather(String location) async{
    load=true;
    int c=1;
    http.Response response2= await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=5e749d88f2df02cacc9be6abf8088531")).timeout(const Duration(seconds: 15));
    if(response2.statusCode == 200){
      print("Success");
    }
    else{
      if(c!=1) {
        timeout();
      }
      setState(() {
        load=false;
      });
      c=2;
    }
    var results=jsonDecode(response2.body);
    print(results);
    setState(() {
      this.temp=results['main']['temp'];
      this.description=results['weather'][0]['description'];
      this.currently=results['weather'][0]['main'];
      this.humidity=results['main']['humidity'];
      this.windSpeed=results['wind']['speed'];
      this.city=results['name'];
      load=false;
    });

  }
  @override
  void initState(){
    super.initState();
    this.getWeather(loc);
    this.getLocation();
  }
  @override
  Widget build(BuildContext context) {
    return load?Loading():Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(bg[x]),
                fit: BoxFit.cover
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(

                        height: 50,
                        width: MediaQuery.of(context).size.width-69,

                        child: TextField(
                          style: TextStyle(
                            color: Colors.white
                          ),
                          textAlign: TextAlign.center,
                          cursorColor: Colors.white,
                          controller: location,
                           onSubmitted: (String value ){
                             setState(() {
                               loc=location.text;
                             });
                             print("getiing location");
                             getWeather(loc);
                           },
                          decoration: InputDecoration(
                            focusColor: Colors.grey[900],

                              hintText: " Search City name",
                              hintStyle: TextStyle(color: Colors.grey),
                              labelStyle: TextStyle(color: Colors.white),

                              filled: true,
                              fillColor: Colors.white10,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none
                              )

                          ),
                        ),
                      ),
                    ),
                    IconButton(

                      onPressed: (){
                        setState(() {
                          getLocation();
                        });
                        getWeather(loc);
                      },
                      icon: Icon(Icons.gps_fixed),
                      color: Colors.white,

                    ),
                  ],
                ),

                SizedBox(height: 100,),
                Center(
                  child: Text(
                    city!=null?city:"",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Text(
                    temp!=null?"$temp°C":loc!=""?"Loading":"Enter City Name",
                    style: TextStyle(
                      color:temp!=null?temp>40?Colors.redAccent:temp>=30&&temp<=40?Colors.orangeAccent:Colors.greenAccent:Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 50
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Text(
                    description!=null?"$description":"",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
                SizedBox(height: 70,),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    height: 50,

                    margin: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.white10,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 20,),
                        FaIcon(FontAwesomeIcons.cloud,color: Colors.white,),
                      SizedBox(width: 50,),
                        Text(
                          "Currently",
                          textAlign: TextAlign.center,
                          style: TextStyle(

                            color: Colors.white,
                            fontSize: 18
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Text(
                          currently!=null?"$currently":"",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 20,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    height: 50,

                    margin: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 20,),
                        FaIcon(FontAwesomeIcons.water,color: Colors.white,),
                        SizedBox(width: 50,),
                        Text(
                          "Humidity",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Text(
                          humidity!=null?"$humidity%":"",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 20,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    height: 50,

                    margin: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 20,),
                        FaIcon(FontAwesomeIcons.wind,color: Colors.white,),
                      SizedBox(width: 50,),
                        Text(
                          "Wind speed",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Text(
                          windSpeed!=null?"$windSpeed Km/h":"",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 20,)
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


