import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/screens/accountability/accountability_group_info_screen.dart';
import 'package:vastermind/services/AuthService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/services/StorageServices.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/reusable_card.dart';
import 'package:vastermind/utilities/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  static const id = "editProfileScreen";



  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File _profileImage;
  String _fullName = "";
  String _name = "";
  bool _isLoading = false;

  User user = User();

  @override
  void initState() {
    super.initState();
  }

  _handleImageFromGallery() async {
    print("inside _handleImageFromGallery");
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    } else
      print("no image selected");
  }

  displayProfileImage() {
    //no new profile image
    if (_profileImage == null) {
      //no old image
      if (user.profileImageUrl.isEmpty) {
        return AssetImage('assets/images/profileImage.png');
      }
      //there exsts an old image
      else {
        return CachedNetworkImageProvider(user.profileImageUrl);
      }
    }
    //new profile image
    else {
      return FileImage(_profileImage);
    }
  }

  _submit() async {
    print("1" + _isLoading.toString());
    if (_formKey.currentState.validate() && !_isLoading) {
      //everything that is inside the Form widget with given key will have the function onSaved() being ran
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      print("2" + _isLoading.toString());
      String _profileImageUrl = "";

      if (_profileImage == null) {
        _profileImageUrl = user.profileImageUrl;
      } else {
        _profileImageUrl = await StorageServices.uploadUserProfileImage(
            user.profileImageUrl, _profileImage);
      }
      User newUser = User(
          id: user.id,
          name: _name,
          profileImageUrl: _profileImageUrl,
          fullName: _fullName);

      await DatabaseService.updateUser(newUser);
      Provider.of<UserData>(context, listen: false).updateUseretails(newUser);


      setState(() {
        _isLoading = false;
      });
      print("3" + _isLoading.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    user = Provider.of<UserData>(context, listen: false).currUser;
    _fullName  = user.fullName;
    _name = user.name;

    return Scaffold(
      appBar: SecondaryAppBar(title: user.name),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: greyLight,
                    valueColor: AlwaysStoppedAnimation(lightBlue),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: greyLight,
                      backgroundImage: displayProfileImage(),
                    ),
                    ButtonNoFill(function: () {
                      _handleImageFromGallery();
                      print("inside on pressed");
                    }, title: "Change profile image", textSize: smallSizeText,),
                    // TextFormField(
                    //   initialValue: name,
                    //   decoration: InputDecoration(
                    //     labelText: "Username",
                    //     icon: Icon(
                    //       Icons.person,
                    //       size: largeSizeText,
                    //     ),
                    //   ),
                    //   onSaved: (input) => name = input,
                    // ),
                    TextFormField(
                      initialValue: user.fullName,
                      style: TextStyle(color: grey,fontSize: midSizeText),
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        icon: Icon(
                          Icons.person,
                          size: 30,
                        ),
                      ),
                      onSaved: (input) => _fullName = input,
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: Provider.of<UserData>(context).currGroup != null ? (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_){
                                  return AccountabilityGroupInfoScreen(group: Provider.of<UserData>(context).currGroup,);
                                }));
                      } : (){},
                      child: ReusableCard(color: greyLight, cardChild: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_rounded, color: grey,size: 27,),
                          SizedBox(width:10 ,),
                          Text("My Group", style: TextStyle(color: grey, fontSize: midSizeText),),
                        ],),),
                    ),

                    FilledSecondaryButton(
                      top:20,
                        title: "Save Changes",
                        color: lightBlue,
                        buttonSize: "large",
                        function:  _submit),
                    FilledSecondaryButton(
                        top: 0,
                        title: "Sign Out",
                        buttonSize: "large",
                        color: grey,
                        function: () {
                          AuthService.logout(context);
                          //Navigator.of(context).pop();
                        })

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


