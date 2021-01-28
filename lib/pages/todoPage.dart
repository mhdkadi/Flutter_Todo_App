import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/database.dart';
import 'package:flutter_todo_app/models/task.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/widgets/widgets.dart';

class Taskpage extends StatefulWidget {
  final Task task;

  Taskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  TextEditingController descriptionController;
  TextEditingController titltController;
  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisile = false;

  @override
  void initState() {
    if (widget.task != null) {
      _contentVisile = true;

      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
    }
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 45,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(
                    width: 37,
                  ),
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
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () async {
            if (_taskId != 0) {
              await _dbHelper.deleteTask(_taskId);
              Navigator.pop(context);
            }
          },
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
            size: 45,
          ),
          backgroundColor: Colors.red[600],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 24.0,
                  bottom: 6.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (widget.task == null) {
                              Task _newTask = Task(title: value);
                              _taskId = await _dbHelper.insertTask(_newTask);
                              setState(() {
                                _contentVisile = true;
                                _taskTitle = value;
                              });
                            } else {
                              await _dbHelper.updateTaskTitle(_taskId, value);
                              print("Task Updated");
                            }
                            _descriptionFocus.requestFocus();
                          }
                        },
                        controller: TextEditingController()..text = _taskTitle,
                        decoration: InputDecoration(
                            labelText: "Task Title",
                            labelStyle: TextStyle(color: Colors.purple),
                            hintText: "Enter Task Title",
                            border: InputBorder.none),
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 6.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_taskId != 0) {
                              await _dbHelper.updateTaskDescription(
                                  _taskId, value);
                              _taskDescription = value;
                            }
                          }
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        decoration: InputDecoration(
                            labelText: "Task Description",
                            labelStyle: TextStyle(color: Colors.purple),
                            hintText: "Enter Description for the task...",
                            border: InputBorder.none),
                      )),
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                initialData: [],
                future: _dbHelper.getTodo(_taskId),
                builder: (context, snapshot) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            if (snapshot.data[index].isDone == 0) {
                              await _dbHelper.updateTodoDone(
                                  snapshot.data[index].id, 1);
                            } else {
                              await _dbHelper.updateTodoDone(
                                  snapshot.data[index].id, 0);
                            }
                            setState(() {});
                          },
                          child: TodoWidget(
                            text: snapshot.data[index].title,
                            isDone:
                                snapshot.data[index].isDone == 0 ? false : true,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              Visibility(
                visible: _contentVisile,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20.0,
                        height: 20.0,
                        margin: EdgeInsets.only(
                          right: 12.0,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(
                                color: Color(0xFF86829D), width: 1.5)),
                        child: Image(
                          image: AssetImage('assets/images/check_icon.png'),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _todoFocus,
                          controller: TextEditingController()..text = "",
                          onSubmitted: (value) async {
                            if (value != "") {
                              if (_taskId != 0) {
                                DatabaseHelper _dbHelper = DatabaseHelper();
                                Todo _newTodo = Todo(
                                  title: value,
                                  isDone: 0,
                                  taskId: _taskId,
                                );
                                await _dbHelper.insertTodo(_newTodo);
                                setState(() {});
                                _todoFocus.requestFocus();
                              } else {
                                print("Task doesn't exist");
                              }
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Todo item...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
