import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/post_model.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/services/StorageServices.dart';
import 'package:vastermind/services/databaseService.dart';

import '../../utilities/constants.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _imageFile;
  TextEditingController _captionController = TextEditingController();
  String _caption = "";
  bool _isLoading = false;

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosDisplayDialog() : _androidDisplayDialog();
  }

  _iosDisplayDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text("Add Photo"),
          cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () => _handleImage(ImageSource.camera),
              child: Text("Take photo"),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _handleImage(ImageSource.gallery),
              child: Text("Choose From Gallery"),
            ),
          ],
        );
      },
    );
  }

  _androidDisplayDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Add Photo"),
            children: [
              SimpleDialogOption(
                onPressed: () => _handleImage(ImageSource.gallery),
                child: Text("Choose from Gallery"),
              ),
              SimpleDialogOption(
                onPressed: () => _handleImage(ImageSource.camera),
                child: Text("Take photo"),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          );
        });
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    PickedFile imageFilePicked = await ImagePicker().getImage(source: source);

    if (imageFilePicked != null) {
      File imageFile = await _cropImage(File(imageFilePicked.path));
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    return croppedImage;
  }

  _submit() async {
    if (!_isLoading && _imageFile != null && _caption.isNotEmpty) {
      setState(() {
        _isLoading == true;
      });

      //create post
      String _imageUrl = await StorageServices.uploadPost(_imageFile);
      Post post = Post(
        imageUrl: _imageUrl,
        caption: _caption,
        likes: {},
        authorId: Provider.of<UserData>(context, listen: false).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      DatabaseService.createPost(post);

      //rest all data
      _captionController.clear();
      setState(() {
        _caption = "";
        _imageFile = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          "Create Post",
          style: TextStyle(
              color: lightBlue, fontFamily: "TechnaSans", fontSize: 28),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _submit,
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: _height,
            child: Column(
              children: [
                _isLoading
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: LinearProgressIndicator(
                          backgroundColor: greyLight,
                          valueColor: AlwaysStoppedAnimation(lightBlue),
                        ),
                      )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: _showSelectImageDialog,
                  child: Container(
                      width: _width,
                      height: _width,
                      color: greyLight,
                      child: _imageFile == null
                          ? Icon(
                              Icons.add_a_photo_outlined,
                              color: white,
                              size: 120,
                            )
                          : Image(
                              fit: BoxFit.cover, image: FileImage(_imageFile))),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: _captionController,
                    style: TextStyle(fontSize: midSizeText),
                    decoration: InputDecoration(labelText: "Caption"),
                    onChanged: (input) => _caption = input,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
