import 'package:flutter/material.dart';

class Item {
  Item(this.name, this.description, this.imageUrl, this.color);

  String name;
  String description;
  String imageUrl;
  Color color;
}

List<Item> get globalMockItems => [
      Item('Car', 'The fastest car in the world', 'url', Colors.blue),
      Item('Airplane', 'The biggest airplane in the world', 'url',
          Colors.orange),
      Item('House', 'The most expensive house in the world', 'url',
          Colors.indigo),
      Item('PC', 'My new PC', 'url', Colors.lightBlue),
      Item('Bike', 'The fastest bike in the world', 'url', Colors.green),
      Item('SSD', 'The biggest SSD in the world', 'url', Colors.pink),
      Item('City', 'The most expensive city in the world', 'url', Colors.teal),
      Item('Skyscraper', 'The highest skyscraper in the universe', 'url',
          Colors.brown),
    ];
