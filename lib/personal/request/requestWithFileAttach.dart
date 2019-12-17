import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:personal/personal/network/network.dart';


class RequestWithFileAttach extends StatefulWidget {
  final String url;
  final String header;
  final String id;

  RequestWithFileAttach({@required this.header, @required this.url, this.id});

  @override
  State<StatefulWidget> createState() => RequestWithFileAttachState();
}

class RequestWithFileAttachState extends State<RequestWithFileAttach> {
  final uploader = FlutterUploader();
  final _formKey = GlobalKey<FormState>();
  final _themeController = TextEditingController();
  final _descController = TextEditingController();
  _Bloc _bloc;
  String _fileName;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _hasValidMime = false;
  FileType _pickingType = FileType.ANY;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = _Bloc(widget.url, uploader);
    _controller.addListener(() => _extension = _controller.text);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        _paths = await FilePicker.getMultiFilePath(
            type: _pickingType, fileExtension: _extension);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _fileName = _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.header),
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, _State state) {
          if (state is _ProgressSt) {
            return Center(
                child: Text(
              state.progress,
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.display4,
            ));
          }
          if (state is _InitSt) {
            return SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _themeController,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      decoration: new InputDecoration(
                          hintText: 'Тема',
                          icon: new Icon(
                            Icons.title,
                          )),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите тему';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _descController,
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                          hintText: 'Описание',
                          icon: new Icon(
                            Icons.description,
                          )),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите описание';
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton.icon(
                              onPressed: () => _openFileExplorer(),
                              label: Text('Прикрепить файл'),
                              icon: Icon(Icons.attach_file),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _bloc.add(_SendEv(
                                      FeedbackForm.fromJson({
                                        "title":
                                            _themeController.text.toString(),
                                        "body": _descController.text.toString()
                                      }),
                                      _paths));
                                }
                              },
                              label: Text('Отправить'),
                              icon: Icon(Icons.send),
                            ),
                          )),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Builder(
                        builder: (BuildContext context) => _loadingPath
                            ? Center(child: const CircularProgressIndicator())
                            : _paths != null
                                ? new Container(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    height: MediaQuery.of(context).size.height *
                                        0.50,
                                    child: new Scrollbar(
                                        child: new ListView.separated(
                                      itemCount:
                                          _paths != null && _paths.isNotEmpty
                                              ? _paths.length
                                              : 1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final bool isMultiPath =
                                            _paths != null && _paths.isNotEmpty;
                                        final String name = (isMultiPath
                                            ? _paths.keys.toList()[index]
                                            : _fileName ?? '...');
                                        final path = _paths.values
                                            .toList()[index]
                                            .toString();

                                        return new ListTile(
                                          title: new Text(
                                            name,
                                          ),
                                          subtitle: new Text(path),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              new Divider(),
                                    )),
                                  )
                                : new Container(),
                      ),
                    ],
                  ),
                ],
              ),
            ));
          } else if (state is _LoadingSt) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is _ResponseOkSt) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.done,
                    color: Colors.green,
                    size: 86,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.display4,
                    ),
                  ),
                  RaisedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text('ОК'),
                    icon: Icon(Icons.done),
                  )
                ],
              ),
            );
          }
          if (state is _ResponseErrorSt) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 86,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.display4,
                    ),
                  ),
                  state.form != null
                      ? FlatButton.icon(
                          onPressed: () {
                            _bloc.add(_SendEv(state.form, state.paths));
                          },
                          label: Text('Повторить'),
                          icon: Icon(Icons.replay),
                        )
                      : Container()
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _Bloc extends Bloc<_Event, _State> {
  _Bloc(this.url, this.uploader);

  final String url;
  final FlutterUploader uploader;

  FeedbackForm form;
  Map<String, String> paths;

  @override
  _State get initialState => _InitSt();

  @override
  Stream<_State> mapEventToState(_Event event) async* {
    if (event is _ProgressEv) {
      yield _ProgressSt(event.progress.toString());

    }
    if (event is _SendEv) {
      form = event.form;
      paths = event.paths;
      yield _LoadingSt();
      List<FileItem> files = [];
      paths.keys.forEach((key) {
        files.add(FileItem(
            filename: key,
            savedDir: paths[key]
                .substring(0, paths[key].length - key.length),
            fieldname: 'files'));
      });
      String token = await (FlutterSecureStorage()).read(key: 'token');
      String tag = 'upload';
      try {
        await uploader.enqueue(
            url: url,
            files: files,
            method: UploadMethod.POST,
            data: form.toJson(),
            headers: {
              'Authorization': token,
              'Content-Type': 'multipart/form-data'
            },
            tag: tag);
        uploader.progress.listen((progress) {
          this.add(_ProgressEv(progress.progress));
        });
        uploader.result.listen((result) {
          this.add(
              _SetOkEv(ServerResponse.fromJson(json.decode(result.response))));
        }, onError: (ex, stacktrace) {
          this.add(_ErrorEv());
          print("exception: $ex");
          print("stacktrace: $stacktrace" ?? "no stacktrace");
        });
      } catch (e) {
        yield _ResponseErrorSt(e.message, form, paths);
        print(e);
      }
    }
    if (event is _SetOkEv) {
      yield _ResponseOkSt(event.sr.data['message']);
    }
    if (event is _ErrorEv) {
      yield _ResponseErrorSt('Отправки формы и загрузки файла. Попробуйте позже', form, paths);
    }
  }
}

abstract class _Event {}

class _ProgressEv extends _Event {
  int progress;

  _ProgressEv(this.progress);
}

class _SetOkEv extends _Event {
  ServerResponse sr;

  _SetOkEv(this.sr);
}

class _SendEv extends _Event {
  FeedbackForm form;
  Map<String, String> paths;

  _SendEv(this.form, this.paths);

  @override
  String toString() => '_SendEv';
}

class _ErrorEv extends _Event {}

abstract class _State {}

class _InitSt extends _State {
  @override
  String toString() => '_InitSt';
}

class _LoadingSt extends _State {
  @override
  String toString() => '_LoadingSt';
}

class _ResponseOkSt extends _State {
  String message;

  _ResponseOkSt(this.message);

  @override
  String toString() => '_ResponseOkSt';
}

class _ResponseErrorSt extends _State {
  String message;
  FeedbackForm form;
  Map<String, String> paths;

  _ResponseErrorSt(this.message, this.form, this.paths);

  @override
  String toString() => '_ResponseErrorSt';
}

class _ProgressSt extends _State {
  String progress;

  _ProgressSt(this.progress);

  @override
  String toString() => '_ProgressSt';
}

class FeedbackForm {
  String title;
  String body;

  FeedbackForm({this.title, this.body});

  FeedbackForm.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = {};
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}
