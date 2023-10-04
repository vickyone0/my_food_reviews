import 'package:flutter/material.dart';
import 'package:my_food_reviews/logic/review_list_logic.dart';

import '../../helper/arguments.dart';
import '../../helper/clippers.dart';
import '../../helper/constants.dart';
import '../../models/review_model.dart';
import '../../widget/image_and_message.dart';
import '../review_entry/review_entry_edit.dart';
import 'review_list_body.dart';


class ReviewList extends StatefulWidget {
const ReviewList({ super.key });

static const String route = "/review_list";
  
@override
State<ReviewList> createState() => _ReviewListState();
  }
  
class _ReviewListState extends State<ReviewList> {

  final ReviewListLogic reviewListLogic = ReviewListLogic();
@override
  void initState() {
    super.initState();
   reviewListLogic.getReviewModelList();
  }
  
@override
Widget build(BuildContext context) {
return  Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: Colors.transparent,
        elevation: 2.0,
        flexibleSpace: ClipPath(
          clipper: OvalClipperUpper(),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondaryContainer,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
        ),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            tooltip: 'Menu',
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<MenuItems>(
                value: MenuItems.add,
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8.0),
                    Text('Add Review'),
                  ],
                ),
              ),
              const PopupMenuItem<MenuItems>(
                value: MenuItems.signout,
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8.0),
                    Text('Sign out'),
                  ],
                ),
              )
            ],
            onSelected: (selected) {
              switch (selected) {
                case MenuItems.add:
                  ReviewModel reviewModel = reviewListLogic.addReview();
                  Navigator.of(context).pushNamed(ReviewEntryEdit.route,
                      arguments: ReviewEntryArguments(
                        reviewMode: ReviewMode.add,
                        reviewModel: reviewModel,
                      ));
                  break;
                case MenuItems.signout:
                  reviewListLogic.signOut();
                  break;
              }
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false, // To keep clipped area Transparent
        child: StreamBuilder<List<ReviewModel>>(
          initialData: const [],
          stream: reviewListLogic.reviewModelList,
          builder: (BuildContext context,
              AsyncSnapshot<List<ReviewModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                // Note: snapshot.data will have empty [] by default
                if (!snapshot.hasData) {
                  return const ImageAndMessage(
                    assetImageWithPath: 'assets/images/lobster.png',
                    message: 'No Reviews Available...',
                  );
                }
                if (snapshot.data!.isNotEmpty) {
                  List<ReviewModel> reviewList = snapshot.data!;
                  return ReviewListBody(reviewModelList: reviewList);
                }
                return const ImageAndMessage(
                  assetImageWithPath: 'assets/images/lobster.png',
                  message: 'No Reviews Available...',
                );
              default:
                return const Center(child: Text('No Reviews Available...'));
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'addReviewEntry',
        mini: true,
        tooltip: 'Add Review Entry',
        child: const Icon(Icons.add),
        onPressed: () {
          ReviewModel reviewModel = reviewListLogic.addReview();
          Navigator.of(context).pushNamed(
            ReviewEntryEdit.route,
            arguments: ReviewEntryArguments(
              reviewMode: ReviewMode.add,
              reviewModel: reviewModel,
            ),
          );
        },
      ),
    );
  }
}