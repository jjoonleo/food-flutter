import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_hello_world/food_page.dart';
import 'package:flutter_application_hello_world/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const foodTheme = FoodTheme();
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          title: 'Food',
          theme: foodTheme.toThemeData(lightColorScheme),
          darkTheme: foodTheme.toThemeData(darkColorScheme),
          themeMode: ThemeMode.system,
          home: const MyHomePage(title: ''),
        );
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String inputText = "";
  final TextEditingController _controller = TextEditingController();

  late Future<List<dynamic>> restaurants;

  Future<List> getRestaurants() async {
    print("hi");
    final response = await http.get(
        Uri.parse('http://ejun.kro.kr/api/restaurant/all'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    print(response);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      List result = json.decode(response.body)["result"].toList();
      return result;
    } else {
      List result = [];
      return result;
    }
  }

  Future<void> addRestaurant(String value) async {
    Map<String, String> data = {"name": value};
    final response =
        await http.post(Uri.parse('http://ejun.kro.kr/api/restaurant/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(data));

    print(response.statusCode);
    final result = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 201) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      setState(() {
        inputText = "입력을 성공했습니다.";
      });
      reloadRestaurants();
    } else if (response.statusCode == 405) {
      print(result["error"]["code"]);
      if (result["error"]["code"] == 11000) {
        //duplicate key error
        setState(() {
          inputText = "중복된 값은 입력할 수 없습니다.";
        });
      }
    } else {
      //throw Exception("Failed to add restaurantto database");
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onInputTextChanged(String value) {
    setState(() {
      inputText = value;
    });
    print(value);
  }

  void reloadRestaurants() {
    setState(() {
      restaurants = getRestaurants();
    });
  }

  @override
  void initState() {
    super.initState();
    restaurants = getRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);

    final ButtonStyle btnStyle = TextButton.styleFrom(
      foregroundColor: theme.primaryColorDark,
      backgroundColor: Theme.of(context).primaryColorLight,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      minimumSize: const Size(100, 40),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 44, horizontal: 30),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '검색할 매장을 입력하세요.',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 2.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 2.0),
                      ),
                      hintText: "",
                    ),
                    cursorColor: Color(0xff42685C),
                    onChanged: (value) => _onInputTextChanged(value),
                  ),
                ),
                // Expanded(
                //   child: Center(
                //     child: SizedBox(
                //       width: 300,
                //       child: FutureBuilder<List<dynamic>>(
                //           future: restaurants,
                //           builder: (context, snapshot) {
                //             if (snapshot.hasData) {
                //               return RestaurantList(data: snapshot.data);
                //             } else if (snapshot.hasError) {
                //               return Text('${snapshot.error}');
                //             } else {
                //               return const Text("loading");
                //             }
                //           }),
                //     ),
                //   ),
                // ),
                TextButton(
                  style: btnStyle,
                  onPressed: () {
                    addRestaurant(_controller.text);
                  },
                  child: const Text('submit'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class RestaurantList extends StatefulWidget {
  RestaurantList({Key? key, required this.data}) : super(key: key);

  final List<dynamic>? data;

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final String restaurantName = widget.data![index]["name"];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MaterialButton(
                    color: const Color.fromARGB(255, 246, 245, 245),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Text(
                        restaurantName,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FoodPage(title: restaurantName),
                      ));
                    },
                  ),
                );
              },
              childCount: widget.data!.length,
            ),
          ),
        ),
      ],
    );
  }
}
