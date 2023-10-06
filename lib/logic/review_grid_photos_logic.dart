import '../models/review_model.dart';
import '../services/authentication_service.dart';
import '../services/database_service.dart';

class ReviewGridPhotosLogic {
  ReviewGridPhotosLogic() : _uid = AuthenticationService.getCurrentUserUid();

  final String _uid;
  late Stream<List<ReviewModel>> _reviewModelListStream;
  Stream<List<ReviewModel>> get reviewModelList => _reviewModelListStream;

  void getReviewListPhotos() {
    _reviewModelListStream = DatabaseService.getReviewListPhotos(_uid);
  }
}