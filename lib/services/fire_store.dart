import 'package:astronauthelper/constants.dart';
import 'package:astronauthelper/models/commander.dart';
import 'package:astronauthelper/models/member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStore {
  final Firestore _firestore = Firestore.instance;

  addCommander(Commander commander, uId) {
    _firestore.collection(kUserCollection).document(uId).setData({
      kCommanderName: commander.fullName,
      kCommanderAge: commander.age,
      kCommanderRole: commander.role,
      kCommanderHeight: commander.height,
      kCommanderWeight: commander.weight,
      kNumberOfMembers: commander.numberOfMembers,
      kMissionName: commander.missionName,
      kDepartureDateandTime: commander.departureDateandTime,
      kIsCommander: commander.isCommander,
    });
  }

  addMember(Member member, uId) {
    _firestore.collection(kUserCollection).document(uId).setData({
      kMemberName: member.fullName,
      kMemberAge: member.age,
      kMemberRole: member.role,
      kMemberHeight: member.height,
      kMemberWeight: member.weight,
      kIsCommander: member.isCommander,
      kMissionName: member.missionName,
    });
  }

  Stream<DocumentSnapshot> getScheduleData(uId) {
    return Firestore.instance
        .collection(kUserCollection)
        .document(uId)
        .snapshots();
  }

//  storeOrders(data, List<String> products) {
//    var documentReference = _firestore.collection(kOrders).document();
//    documentReference.setData(data);
//
//    for (var product in products) {
//      documentReference.collection(kOrderDetails).document().setData({
//        kProductName: product.pName,
//        kProductPrice: product.pPrice,
//        kProductQuantity: product.pQuantity,
//        kProductLocation: product.pLocation,
//      });
//    }
//  }

  Stream<QuerySnapshot> getMembersSchedule() {
    return _firestore.collection(kUserCollection).snapshots();
  }
}
