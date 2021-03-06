import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veto/widgets/profile/profile_settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue),
        ),
        actions: [
          InkWell(
            child: Icon(Icons.logout),
            onTap: () {
              FirebaseAuth.instance.signOut();
              setState(() {});
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot<Map>>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder: (context, docs) {
                  if (docs.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  var userData = docs.data?.data() ?? [];
                  userData = userData as Map;

                  return ProfileSettings(
                      email: userData['email'],
                      username: userData['username'],
                      userId: FirebaseAuth.instance.currentUser!.uid);
                })
          ],
        ),
      ),
    );
  }
}
