import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:personal/config.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class _SimpleHtmlState extends State<SimpleHtml> {
  String _url;

  @override
  void initState() {
    super.initState();
    ((FlutterSecureStorage()).read(key: 'token')).then((token) {
      setState(() {
        _url = '$apiServer/${widget.url}?token=${token.replaceAll('BEARER ', '')}';
      });
    });
    
  }

  final _key = UniqueKey();
  num _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _url == null
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : IndexedStack(
            index: _stackToView,
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                      child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url,
                    onPageFinished: _handleLoad,
                  )),
                ],
              ),
              Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
  }
}

class SimpleHtml extends StatefulWidget {
  final url;

  SimpleHtml(this.url);

  @override
  createState() => _SimpleHtmlState();
}
