


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../helper/constants.dart';
import '../../models/review_model.dart';
import '../../widget/image_and_message.dart';
import 'review_list_body_card.dart';

class ReviewListBody extends StatelessWidget {
  const ReviewListBody({
    super.key,
    required this.reviewModelList,
  });

  final List<ReviewModel> reviewModelList;

  @override
  Widget build(BuildContext context) {
    final double maxCrossAxisExtent = ResponsiveSizes.webDesktopTablet.value;
    final double mainAxisExtent = maxCrossAxisExtent * 0.75;

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: ImageAndMessage(
            topPadding: 24.0,
            iconHeight: 48.0,
            assetImageWithPath: 'assets/images/lobster.png',
          ),
        ),
        kIsWeb
            ? SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) =>
                      ReviewListBodyCard(reviewModel: reviewModelList[index]),
                  childCount: reviewModelList.length,
                ),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: maxCrossAxisExtent,
                  mainAxisExtent: mainAxisExtent,
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) =>
                      ReviewListBodyCard(reviewModel: reviewModelList[index]),
                  childCount: reviewModelList.length,
                ),
              )
      ],
    );
  }
}