class PPUser {
  // Fields within User table
  String userID;
  String userName;
  String lowercaseName;
  String age;
  DateTime dateJoined;
  String language;
  List<Map<String, dynamic>> interestPoints;
  List<String> notifs;

  // Constructor to initialize all fields
  PPUser({
    required this.userID,
    required this.userName,
    required this.lowercaseName,
    required this.age,
    required this.dateJoined,
    required this.interestPoints,
    required this.notifs,
    required this.language,
  });

  // Named constructor for when getting JSON object from firebase
  factory PPUser.fromJson(Map<String, dynamic> map) => PPUser(
        userID: map['userID'],
        userName: map['userName'],
        lowercaseName: map['lowercaseName'],
        age: map['profilePicUrl'],
        // Firebase stores dates as "timestamp" so need to convert to DateTime
        dateJoined: DateTime.fromMillisecondsSinceEpoch(
            map['dateJoined'].millisecondsSinceEpoch),
        interestPoints:
            List<Map<String, dynamic>>.from(map['pointsOfInterest'] ?? []),
        notifs: List<String>.from(map['notifs']),
        language: map['language'],
      );

  // Instance method that returns Map<String, dynamic> so can be stored in firestore
  Map<String, dynamic> toJson() => {
        "userID": userID,
        "userName": userName,
        "lowercaseName": lowercaseName,
        "age": age,
        "dateJoined": dateJoined,
        "interestPoints": interestPoints,
        "notifs": notifs,
        "language": language,
      };
}
