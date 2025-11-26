import 'package:voters_app/model/firebase_model/pairs_firebase.dart';

class PairWithNames {
  final PairsFirebase pair;
  final String presidentName;
  final String viceName;
  final String? presidentImagePath;
  final String? viceImagePath;
  final int number;

  PairWithNames({
    required this.pair,
    required this.presidentName,
    required this.viceName,
    this.presidentImagePath,
    this.viceImagePath,
    required this.number,
  });
}
