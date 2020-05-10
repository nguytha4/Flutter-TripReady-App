import 'activity_model.dart';
import 'destination_model.dart';

List<Activity> _activities = [
  Activity(
    imageUrl: 'assets/images/vaticancity.jpg',
    name: 'Vatican City',
    type: 'Sightseeing Tour',
    category: 'Sites',
    startTimes: ['9:00 am', '11:00 am'],
    rating: 5,
    price: 30,
  ),
  Activity(
    imageUrl: 'assets/images/coliseum.jpg',
    name: 'Coliseum',
    type: 'Sightseeing Tour',
    category: 'Food',
    startTimes: ['11:00 pm', '1:00 pm'],
    rating: 4,
    price: 210,
  ),
  Activity(
    imageUrl: 'assets/images/trevifountain.jpg',
    name: 'Trevi Fountain Tour',
    type: 'Sightseeing Tour',
    category: 'Sites',
    startTimes: ['12:30 pm', '2:00 pm'],
    rating: 3,
    price: 50,
  ),
  Activity(
    imageUrl: 'assets/images/palazzodoriapamphlj.jpg',
    name: 'Palazzo Doria Pamphilj Tour',
    type: 'Sightseeing Tour',
    category: 'Sites',
    startTimes: ['12:30 pm', '2:00 pm'],
    rating: 5,
    price: 80,
  ),
  Activity(
    imageUrl: 'assets/images/vaticanmuseum.jpg',
    name: 'Vatican Museum Tour',
    type: 'Sightseeing Tour',
    category: 'Favorites',
    startTimes: ['12:30 pm', '2:00 pm'],
    rating: 4,
    price: 60,
  ),
];

List<Destination> destinations = [
  Destination(
    imageUrl: 'assets/images/rome.jpg',
    city: 'Rome',
    country: 'Italy',
    description: 'Visit Rome for an amazing and unforgettable adventure.',
    activities: _activities,
  ),
  Destination(
    imageUrl: 'assets/images/paris.jpg',
    city: 'Paris',
    country: 'France',
    description: 'Visit Paris for an amazing and unforgettable adventure.',
    activities: _activities,
  ),
  Destination(
    imageUrl: 'assets/images/bangkok.jpg',
    city: 'Bangkok',
    country: 'Thailand',
    description: 'Visit Bangkok for an amazing and unforgettable adventure.',
    activities: _activities,
  ),
  Destination(
    imageUrl: 'assets/images/seattle.jpg',
    city: 'Seattle',
    country: 'United States',
    description: 'Visit Seattle for an amazing and unforgettable adventure.',
    activities: _activities,
  ),
  Destination(
    imageUrl: 'assets/images/newyork.jpg',
    city: 'New York',
    country: 'United States',
    description: 'Visit New York for an amazing and unforgettable adventure.',
    activities: _activities,
  ),
];