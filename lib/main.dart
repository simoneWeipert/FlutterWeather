// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_mon_app/data_service.dart';
import 'package:flutter_mon_app/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Weather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final _dataService = DataService();
  final myController = TextEditingController();
  List<WeatherResponse> _forecast = [];
  int _selectedIndex = 0;
  Card weatherCard = const Card();

  Widget _buildChips() {
    List<Widget> chips = [];

    for (int i = 0; i < _forecast.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedIndex == i,
        label: Text(_forecast[i].weekday),
        selectedColor: Colors.blueAccent,
        labelStyle: TextStyle(color: Colors.white),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
              makeCard(_selectedIndex);
            }
          });
        },
      );

      chips.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: choiceChip));
    }
    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  //make a card wuth the weather info
  void makeCard(int index) {
    Card card = Card(
      elevation: 3,
      color: Colors.white10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width * 0.4,
                alignment: Alignment.center,
                child: Text(
                  _forecast[index].tempInfo.temperature.toString() + ' °C',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 150,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(_forecast[index].iconUrl),
                      Text(
                        _forecast[index].weatherInfo.description,
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ))
            ],
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Icon(Icons.location_on),
                  ),
                  Text(_forecast[index].cityName)
                ],
              )),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 20,
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child:
                Text(_forecast[index].weekday + ', ' + _forecast[index].date),
          ),
        ],
      ),
    );

    weatherCard = card;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                    height: 55,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: TextField(
                          controller: myController,
                          decoration: InputDecoration(
                              hintText: 'Search City',
                              prefixIcon: const Icon(Icons.search),
                              hoverColor: Colors.amberAccent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        )),
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: ElevatedButton(
                                onPressed: _search,
                                child: const Icon(Icons.search)))
                      ],
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  alignment: Alignment.center,
                  child: _buildChips(),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 300,
                    alignment: Alignment.center,
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 500, minHeight: 300),
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: weatherCard,
                    ))
                //Main weather display container
              ],
            )
          ],
        ),
      ),
    );
  }

  _search() async {
    //get data
    final forecast = await _dataService.getWeatherForecast(myController.text);
    setState(() => _forecast = forecast);
    //auto generate a card for today
    makeCard(0);
  }
}
