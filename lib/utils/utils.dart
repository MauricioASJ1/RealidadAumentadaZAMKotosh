import '../models/user.dart';

String whatTypeOfUser(PPUser currentUser, PPUser otherUser) {
  if (currentUser.userID == otherUser.userID) {
    return 'self';
  } else if (true) {
    return 'friend';
  }
}
