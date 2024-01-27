import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocationScreen extends StatefulWidget{
  const LocationScreen({super.key,required this.locationUrl});

  final String locationUrl;

  @override
  State<LocationScreen> createState(){
    return _LocationScreenState();
  }
}

class _LocationScreenState extends State<LocationScreen> {

  final webController=WebViewController();

  @override
  Widget build(context){
    webController..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(Uri.parse(widget.locationUrl));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
      ),
      body: WebViewWidget(
        controller: webController,
      ),
    );
  }
}