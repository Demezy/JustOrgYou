/*
void main(List<String> args) {
  Deck d1 = [DeckEntry(title: "title1"), DeckEntry(title: "title2")];
  Deck d2 = [];
  print(d1);
  print(d2);
  moveEntry(d1, d2);
  print(d1);
  print(d2);
}
*/

// move top deck entry from d1 to d2
bool moveEntry(Deck d1, Deck d2) {
  if (d1.isEmpty) return false;
  d2.add(d1.removeLast());
  return true;
}

typedef Deck = List<DeckEntry>;

typedef Props = Map;

class DeckEntry {
  String title;
  String? description;
  Props? props;

  DeckEntry({required this.title, this.description, this.props});
  DeckEntry copy() {
    return DeckEntry(
        title: title,
        description: description,
        props: props == null ? null : Props.from(props!));
  }

  @override
  String toString() {
    return "DeckEntry{title:$title, description: $description";
  }
}
