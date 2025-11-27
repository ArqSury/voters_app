import 'package:flutter/material.dart';
import 'package:voters_app/constant/app_color.dart';
import 'package:voters_app/services/firebase_service.dart';

class ManageVoting extends StatefulWidget {
  const ManageVoting({super.key});

  @override
  State<ManageVoting> createState() => _ManageVotingState();
}

class _ManageVotingState extends State<ManageVoting> {
  bool loading = false;

  Future<void> resetVotes() async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Reset Voting?"),
        content: Text(
          "Semua suara akan dihapus dan hasil voting kembali ke 0.",
        ),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Reset"),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => loading = true);
    await FirebaseService.instance.resetAllVotes();
    setState(() => loading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Voting telah direset.")));
  }

  Future<void> toggleVoting(bool open) async {
    await FirebaseService.instance.setVotingStatus(open);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Voting berhasil ${open ? "dibuka" : "ditutup"}."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewColor.cream,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<bool>(
              stream: FirebaseService.instance.watchVotingStatus(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final isOpen = snap.data!;
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Voting Status: ${isOpen ? "OPEN" : "CLOSED"}",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isOpen ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOpen ? Colors.red : Colors.green,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        icon: Icon(isOpen ? Icons.lock : Icons.lock_open),
                        label: Text(isOpen ? "CLOSE VOTING" : "OPEN VOTING"),
                        onPressed: () => toggleVoting(!isOpen),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        icon: Icon(Icons.restart_alt),
                        label: Text("RESET VOTING"),
                        onPressed: resetVotes,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
