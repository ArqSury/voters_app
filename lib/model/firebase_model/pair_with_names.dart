import 'package:voters_app/model/firebase_model/pairs_firebase.dart';

class PairWithNames {
  final PairsFirebase pair;
  final String presidentName;
  final String viceName;

  PairWithNames({
    required this.pair,
    required this.presidentName,
    required this.viceName,
  });
}
