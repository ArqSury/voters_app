import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/services/firebase_service.dart';
import 'package:voters_app/views/firebase/user/branches/user_vote.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String currentTime = "";
  String currentDate = "";
  String greeting = "";
  bool hasVoted = false;
  bool loading = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
    _startClock();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startClock() {
    currentDate = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      currentTime = DateFormat('HH:mm:ss').format(now);
      if (mounted) setState(() {});
    });
  }

  Future<void> _loadHomeData() async {
    final citizen = await FirebaseService.instance.getCurrentCitizen();
    greeting = _getGreetingMessage();
    hasVoted = await FirebaseService.instance.hasCitizenVoted(citizen!.id);
    setState(() => loading = false);
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 11) return "Selamat Pagi!";
    if (hour < 15) return "Selamat Siang!";
    if (hour < 18) return "Selamat Sore!";
    return "Selamat Malam!";
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: NewColor.cream,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _headerCard(),
            const SizedBox(height: 30),
            _statusCard(),
            const SizedBox(height: 30),
            _voteButton(context),
          ],
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NewColor.redLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            currentDate,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
          Text(
            currentTime,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Icon(
            hasVoted ? Icons.check_circle : Icons.info,
            color: hasVoted ? Colors.green : Colors.orange,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasVoted
                  ? "Status: Anda sudah melakukan voting."
                  : "Status: Anda belum memilih.",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _voteButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: hasVoted ? Colors.grey : NewColor.redLight,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: hasVoted
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserVote()),
              );
            },
      child: Text(
        hasVoted ? "Anda sudah memilih" : "Mulai Voting",
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
