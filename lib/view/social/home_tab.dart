import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/services/firebase/post_firestore.dart';
import 'package:kins_v002/view/widgets/new_post_widget.dart';
import 'package:kins_v002/view/widgets/post_widget.dart';
import 'package:kins_v002/view_model/post_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class HomeTap extends StatelessWidget {
  HomeTap({Key? key}) : super(key: key);
  final UserViewModel userController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    Query query = PostFireStore().getRecommendedPosts();

    return FutureBuilder<List<String>>(
      future: PostViewModel().getFamilyPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return NewPostWidget(
            showProfile: true,
            privacy: 'family',
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return NewPostWidget(
                showProfile: true,
                privacy: 'family',
              );
            }
            return PostWidget(
              postId: snapshot.data![index - 1],
            );
          },
        );
      },
    );

    RefreshIndicator(
      onRefresh: () async {
        query = PostFireStore().getRecommendedPosts();
      },
      child: PaginateFirestore(
        itemBuilder: (int index, BuildContext context,
            DocumentSnapshot documentSnapshot) {
          if (index == 0) {
            return Column(
              children: [
                NewPostWidget(
                  showProfile: true,
                  privacy: 'family',
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
        itemsPerPage: 4,
        padding: const EdgeInsets.only(bottom: 150),
        emptyDisplay: NewPostWidget(
          privacy: 'family',
        ),
        shrinkWrap: true,
      ),
    );
  }
}
