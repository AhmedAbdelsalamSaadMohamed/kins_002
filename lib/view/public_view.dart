import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kins_v002/services/firebase/post_firestore.dart';
import 'package:kins_v002/view/widgets/new_post_widget.dart';
import 'package:kins_v002/view/widgets/post_widget.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class PublicView extends StatelessWidget {
  PublicView({Key? key}) : super(key: key);
  final Query query = PostFireStore().getPublicPostsQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaginateFirestore(
        itemBuilder: (int index, BuildContext context,
            DocumentSnapshot documentSnapshot) {
          if (index == 0) {
            return Column(
              children: [
                NewPostWidget(
                  showProfile: true,
                ),
                PostWidget(
                  postId: documentSnapshot.id,
                ),
              ],
            );
          } else {
            return PostWidget(
              postId: documentSnapshot.id,
            );
          }
        },
        query: query,
        itemBuilderType: PaginateBuilderType.listView,
        itemsPerPage: 15,
        padding: const EdgeInsets.only(bottom: 150),
        emptyDisplay: NewPostWidget(),
        shrinkWrap: true,
        pageController: PageController(keepPage: true),
      ),
    );
  }
}
