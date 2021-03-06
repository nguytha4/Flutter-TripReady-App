import 'package:capstone/services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone/tripready.dart';

class DataService {
  static Future toggleFavorite(String destinationId, String activityId) async {
    var userId = await AuthenticationService.currentUserId();

    var collectionReference = Firestore.instance
        .collection('users')
        .document(userId)
        .collection('destinations')
        .document(destinationId)
        .collection('favorites');

    var documentReference = collectionReference.document(activityId);

    var document = await documentReference.get();

    if (document.exists) {
      documentReference.delete();
    } else {
      await documentReference.setData(Map<String, dynamic>());
    }
  }

  static Future<PlanModel> createPlan(PlanModel plan) async {
    var userId = await AuthenticationService.currentUserId();

    plan.returnDate = DateTime(plan.returnDate.year, plan.returnDate.month,
        plan.returnDate.day, 23, 59, 59);

    var collectionReference = Firestore.instance
        .collection('users')
        .document(userId)
        .collection('plans');

    var ref = await collectionReference.add(plan.toMap());

    return PlanModel.fromSnapshot(await ref.get());
  }

  static Future deletePlan(String planId) async {
    var userId = await AuthenticationService.currentUserId();

    var documentReference = Firestore.instance
        .collection('users')
        .document(userId)
        .collection('plans')
        .document(planId);

    await documentReference.delete();
  }

  static Future<double> getUserRating(String destinationId, String activityId) async {
    var userId = await AuthenticationService.currentUserId();

    // grab individual rating
    var ratingRef = Firestore.instance
        .collection('users')
        .document(userId)
        .collection('destinations')
        .document(destinationId)
        .collection('activities')
        .document(activityId);

    var userRatingSnapshot = await ratingRef.get();

    if (!userRatingSnapshot.exists) {
      return 0;
    }

    var userActivity = UserActivityModel.fromSnapshot(userRatingSnapshot);
    return userActivity.rating;
  }

  static Future<ActivityModel> addRating(
      String destinationId, String activityId, double rating) async {
    var userId = await AuthenticationService.currentUserId();

    // grab individual rating
    var ratingRef = Firestore.instance
        .collection('users')
        .document(userId)
        .collection('destinations')
        .document(destinationId)
        .collection('activities')
        .document(activityId);

    var userRatingSnapshot = await ratingRef.get();

    if (!userRatingSnapshot.exists) {
      // create the rating
      await ratingRef.setData(UserActivityModel(rating: rating).toMap());
    } else {
      var userRating = UserActivityModel.fromSnapshot(userRatingSnapshot);
      var oldRating = userRating.rating;

      userRating.rating = rating;
      await ratingRef.setData(userRating.toMap());

      await undoRating(destinationId, activityId, oldRating);
    }

    // grab global rating
    return await updateAverageRating(destinationId, activityId, rating);
  }

  static Future undoRating(
      String destinationId, String activityId, double rating) async {
    // grab global rating
    var activityRef = Firestore.instance
        .collection('destinations')
        .document(destinationId)
        .collection('activities')
        .document(activityId);

    var activity = ActivityModel.fromSnapshot(await activityRef.get());

    if (activity.ratingCount <= 1) {
      // this is the last rating
      activity.rating = 0;
      activity.ratingCount = 0;
    } else {
      // compute the new rolling average
      activity.rating = (activity.rating * activity.ratingCount - rating) /
          (activity.ratingCount - 1);
      activity.ratingCount--;
    }

    // save the activity back
    await activityRef.setData(activity.toMap());
  }

  static Future<ActivityModel> updateAverageRating(
      String destinationId, String activityId, double rating) async {
    // grab global rating
    var activityRef = Firestore.instance
        .collection('destinations')
        .document(destinationId)
        .collection('activities')
        .document(activityId);

    var activity = ActivityModel.fromSnapshot(await activityRef.get());

    if (activity.ratingCount == 0) {
      // this is the first rating
      activity.rating = rating;
      activity.ratingCount = 1;
    } else {
      // compute the new rolling average
      activity.rating = (activity.rating * activity.ratingCount + rating) /
          (activity.ratingCount + 1);
      activity.ratingCount++;
    }

    // save the activity back
    await activityRef.setData(activity.toMap());

    return activity;
  }
}
