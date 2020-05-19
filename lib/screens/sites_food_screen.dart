import 'package:capstone/tripready.dart';
import 'package:flutter/material.dart';

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class SitesFoodScreen extends StatefulWidget {
  static const routeName = 'sites_food_screen';
  final DestinationModel destination;

  SitesFoodScreen({this.destination});

  @override
  _SitesFoodScreenState createState() => _SitesFoodScreenState();
}

class _SitesFoodScreenState extends State<SitesFoodScreen> {
  List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false, false];
    super.initState();
  }

  String determineCategory()
  {
    if (isSelected[0]) {
      return 'Sites';
    } else if (isSelected[1]) {
      return 'Food';
    } else {
      return 'Favorites';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: '${this.widget.destination.city} - Sites / Food',
      hideAppBar: false,
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              borderWidth: 2,
              fillColor: Colors.white,
              selectedBorderColor: Colors.black,
              selectedColor: Colors.black,
              color: Colors.grey,
              children: [
                buildContainer(context, 'Sites'),
                buildContainer(context, 'Food'),
                buildContainer(context, 'Favorites'),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                });
              },
              isSelected: isSelected,
            )
          ]),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
                decoration: new InputDecoration(labelText: "Search something")),
          ),
          SizedBox(height: 10.0),
          Expanded(
              child: SitesFoodList(
            destination: this.widget.destination,
            category: determineCategory(),
          )),
        ],
      ),
    );
  }

  Container buildContainer(BuildContext context, String text) {
    return Container(
        alignment: Alignment.center,
        width: (MediaQuery.of(context).size.width - 36) / 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              )),
        ));
  }

  void displayNewEntryForm(BuildContext context) {
    Navigator.pushNamed(context, SitesFoodDetailScreen.routeName);
  }
}
