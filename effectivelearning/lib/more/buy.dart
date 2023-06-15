import 'package:effectivelearning/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:effectivelearning/globals.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class BuyPage extends StatefulWidget {
  const BuyPage();
  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  dynamic courseId;
  dynamic amount;
  String instructor;
  String courseName;

  int _check;
  String url;
  String state;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _imageFile = null;
    courseId = glob['course_id'];
    amount = glob['amount'];
    instructor = glob['instructor'];
    courseName = glob['course_name'];
    _check = 0;
    url = baseUrl + 'attach_payment_document';
  }

  Future<String> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('payment_document', filename));
    var res = await request.send();
    return res.reasonPhrase;
  }

  PickedFile _imageFile;
  // To track the file uploading state
  bool _isUploading = false;
  //String baseUrl = 'http://YOUR_IPV4_ADDRESS/flutterdemoapi/api.php';
  String apiUrl = baseUrl +  'attach_payment_document';
  void _getImage(BuildContext context, ImageSource source) async {
    try
    {
      PickedFile image = await _picker.getImage(source: source);
      setState(() {
        _imageFile = image;
      });
      // Closes the bottom sheet
      Navigator.pop(context);
    }
    catch (Exception){

    }
    
  }
  Future<Map<String, dynamic>> _uploadImage(PickedFile image) async {
    setState(() {
      _isUploading = true;
    });
    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    // Intilize the multipart request
    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse(apiUrl));
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('payment_document', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.fields['amount'] = amount;
    imageUploadRequest.fields['cart_items'] = courseId;
    imageUploadRequest.fields['user_id'] = glob['user_id'];
    imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
     double scrWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: colBack,
      body: Column(
        children: <Widget>[
          sbLarge,
          Row(
            children: <Widget>[
              SizedBox(
                child: FlatButton(
                    child: Baseline(
                      baselineType: TextBaseline.alphabetic,
                      child: txt19BbC(" Cancel"),
                      baseline: 20.0,
                    ),
                    onPressed: () {
                      retPage(context);
                    }),
                width: 100,
              ),
              SizedBox(
                  child: Center(
                    child: txt19B("Buy Course"),
                  ),
                  width: scrWidth - 200),              
            ],
          ),
          divider,
          Flexible(
              child: SingleChildScrollView(
            child: Container(
              width: scrWidth * 0.9,
              child: Column(
                children: <Widget>[
                  sbLarge,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: scrWidth * 0.9 - 80,
                            child: txt22B(courseName),
                          ),
                          txt17(instructor)
                        ],
                      ),
                      txt22B(amount)
                    ],
                  ),
                  sbLarge,
                  Container(alignment: Alignment.centerLeft, child: txt16BbD("Select payment method"), width: scrWidth*0.8,),
                  Column(
                    children: <Widget>[
                      Container(      // Offline
                        width: 309,
                        height: 70,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: FlatButton(
                          child: Image(width: 300, height:70, image: AssetImage('assets/offlinePay.png')),
                          onPressed: () async {
                            // await _getImage(context, ImageSource.gallery);
                            // final Map<String, dynamic> response = await _uploadImage(_imageFile);
                            // zlog(response);
                            setState(() {
                              _check = 2;
                            });
                          },
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: _check == 2 ? Border.all(
                            color: colBase,
                            width: 1,
                          ) : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                  sbLarge,
                  Container(alignment: Alignment.centerLeft, child: txt16BbD("Payable amount"), width: scrWidth*0.8,),
                  txt18B(amount),
                  sbLarge,
                  Container(alignment: Alignment.centerLeft, child: txt16BbD("Select document of your payment"), width: scrWidth*0.8,),
                  sbSmall,
                  txt19BgC("(jpg, pdf, txt, png, docx)"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        child: txt20BbC("From Camera"),
                        onPressed: () async {
                          try{
                            PickedFile file = await _picker.getImage(source: ImageSource.camera);
                            setState(() {
                              _imageFile = file;
                            });
                          }
                          catch(Exception ){
                          }
                        },
                      ),
                      FlatButton(
                        child: txt20BbC("From Gallery"),
                        onPressed: () async{
                          PickedFile file = await _picker.getImage(source: ImageSource.gallery);
                          setState(() {
                            _imageFile = file;
                          });
                        },
                      )
                    ],
                  ),
                  sbSmall,
                  ButtonTheme(
                    height: 48,
                    minWidth: scrWidth * 0.6,
                    child: RaisedButton(
                        onPressed: () async {
                          if(_check == 2){
                            if(_imageFile != null){
                              final Map<String, dynamic> response = await _uploadImage(_imageFile);
                              if (response == null || response.containsKey("error")) {
                                Fluttertoast.showToast(
                                      msg: "Image Upload Failed.",
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                              } else {
                                setState(() {
                                  _imageFile = null;
                                });
                                Fluttertoast.showToast(
                                      msg: "Image Upload succsessed!",
                                      backgroundColor: Colors.green[400],
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                              }
                            }
                            else{
                              Fluttertoast.showToast(
                                msg: "Please select a document.",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                              );
                            }
                          }
                          
                        },
                        color: colBase,
                        textColor: Colors.white,
                        child: txt20BW("Send File"),
                        shape: shapeRndBorder10
                    ),
                  ),
                  sbLarge,
                  Container(
                    alignment: Alignment.centerLeft,                    
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        txt20B("Instruction"),
                        txt18("     Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."),
                        sbLarge,
                        sbLarge,
                        sbLarge,
                      ],
                    ),
                  )
                ],
              ),
            )
          ))
        ],
      ),
    );
  }
}
