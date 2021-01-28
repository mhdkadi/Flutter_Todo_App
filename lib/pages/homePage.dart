import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/database.dart';
import 'package:flutter_todo_app/pages/todoPage.dart';
import 'package:flutter_todo_app/widgets/widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Taskpage(
                        task: null,
                      )),
            ).then((value) {
              setState(() {});
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 50,
          ),
          backgroundColor: Colors.purple[600],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Flutter",
                    style: TextStyle(
                        color: Colors.purple[600],
                        fontFamily: 'Overpass',
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "TaskManager",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Overpass',
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: FutureBuilder(
                  initialData: [
                    //Task(id: 20, title: 'title', description: 'description') //TODO
                  ],
                  future: _dbHelper.getTasks(),
                  builder: (context, snapshot) {
                    return ScrollConfiguration(
                      behavior: NoGlowBehaviour(),
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Taskpage(
                                    task: snapshot.data[index],
                                  ),
                                ),
                              ).then(
                                (value) {
                                  setState(() {});
                                },
                              );
                            },
                            child: TaskCardWidget(
                              taskId: snapshot.data[index].id,
                              title: snapshot.data[index].title,
                              desc: snapshot.data[index].description,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
