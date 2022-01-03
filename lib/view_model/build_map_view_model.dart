import 'package:get/get.dart' as getX;
import 'package:graphview/GraphView.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class BuildMapViewModel extends getX.GetxController {
  BuildMapViewModel() {
    getUserNodes();
  }

  UserViewModel userController = getX.Get.find<UserViewModel>();

  final List<Node> usersNodes = [
    Node.Id(getX.Get.find<UserViewModel>().currentUser!.id)
  ];
  final List<Node> relationNodes = [];

  List<Edge> edges = [];

  addEdge(Edge edge) {
    {
      edges.add(edge);
    }
    update();
  }

  //final ValueNotifier<bool> _building = ValueNotifier<bool>(false);

  Future<List<Edge>?> getUserNodes() async {
    //_building.value = true;
    for (int i = 0, lenth = usersNodes.length;
        i < lenth;
        lenth = usersNodes.length, i++) {
      Node node = usersNodes[i];

      _getParents(node).then((value) {
        _getSons(node).then((value) {
          if (usersNodes.length - 1 == usersNodes.indexOf(node)) {
            // _building.value = false;
          }
        });
      });
      print(
          '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${usersNodes.length}!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    }
    update();
  }

  Future<void> _getParents(Node node) async {
    UserModel user =
        (await userController.getUserFromFireStore(node.key!.value))!;
    if (user.dad != null && user.mom != null) {
      if (!usersNodes.contains(Node.Id(user.dad))) {
        usersNodes.add(Node.Id(user.dad));
        getUserNodes();
      }
      if (!usersNodes.contains(Node.Id(user.mom))) {
        usersNodes.add(Node.Id(user.mom));
        getUserNodes();
      }
      if (!relationNodes.contains(Node.Id('${user.dad}*${user.mom}'))) {
        relationNodes.add(Node.Id('${user.dad}*${user.mom}'));
        addEdge(Edge(
            usersNodes.firstWhere((e) => e.key!.value == user.dad),
            relationNodes
                .firstWhere((e) => e.key!.value == '${user.dad}*${user.mom}')));
        addEdge(Edge(
            usersNodes.firstWhere((e) => e.key!.value == user.mom),
            relationNodes
                .firstWhere((e) => e.key!.value == '${user.dad}*${user.mom}')));
      }
      addEdge(Edge(
          relationNodes
              .firstWhere((e) => e.key!.value == '${user.dad}*${user.mom}'),
          usersNodes.firstWhere((e) => e.key!.value == user.id)));
    }
    update();
  }

  Future<void> _getSons(Node node) async {
    UserModel user =
        (await userController.getUserFromFireStore(node.key!.value))!;
    if (user.spouse != null) {
      if (!usersNodes.contains(Node.Id(user.spouse))) {
        usersNodes.add(Node.Id(user.spouse));
        getUserNodes();
      }
      String _relationId = user.gender == 'male'
          ? '${user.id}*${user.spouse}'
          : '${user.spouse}*${user.id}';
      if (!relationNodes.contains(Node.Id(_relationId))) {
        relationNodes.add(Node.Id(_relationId));
      }
      if (!edges.contains(Edge(
          usersNodes.firstWhere((e) => e.key!.value == user.id),
          relationNodes.firstWhere((e) => e.key!.value == _relationId)))) {
        addEdge(Edge(usersNodes.firstWhere((e) => e.key!.value == user.id),
            relationNodes.firstWhere((e) => e.key!.value == _relationId)));
      }
      if (!edges.contains(Edge(
          usersNodes.firstWhere((e) => e.key!.value == user.spouse),
          relationNodes.firstWhere((e) => e.key!.value == _relationId)))) {
        addEdge(Edge(usersNodes.firstWhere((e) => e.key!.value == user.spouse),
            relationNodes.firstWhere((e) => e.key!.value == _relationId)));
      }

      List<UserModel>? sons =
          await userController.getUserSonsFromFireStore(user.id!);
      if (sons != null) {
        sons.forEach((son) {
          if (!usersNodes.contains(Node.Id(son.id))) {
            usersNodes.add(Node.Id(son.id));
            getUserNodes();
          }
          if (!edges.contains(Edge(
              relationNodes.firstWhere((e) => e.key!.value == _relationId),
              usersNodes.firstWhere((e) => e.key!.value == son.id)))) {
            addEdge(Edge(
                relationNodes.firstWhere((e) => e.key!.value == _relationId),
                usersNodes.firstWhere((e) => e.key!.value == son.id)));
          }
        });
      }
    }
    update();
  }
}
