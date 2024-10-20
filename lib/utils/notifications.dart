import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notif.dart';
import '../models/user.dart';
import './general.dart';

// Friend Requests
Future<void> sendFriendRequest(PPUser currentUser, String userID) async {
  // Create notification object
  Notif notification = Notif(
    notifID: '',
    type: 'friend_request',
    senderID: currentUser.userID,
    senderName: currentUser.userName,
    senderPic: "",
    recipientList: [userID],
    notifSent: DateTime.now(),
  );
  // Add to notifications collection and get reference to it
  String notifID = await FirebaseFirestore.instance
      .collection('notifications')
      .add(notification.toJson())
      .then((docRef) => docRef.id);
  // Add notification to other user's notification list
  await usersRef.doc(userID).update({
    'notifs': FieldValue.arrayUnion([notifID]),
    'friendNotifs': FieldValue.arrayUnion([currentUser.userID]),
  });
  // Couldn't assign ID before added to Firestore but go back and update now
  await notifsRef.doc(notifID).update({
    'notifID': notifID,
  });
}

Future<void> acceptFriendRequest(
    String currentUser, String userID, String notifID) async {
  // Update current user's friendList and remove the notification
  await usersRef.doc(currentUser).update({
    'notifs': FieldValue.arrayRemove([notifID]),
    'friendList': FieldValue.arrayUnion([userID]),
    'points': FieldValue.increment(10),
    'friendNotifs': FieldValue.arrayRemove([userID]),
  });
  // Add current user to the other user's friendList
  await usersRef.doc(userID).update({
    'friendList': FieldValue.arrayUnion([currentUser]),
    'points': FieldValue.increment(10),
  });
  // Remove notification - only ever one friend request per user
  await notifsRef.doc(notifID).delete();
}

// Stamp notifications
Future<void> addStampToUser(PPUser currentUser, String stampID) async {
  Notif notification = Notif(
    notifID: '',
    type: 'got_stamp',
    senderID: currentUser.userID,
    senderName: currentUser.userName,
    senderPic: "",
    recipientList: [],
    notifSent: DateTime.now(),
    stampID: stampID,
  );
  // Add to notifications collection and get reference to it
  String notifID = await FirebaseFirestore.instance
      .collection('notifications')
      .add(notification.toJson())
      .then((docRef) => docRef.id);
  // Couldn't assign ID before added to Firestore but go back and update now
  await notifsRef.doc(notifID).update({
    'notifID': notifID,
  });
  // Update user's stamps list and notifications in Firestore
  usersRef.doc(currentUser.userID).update({
    'collectedStampList': FieldValue.arrayUnion([stampID]),
    'notifs': FieldValue.arrayUnion([notifID]),
    'points': FieldValue.increment(10)
  });
}

Future<void> congratulateFriend(
    PPUser currentUser, String userID, String existingNotifID) async {
  // Create notification object
  Notif notification = Notif(
    notifID: '',
    type: 'send_congrats',
    senderID: currentUser.userID,
    senderName: currentUser.userName,
    senderPic: "",
    recipientList: [userID],
    notifSent: DateTime.now(),
  );
  // Add to notifications collection and get reference to it
  String newNotifID = await FirebaseFirestore.instance
      .collection('notifications')
      .add(notification.toJson())
      .then((docRef) => docRef.id);
  // Update new send_congrats notification in Firestore
  await notifsRef.doc(newNotifID).update({
    'notifID': newNotifID,
  });
  // Add send_congrats notification to other user's notification list
  await usersRef.doc(userID).update({
    'notifs': FieldValue.arrayUnion([newNotifID]),
  });
  // Remove got_stamp notification from current user's notification list
  await usersRef.doc(currentUser.userID).update({
    'notifs': FieldValue.arrayRemove([existingNotifID]),
  });
  // If recipientList only has this notification, delete it
  await notifsRef.doc(existingNotifID).get().then((doc) {
    if (doc.data()!.recipientList.length <= 0) {
      notifsRef.doc(existingNotifID).delete();
    } else {
      // Else remove current user from got_stamp notification list
      notifsRef.doc(existingNotifID).update({
        'recipientList': FieldValue.arrayRemove([currentUser.userID]),
      });
    }
  });
}

// Ignore notifications
Future<void> ignoreNotification(String currentUser, String notifID) async {
  // Remove userID from currentUser's friendNotifs
  await usersRef.doc(currentUser).update({
    'notifs': FieldValue.arrayRemove([notifID]),
  });
  // If recipientList is empty, delete notification
  await notifsRef.doc(notifID).get().then((doc) {
    if (doc.data()!.recipientList.length <= 1) {
      notifsRef.doc(notifID).delete();
    } else {
      notifsRef.doc(notifID).update({
        'recipientList': FieldValue.arrayRemove([currentUser]),
      });
    }
  });
}

Future<void> ignoreFriendNotification(
    String currentUser, String userID, String notifID) async {
  // Remove userID from currentUser's friendNotifs
  await usersRef.doc(currentUser).update({
    'notifs': FieldValue.arrayRemove([notifID]),
    'friendNotifs': FieldValue.arrayRemove([userID])
  });
  await notifsRef.doc(notifID).delete();
}
