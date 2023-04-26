import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late MatchEngine matchEngine;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<Map<String, dynamic>> users = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      matchEngine = MatchEngine(
        swipeItems: users
            .map(
              (user) => SwipeItem(
                content: user,
                likeAction: () async {
                  print("Like");

                  // マッチングチェック
                  DocumentSnapshot userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user['username'])
                      .get();
                  if (userDoc.exists) {
                    List likedBy = (userDoc.data() as Map<String, dynamic>)?['likedBy'] ?? [];
                    String myUsername = '自分のユーザーネーム'; // 自分のユーザーネームを設定する

                    if (likedBy.contains(myUsername)) {
                      // 相手が自分をLIKEしていた場合
                      showMatchDialog(context);
                      await createMatch(myUsername, user['username']);

                      // 自分のユーザードキュメントから相手を likedBy から削除する
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(myUsername)
                          .update({
                        'likedBy': FieldValue.arrayRemove([user['username']])
                      });
                    } else {
                      // 相手が自分をLIKEしていなかった場合
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user['username'])
                          .update({
                        'likes': FieldValue.arrayUnion([myUsername])
                      });
                    }
                  }
                },
                nopeAction: () {
                  print("Nope");
                },
              ),
            )
            .toList(),
      );
    });
  }

  Future<void> showMatchDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('おめでとうございます！'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('マッチしました！'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> createMatch(String user1, String user2) async {
    CollectionReference matchesRef =
        FirebaseFirestore.instance.collection('matches');

    // マッチドキュメントを作成する
    DocumentReference matchDocRef = await matchesRef.add({
      'user1': user1,
      'user2': user2,
    });

    // 両者のドキュメントにマッチ情報を追加する
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user1)
        .collection('matches')
        .doc(matchDocRef.id)
        .set({'matchId': matchDocRef.id, 'user1': user1, 'user2': user2});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user2)
        .collection('matches')
        .doc(matchDocRef.id)
        .set({'matchId': matchDocRef.id, 'user1': user1, 'user2': user2});

    // 両者のドキュメントにメッセージサブコレクションを作成する
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user1)
        .collection('messages')
        .add({});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user2)
        .collection('messages')
        .add({});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background_image2.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: SwipeCards(
                    matchEngine: matchEngine,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    '${matchEngine.currentItem!.content['image']}'),
                                fit: BoxFit.fill //画像の指定
                                ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          '${matchEngine.currentItem!.content['name']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          '${matchEngine.currentItem!.content['age']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: List<Widget>.generate(
                                      matchEngine.currentItem!
                                          .content['interests'].length,
                                      (int index) {
                                        String hobby = matchEngine.currentItem!
                                            .content['interests'][index];
                                        return IntrinsicWidth(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.pinkAccent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 3, 8, 3),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    hobby,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                      '${matchEngine.currentItem?.content['bio']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onStackFinished: () {
                      // 全てのカードがスワイプされた後の処理
                      print("No more users");
                    },
                    itemChanged: (SwipeItem item, int index) {
                      // スタック内のアイテムが変更されたときの処理
                      print("Item changed: index: $index");
                    },
                    upSwipeAllowed: true,
                    fillSpace: true,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          selectedItemColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Top',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
