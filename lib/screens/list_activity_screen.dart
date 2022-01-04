import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/screens/widgets/list_item.dart';
import 'package:sample/viewmodel/list_api_viewmodel.dart';

class ListActivityScreen extends StatefulWidget {
  const ListActivityScreen({Key? key}) : super(key: key);

  @override
  _ListActivityScreenState createState() => _ListActivityScreenState();
}

class _ListActivityScreenState extends State<ListActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _bodyController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ListApiViewModel>(context, listen: false).getUserSummary();
  }

  @override
  Widget build(BuildContext context) {
    var vs = Provider.of<ListApiViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Sample'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(vs);
          },
          child: Text('Add'),
        ),
        body: _loadStatus(vs));
  }

  Widget _loadStatus(ListApiViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatus.completed:
        return _listData(vs.user_data, vs);
      case LoadingStatus.searching:
        return Center(child: CircularProgressIndicator());
      case LoadingStatus.empty:
        return Container(
          child: Text('No Data Found'),
        );
    }
    return SizedBox();
  }

  Widget _listData(List<UserViewModel> vs, ListApiViewModel viewModel) {
    return ListView.builder(
        itemCount: vs.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              elevation: 3,
              child: ListItem(
                ondeleteTap: () {
                  viewModel.onDelete(vs[index].id);
                },
                title: vs[index].title,
                description: vs[index].body,
              ));
        });
  }

  void showDialog(ListApiViewModel viewModel) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 300,
            child: Material(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                          controller: _titleController,
                          autofocus: true,
                          decoration: new InputDecoration(
                              labelText: 'title', hintText: 'eg. John Smith'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                          }),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                          controller: _bodyController,
                          autofocus: true,
                          decoration: new InputDecoration(
                              labelText: 'body', hintText: 'eg. some body'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                          }),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: ElevatedButton(
                          child: Text(
                            'Add Data',
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              viewModel.addUser(
                                  _titleController.text, _bodyController.text);
                              Navigator.pop(context);
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
