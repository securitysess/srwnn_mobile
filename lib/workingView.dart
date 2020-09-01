import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:photo_view/photo_view.dart';
//import 'package:image/image.dart' as image2;
import 'package:srwnn_mobile/imageView.dart';
import 'package:srwnn_mobile/main.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'Controllers/app_localizations.dart';
import 'Models/Inference.dart';
import 'loading.dart';

class InferenceView extends StatefulWidget {
  final File image;
  final String modelPath;

  InferenceView({this.image, this.modelPath});
  @override
  _InferenceViewState createState() => _InferenceViewState();
}

File newImage;

class _InferenceViewState extends State<InferenceView> {
  TensorImage tensorImage = TensorImage.fromFile(image);
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('confirmation_title')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          setState(() => loading = true);
          var gen = SRWGenerator(image: image, modelPath: selector.getModelPath());
          newImage = await gen.generate2xImage();
          setState(() => loading = false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImageView(image: newImage, orgImage: image,)),
            
          );
          //gen = null;
        },
        child: Text(AppLocalizations.of(context).translate('start_btn')),
      ),
      body: Center(
        child: Container(
          child: ListView(
            children: [
              //Spacer(),
              Container(
                //height: 350,
                child: Image.file(image, fit: BoxFit.contain,),
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Spacer(),
                  Text(AppLocalizations.of(context).translate('inp_height')),
                  SizedBox(width: 10,),
                  Text(tensorImage.height.toString()),
                  Spacer()
                ],
              ),

              Row(
                children: [
                  Spacer(),
                  Text(AppLocalizations.of(context).translate('inp_widht')),
                  SizedBox(width: 10,),
                  Text(tensorImage.width.toString()),
                  Spacer()
                ],
              ),

              Row(
                children: [
                  Spacer(),
                  Text(AppLocalizations.of(context).translate('expected_out')),
                  SizedBox(width: 10,),
                  Text((tensorImage.height*2).toString()),
                  Text('x'),
                  Text((tensorImage.width*2).toString()),
                  Spacer()
                ],
              ),
              //SizedBox(height: 15,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppLocalizations.of(context).translate('pre_process_warning'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange[900],
                  ),
                ),
              ),
              //Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}