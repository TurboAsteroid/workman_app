import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


import './bloc.dart';
import './event.dart';
import './state.dart';
import '../person.dart';

class Book extends StatefulWidget {
  Book(this.url);

  final String url;

  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  bool showColleagues = false;
  BookBloc _bloc;
  final _formKey =
      new GlobalKey<FormState>(); // если поместить в initState то не работает
  String _searchString = "";

  @override
  void initState() {
    super.initState();
    _bloc = BookBloc(widget.url);
    
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Тел. справочник'),
//          actions: <Widget>[ToFavorites('Book')],
        ),
        body: BlocBuilder<BookBloc, BookState>(
          bloc: _bloc,
          builder: (BuildContext context, BookState state) {
            if (state is Searching) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
            if (state is Ok) {
              return _caseOK(state.users);
            }
            if (state is Nothing) {
              return _caseNothing(state.text);
            }
            if (state is Added) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _addedMessage(
                  context, 'В вашу адресную книгу контакт добавлен успешно'));
              return _caseOK(state.users);
            }
            if (state is Posted) {
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _addedMessage(context, state.text));
              return _caseOK(state.users);
            }
            if (state is Init) {
              return _caseDefault(state.text);
            }
            if (state is Error) {
              return _caseDefault(state.text);
            }
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Future<void> _addedMessage(BuildContext context, String txt) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(txt),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _caseNothing(String text) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                _showSearchInput(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    showColleagues ? _showColleagues() : Container(),
                    _showSendButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Text(text),
      ],
    );
  }

  Widget _showSearchInput() {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(
          hintText: 'Поиск абонента',
          icon: new Icon(
            Icons.search,
            color: Colors.grey,
          )),
      validator: (value) {
        if (value.isEmpty) return 'Строка поиска не может быть пустой';
        if (value.length < 3)
          return 'Строка поиска должна содержать более двух символов';
        return null;
      },
      onSaved: (value) => _searchString = value,
    );
  }

  Widget _showSendButton() {
    return ButtonTheme(
      buttonColor: Colors.blue,
      child: RaisedButton.icon(
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        label: Text(
          'Поиск',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          final form = _formKey.currentState;
          if (form.validate()) {
            form.save();
            _bloc.add(Search(context, _searchString));
            return true;
          }
          return false;
        },
      ),
    );
  }

  Widget _showColleagues() {
    return ButtonTheme(
      child: FlatButton.icon(
        icon: Icon(
          Icons.group,
          color: Colors.blue,
        ),
        label: Text(
          'Коллеги',
          style: TextStyle(color: Colors.blue),
        ),
        onPressed: () {
          _bloc.add(Colleagues());
        },
      ),
    );
  }

  Widget _caseOK(List<ADUser> users) {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                _showSearchInput(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    showColleagues ? _showColleagues() : Container(),
                    _showSendButton(),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Person(users[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _caseDefault(String text) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                _showSearchInput(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    showColleagues ? _showColleagues() : Container(),
                    _showSendButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Text(text),
      ],
    );
  }
}
