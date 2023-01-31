import 'dart:math';

import 'package:flutter/material.dart';
import 'package:swipeapp/ffi.dart';
import 'package:swipeapp/src/deck/deck_display.dart';
import 'package:swipeapp/src/deck/decks_manager.dart';

import 'src/ui_helpers.dart';
/* import "package:org_flutter/org_flutter.dart"; */

void main() {
  runApp(const MyApp());
}

Widget cardToWidget(DeckEntry card) {
  return basicContainer(child: Text(card.title), color: cardToColor(card));
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
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

String label = "default";

class _MyHomePageState extends State<MyHomePage> {
  final List<DeckEntry> _unsorted = ["1", "2", "3"]
      .map((e) => DeckEntry(title: e))
      .toList()
      .reversed
      .toList();

  final Map<String, Deck> _decks = {
    'box_1': [],
    'box_2': [],
    /* 'box_3': [], */
    /* 'box_4': [], */
    /* 'box_5': [], */
    /* 'box_6': [], */
    /* 'box_7': [], */
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

  Widget _deckToDraggables(List<DeckEntry> cards) {
    var tmp = cards
        .map((e) => Draggable(
              data: e,
              feedback: basicContainer(
                  child: const Text("dragging"), color: cardToColor(e)),
              childWhenDragging: basicContainer(child: Container()),
              child: cardToWidget(e),
            ))
        .toList();
    return Stack(
      children: tmp,
    );
  }

  DragTarget<DeckEntry> _getDragTarget(
      {required String title, required Function(DeckEntry) onAccept}) {
    return DragTarget(
      builder: ((context, candidateData, rejectedData) {
        if (rejectedData.isNotEmpty) {
          return basicContainer(child: Container(), color: Colors.redAccent);
        }
        if (candidateData.isNotEmpty) {
          return basicContainer(color: Colors.greenAccent);
        }
        return basicContainer(child: Text(title));
      }),
      onAccept: onAccept,
    );
  }

  Widget _getDragTargetChild({required title}) {
    return basicContainer(child: Container(), color: stringToColor(title));
  }

  List<Widget> _getUI(Map<String, List<DeckEntry>> decks) {
    api.platform().then((value) => label = value.toString());
    List<Widget> widgets = [
      _deckToDraggables(_unsorted),
    ];
    widgets.add(Text(label));

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
                "deck $key: ${value.fold("", (previousValue, element) => "$previousValue ${element.title}")}");
          });
        }),
        icon: const Icon(Icons.help)));
    widgets.add(IconButton(
        onPressed: () {
          setState(() {
            _unsorted
                .add(DeckEntry(title: "random-${Random().nextInt(90) + 10}"));
          });
        },
        icon: const Icon(Icons.generating_tokens)));
    /* widgets.add(Org("""* TODO [#A] foo bar """)); */
    return widgets;
  }
}
