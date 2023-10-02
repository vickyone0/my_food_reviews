

import 'package:geolocator/geolocator.dart';

import '../models/review_model.dart';
import 'constants.dart';

class ReviewEntryArguments {
  ReviewEntryArguments({required this.reviewMode, required this.reviewModel});

  final ReviewMode reviewMode;
  final ReviewModel reviewModel;
}

class ReviewEntryPhotoArguments {
  ReviewEntryPhotoArguments({required this.reviewModel});

  final ReviewModel reviewModel;
}

class LocationArguments {
  LocationArguments({required this.answer, this.position});

  final bool answer;
  final Position? position;
}