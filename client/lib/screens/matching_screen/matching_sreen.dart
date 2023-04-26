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
                likeAction: () {
                  print("Like");
                },
                nopeAction: () {
                  print("Nope");
                },
                superlikeAction: () {
                  print("Superlike");
                },
              ),
            )
            .toList(),
      );
    });
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
