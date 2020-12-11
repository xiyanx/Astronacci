import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:astronacci/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return new Stack(children: <Widget>[
      new Container(color: Colors.blue,),
      new BackdropFilter(
          filter: new ui.ImageFilter.blur(
            sigmaX: 6.0,
            sigmaY: 6.0,
          ),
          child: new Container(
            decoration: BoxDecoration(
              color:  Colors.blue.withOpacity(0.9),
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),)),
      new Scaffold(
        appBar: new AppBar(
          title: Text('B Home'),
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                child: Text("List User", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Divider(height: _height/30,color: Colors.white),
              StreamBuilder(
                stream:
                FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final docs = snapshot.data.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final user = docs[index].data();
                        return Center(
                          child: new Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(user['name'] ?? user['email']),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    user['imageUrl'],
                                  ),
                                  radius: 60,
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              new Divider(height: _height/30,color: Colors.white),
              new Padding(
                padding: new EdgeInsets.only(left: _width/8, right: _width/8),
                child: new FlatButton(
                  onPressed: (){
                    AuthHelper.logOut();
                  },
                  child: new Container(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Icon(Icons.person),
                          new SizedBox(width: _width/30,),
                          new Text('Log out')
                        ],
                      )
                  ),
                  color: Colors.blue[50],
                ),
              ),
              new Divider(height: _height/30,color: Colors.white),
              Align(
                alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                child: Text("Video Example", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              new Divider(height: _height/30),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 300,
                    width: 120,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            image: DecorationImage(
                                fit: BoxFit.cover, image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/b/b2/JPEG_compression_Example.jpg')),
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            color: Colors.redAccent,
                          ),
                          height: 100,
                          width: 80,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  top: 5,
                                  right: 10,
                                ),
                                child: Text(
                                  "Test Judul",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      )
    ],);
  }
}
