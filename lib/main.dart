import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class CardData {
  String shortText;
  String? longText;
  CardData(this.shortText, [this.longText]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'swipe app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Container _basicContainer({color = Colors.transparent, Widget? child}) {
  return Container(
    height: 100,
    width: 100,
    color: color,
    child: Center(child: child),
  );
}

Color stringToColor(String str) {
  int hash = str.hashCode;
  return Color.fromARGB(
      255, (hash & 0xFF0000) >> 16, (hash & 0x00FF00) >> 8, hash & 0x0000FF);
}

Color _cardToColor(CardData card) {
  return stringToColor(
      card.shortText + (card.longText == null ? card.shortText : ""));
}

Widget cardToWidget(CardData card) {
  return _basicContainer(
      child: Text(card.shortText), color: _cardToColor(card));
}

class _MyHomePageState extends State<MyHomePage> {
  final List<CardData> _unsorted =
      ["1", "2", "3"].map((e) => CardData(e)).toList().reversed.toList();

  Widget _deckToDraggables(List<CardData> cards) {
    var tmp = cards
        .map((e) => Draggable(
              data: e,
              feedback: _basicContainer(
                  child: const Text("dragging"), color: _cardToColor(e)),
              childWhenDragging: _basicContainer(child: Container()),
              child: cardToWidget(e),
            ))
        .toList();
    return Stack(
      children: tmp,
    );
  }

  Widget _getDragTargetChild({required title}) {
    return _basicContainer(child: Container(), color: stringToColor(title));
  }

  DragTarget<CardData> _getDragTarget(
      {required String title, required Function(CardData) onAccept}) {
    return DragTarget(
      builder: ((context, candidateData, rejectedData) {
        if (rejectedData.isNotEmpty) {
          return _basicContainer(child: Container(), color: Colors.redAccent);
        }
        if (candidateData.isNotEmpty) {
          return _basicContainer(color: Colors.greenAccent);
        }
        return _basicContainer(child: Text(title));
      }),
      onAccept: onAccept,
    );
  }

  List<Widget> _getUI(Map<String, List<CardData>> decks) {
    List<Widget> widgets = [
      _deckToDraggables(_unsorted),
    ];

    decks.forEach((key, list) {
      widgets.add(_getDragTarget(
          title: key,
          onAccept: (card) {
            setState(() {
              list.add(card);
              _unsorted.removeLast();
            });
          }));
    });

    widgets.add(IconButton(
        onPressed: (() {
          print("debug");
          decks.forEach((key, value) {
            print(
                "deck $key: ${value.fold("", (previousValue, element) => "$previousValue ${element.shortText}")}");
          });
        }),
        icon: Icon(Icons.help)));
    return widgets;
  }

  final Map<String, List<CardData>> _decks = {
    'box_1': [],
    'box_2': [],
    'box_3': [],
    'box_4': [],
    'box_5': [],
    'box_6': [],
    'box_7': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getUI(_decks),
        ),
      ),
    );
  }
}
