import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos/shared/boxdecoration.dart';
import 'package:todos/shared/decoration.dart';
import 'package:todos/shared/intro.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String task;
  //pop up sorting panel
  void _showSettingsPanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: boxDecoration,
            padding: EdgeInsets.symmetric(vertical: 45.0, horizontal: 60.0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Text(
                        "Sort All Your Tasks!",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'ProductSans',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff394D97),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                    child: FlatButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Color(0xff394D97),
                      onPressed: () {
                        setState(() {
                          _todoItems.sort();
                          Navigator.pop(context);
                        });
                      },
                      icon: Icon(Icons.sort_by_alpha, color: Colors.white,),
                      label: Text(
                        'Sort Alphabetically',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'ProductSans',

                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  List<String> _todoItems = [];

  //add tasks
  _addTodoItem(String task) {
    // Only add the task if the user actually entered something
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
    }
  }

  //popup on fab press to add tasks
  createAddTaskPopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Add Tasks",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ProductSans',
                  color: Color(0xff394D97)),
            ),
            content: TextField(
              decoration: textInputDecoration,
              onChanged: (val) {
                task = val;
              },
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  _addTodoItem(task);
                  Navigator.pop(context);
                },
                color: Color(0xff394D97),
                splashColor: Color(0xffC8CFEA),
                child: Text("Done",
                    style: TextStyle(
                      fontFamily: 'ProductSans',
                    )),
              ),
            ],
          );
        });
  }

  //list tile for tasks to show
  Widget _buildTodoItem(String todoText, int index) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      elevation: 0,
      color: Color(0xffEFEFEF),
      child: ListTile(
          title: new Text(todoText),
          trailing: Icon(
            Icons.arrow_back,
            color: Color(0xffA4B1E2),
          )),
    );
  }

  GlobalKey<ScaffoldState> _key = GlobalKey();

  Widget title = Text(
    "TODOs",
    style: TextStyle(
      fontFamily: 'ProductSans',
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff394D97),
        splashColor: Color(0xffC8CFEA),
        label: Text('Add Tasks', style: TextStyle(fontFamily: 'ProductSans')),
        onPressed: () {
          createAddTaskPopUp(context);
        },
        icon: Icon(Icons.add),
      ),
      appBar: AppBar(
        brightness: Brightness.dark,//changes statusBar icon color
        backgroundColor: Color(0xff394D97),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            color: Colors.white,
            onPressed: () {
              _showSettingsPanel();
            },
          ),
        ],
        centerTitle: true,
        title: title,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 10, 20),
            child: introText,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 75, 0, 0),
            child: ListView.builder(
            itemBuilder: (context, index) {
              if (index < _todoItems.length) {
                //swipe to delete tasks
                return Dismissible(
                    key: Key(_todoItems[index]),
                    child: _buildTodoItem(_todoItems[index], index),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      setState(() {
                        String deletedItem = _todoItems.removeAt(index);
                        _key.currentState
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text("Task Complete"),
                              backgroundColor: Color(0xff394D97),
                              action: SnackBarAction(
                                  label: "UNDO",
                                  textColor: Colors.white,
                                  onPressed: () => setState(
                                        () => _todoItems.insert(index, deletedItem),
                                      ) //undo the deleted item and insert it back again
                                  ),
                            ),
                          );
                      });
                    });
              }
              return null;
            },
        ),
          ),
        ],
      ),
    );
  }
}
