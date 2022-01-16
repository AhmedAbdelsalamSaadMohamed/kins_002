// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kins_v002/model/request_model.dart';
// import 'package:kins_v002/model/user_model.dart';
// import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
// import 'package:kins_v002/view/widgets/request_widget.dart';
// import 'package:kins_v002/view_model/request_view_model.dart';
// import 'package:kins_v002/view_model/user_view_model.dart';
//
// class KinsTab extends StatelessWidget {
//   const KinsTab({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     UserViewModel userController = Get.find<UserViewModel>();
//     List<UserModel> users = [
//       ...userController.allFamily.where((user) => (user.email != null &&
//           user.email != '' &&
//           user.token != null &&
//           user.token != '' &&
//           user.id != userController.currentUser!.id))
//     ];
//
//     return Scaffold(
//       appBar: CustomAppBarWidget.appBar(title: 'Requests'.tr, context: context),
//       body: StreamBuilder<List<RequestModel>>(
//           stream: RequestViewModel().getRequestsToMe(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error'.tr),
//               );
//             }
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             // snapshot.data!.forEach((request) async {
//             //   UserModel user = (await userController
//             //       .getUserFromFireStore(request.senderId!))!;
//             //
//             //   if (!userController.allFamily.contains(user)) {
//             //     userController.getParents(user);
//             //     userController.getSons(user);
//             //   }
//             // });
//             return ListView(
//               children: [
//                 ...snapshot.data!.map((e) => RequestWidget(request: e))
//               ],
//               //itemCount: snapshot.data!.docs.length,
//               // itemBuilder: (context, index) {
//               //   // if(index < requests.length){
//               //   //   return Dismissible(
//               //   //     key: Key(index.toString()),
//               //   //     child: UserWidget(
//               //   //         user: users[index],
//               //   //         onPressed: () {},
//               //   //         icon: const Icon(Icons.done)),
//               //   //     background: Container(color: Colors.red,) ,
//               //   //     onDismissed: (direction) {
//               //   //
//               //   //     },
//               //   //   );
//               //   // }
//               //   return UserWidget(
//               //       user: snapshot.data!.docs.,
//               //       onPressed: () {},
//               //       icon: const Icon(Icons.assignment_rounded));
//               // },
//             );
//           }),
//     );
//   }
// }
