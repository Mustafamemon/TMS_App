

//-------------------------ISSUE WITH WEB DUE TO ROUTE BLOCK USING REDUX -------------------------------
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class TMSExplorer extends StatefulWidget {
//   @override
//   _TMSExplorerState createState() => _TMSExplorerState();
// }

// class _TMSExplorerState extends State<TMSExplorer> {
//   Completer<WebViewController> _controller = Completer<WebViewController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text('Transport Management System'),
//         ),
//         actions: <Widget>[
//           NavigationControls(_controller.future),
//         ],
//       ),
//       body: WebView(

//         initialUrl: 'http://tms-studentportal.herokuapp.com/',
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//           print(webViewController.currentUrl());
//           webViewController.loadUrl('http://tms-studentportal.herokuapp.com/');
//           _controller.complete(webViewController);
//         },
//       ),
//     );
//   }
// }

// class NavigationControls extends StatelessWidget {
//   const NavigationControls(this._webViewControllerFuture)
//       : assert(_webViewControllerFuture != null);

//   final Future<WebViewController> _webViewControllerFuture;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: _webViewControllerFuture,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
//         final bool webViewReady =
//             snapshot.connectionState == ConnectionState.done;

//         final WebViewController controller = snapshot.data;
//         return Row(
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () => navigate(context, controller, goBack: true),
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () => navigate(context, controller, goBack: false),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   navigate(BuildContext context, WebViewController controller,
//       {bool goBack: false}) async {
//     bool canNavigate =
//         goBack ? await controller.canGoBack() : await controller.canGoForward();
//     if (canNavigate) {
//       goBack ? controller.goBack() : controller.goForward();
//     } else {
//       Scaffold.of(context).showSnackBar(
//         SnackBar(
//             content: Text("No ${goBack ? 'back' : 'forward'} history item")),
//       );
//     }
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreen createState() => _WebViewScreen();
}

class _WebViewScreen extends State<WebViewScreen> {
  final loading = CircularProgressIndicator(
    valueColor:
        new AlwaysStoppedAnimation<Color>(Color.fromRGBO(96, 114, 150, 1)),
    backgroundColor: Colors.white,
  );
  String url = "https://www.google.com/";
 

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged>
      _onchanged; // here we checked the url state if it loaded or start Load or abort Load

  @override
  void initState() {
    super.initState();
    _onchanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if (state.type == WebViewState.finishLoad) {
          // if the full website page loaded
          print("loaded...");
        } else if (state.type == WebViewState.abortLoad) {
          // if there is a problem with loading the url
          print("there is a problem...");
        } else if (state.type == WebViewState.startLoad) {
          // if the url started loading
          print("start loading...");
          
        }
      }
    });
  }

  @override
  void dispose() {
   flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: url,
        
        withJavascript: true,
        withZoom: false,
        hidden: true,
        appBar: AppBar(
          title: Text("Transport Management System"),
          centerTitle: false,
          elevation: 1, // give the appbar shadows
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            Row(
              children: <Widget>[
                InkWell(
                  child: Icon(Icons.refresh),
                  onTap: () {
                    flutterWebviewPlugin.reload();
                    // flutterWebviewPlugin.reloadUrl(); // if you want to reloade another url
                  },
                ),
                InkWell(
                  child: Icon(Icons.stop),
                  onTap: () {
                    flutterWebviewPlugin.stopLoading(); // stop loading the url
                  },
                ),
                InkWell(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () {
                    flutterWebviewPlugin.goBack();
                  },
                ),
                InkWell(
                  child: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    flutterWebviewPlugin.goForward();
                  },
                ),
              ],
            )
          ],
        ),
        initialChild: Container(
          color: Colors.white,
          child: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[ loading,Text('Loading...')])
          ),
        ));
  }
}
