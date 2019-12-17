//import 'package:flutter/material.dart';
//
//import './bloc.dart';
//import './event.dart';
//
//class ChangePassPage extends StatefulWidget {
//  final String user;
//  final String tmpPass;
//  final LoginBloc loginBloc;
//  BuildContext parentContext;
//
//  ChangePassPage(this.parentContext, this.loginBloc, this.user, this.tmpPass);
//
//  @override
//  _ChangePassPageState createState() => _ChangePassPageState();
//}
//
//class _ChangePassPageState extends State<ChangePassPage> {
//  final _formKey = new GlobalKey<FormState>();
//  String _password;
//  String _passwordRepeat;
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return _from();
//  }
//
//  Widget _from() {
//    return new Container(
//      padding: EdgeInsets.all(16.0),
//      alignment: Alignment.center,
//      child: new Form(
//        key: _formKey,
//        child: new ListView(
//          shrinkWrap: true,
//          children: <Widget>[
//            Text('Пожалуйста, задайте постоянный пароль'),
//            _showPasswordInput(),
//            _showPasswordInputRepeat(),
//            _showPrimaryButton(),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _showPasswordInput() {
//    return TextFormField(
//      maxLines: 1,
//      obscureText: true,
//      autofocus: true,
//      decoration: new InputDecoration(
//          hintText: 'Пароль',
//          icon: new Icon(
//            Icons.lock,
//            color: Colors.grey,
//          )),
//      validator: (value) {
//        if (value.isEmpty) return 'Введите постоянный пароль';
//        if (value != _passwordRepeat) return 'Пароли не совпадают';
//        return null;
//      },
//      onSaved: (value) => _password = value,
//    );
//  }
//
//  Widget _showPasswordInputRepeat() {
//    return TextFormField(
//      maxLines: 1,
//      obscureText: true,
//      autofocus: false,
//      decoration: new InputDecoration(
//          hintText: 'Пароль',
//          icon: new Icon(
//            Icons.lock,
//            color: Colors.grey,
//          )),
//      validator: (value) {
//        if (value.isEmpty) return 'Введите постоянный пароль';
//        if (value != _password) return 'Пароли не совпадают';
//        return null;
//      },
//      onSaved: (value) => _passwordRepeat = value,
//    );
//  }
//
//  Widget _showPrimaryButton() {
//    return Padding(
//      padding: const EdgeInsets.only(top: 8.0),
//      child: ButtonTheme(
//        buttonColor: Colors.blue,
//        minWidth: (MediaQuery.of(context).size.width * 0.9),
//        child: RaisedButton(
//          child: Text(
//            'Установить пароль',
//            style: TextStyle(color: Colors.white),
//          ),
//          onPressed: () {
//            final form = _formKey.currentState;
//            form.save();
//            if (form.validate()) {
//              if (_password == _passwordRepeat) {
//                widget.loginBloc.dispatch(DoChangePassEvent(
//                    widget.parentContext, {
//                  "user": widget.user,
//                  "password": _password,
//                  'tmpPass': widget.tmpPass
//                }));
//                return true;
//              } else {
//                form.validate();
//              }
//            }
//            return false;
//          },
//        ),
//      ),
//    );
//  }
//}
