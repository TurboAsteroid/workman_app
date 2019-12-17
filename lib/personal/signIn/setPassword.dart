import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/personal/signIn/bloc.dart';
import 'package:personal/personal/signIn/userPassword.dart';

class SetPassword extends StatefulWidget {
  final UserPassword up;
  final LoginBloc loginBloc;

  SetPassword(this.up, this.loginBloc);

  @override
  State<StatefulWidget> createState() => SetPasswordState();
}

class SetPasswordState extends State<SetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _pwdMainController = TextEditingController();
  final _pwdRepeatController = TextEditingController();

  @override
  void dispose() {
    widget.loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Установка нового пароля'),
      ),
      body: BlocBuilder(
        bloc: widget.loginBloc,
        builder: (BuildContext context, LoginState state) {
          Widget error = Container();
          if (state is LoginError)
            error = Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Text(state.error.toString()),
            );
          if(state is SetPasswordFormState) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _pwdMainController,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      obscureText: true,
                      decoration: new InputDecoration(
                          hintText: 'Пароль',
                          icon: new Icon(
                            Icons.lock,
                            color: Colors.grey,
                          )),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите пароль';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _pwdRepeatController,
                      maxLines: 1,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                          hintText: 'Повторите пароль',
                          icon: new Icon(
                            Icons.lock,
                            color: Colors.grey,
                          )),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Повторите пароль';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.green,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          widget.loginBloc.add(DoChangePassEvent(
                            context,
                            UserPassword(
                              user: widget.up.user,
                              password: _pwdMainController.text.toString(),
                            ),
                            widget.up.password,
                          ));
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Установить пароль',
                            style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .buttonColor,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Icon(
                            Icons.send,
                            color: Theme
                                .of(context)
                                .buttonColor,
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                  ),
                  error,
                ],
              ),
            );
          }
          if (state is LoginShowPreloader) {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }
}
