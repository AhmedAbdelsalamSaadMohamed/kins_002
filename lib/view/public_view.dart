import 'package:flutter/material.dart';
import 'package:kins_v002/view/widgets/new_post_widget.dart';
import 'package:kins_v002/view/widgets/post_widget.dart';
import 'package:kins_v002/view_model/post_view_model.dart';

class PublicView extends StatelessWidget {
  const PublicView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<String>>(
      future: PostViewModel().getPublicPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return NewPostWidget(
            showProfile: true,
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return NewPostWidget(
                showProfile: true,
              );
            }
            return PostWidget(postId: snapshot.data![index - 1]);
          },
        );
      },
    ));
  }
}
