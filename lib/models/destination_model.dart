import 'package:capstone/models/activity_model.dart';

class Destination {
  String imageUrl;
  String city;
  String country;
  String description;
  List<Activity> activities;
  
  Destination({
    this.imageUrl,
    this.city,
    this.country,
    this.description,
    this.activities,
  });
}

List<Activity> activities = [
  Activity(
    imageUrl: 'assets/images/stmarksbasilica.jpg',
    name: 'St. Mark\'s Basilica',
    type: 'Sightseeing Tour',
    startTimes: ['9:00 am', '11:00 am'],
    rating: 5,
    price: 30,
  ),
  Activity(
    imageUrl: 'assets/images/gondola.jpg',
    name: 'Walking Tour and Gonadola Ride',
    type: 'Sightseeing Tour',
    startTimes: ['11:00 pm', '1:00 pm'],
    rating: 4,
    price: 210,
  ),
  Activity(
    imageUrl: 'assets/images/murano.jpg',
    name: 'Murano and Burano Tour',
    type: 'Sightseeing Tour',
    startTimes: ['12:30 pm', '2:00 pm'],
    rating: 3,
    price: 125,
  ),
];

List<Destination> destinations = [
  Destination(
    imageUrl: 'assets/images/rome.jpg',
    city: 'Rome',
    country: 'Italy',
    description: 'Visit Rome for an amazing and unforgettable adventure.',
    activities: activities,
  ),
  Destination(
    imageUrl: 'assets/images/paris.jpg',
    city: 'Paris',
    country: 'France',
    description: 'Visit Paris for an amazing and unforgettable adventure.',
    activities: activities,
  ),
  Destination(
    imageUrl: 'assets/images/bangkok.jpg',
    city: 'Bangkok',
    country: 'Thailand',
    description: 'Visit Bangkok for an amazing and unforgettable adventure.',
    activities: activities,
  ),
  Destination(
    imageUrl: 'assets/images/seattle.jpg',
    city: 'Seattle',
    country: 'United States',
    description: 'Visit Seattle for an amazing and unforgettable adventure.',
    activities: activities,
  ),
  Destination(
    imageUrl: 'assets/images/newyork.jpg',
    city: 'NYC',
    country: 'United States',
    description: 'Visit New York for an amazing and unforgettable adventure.',
    activities: activities,
  ),
];
