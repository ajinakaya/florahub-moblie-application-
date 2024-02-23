import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:florhub/services/localnotification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? _image;

  void _pickImage() async {
    final picker = ImagePicker();

    // Show bottom sheet for camera/gallery selection
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await picker.getImage(source: ImageSource.camera);
                _setImage(pickedFile);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await picker.getImage(source: ImageSource.gallery);
                _setImage(pickedFile);
              },
            ),
          ],
        );
      },
    );
  }

  void _setImage(PickedFile? pickedFile) {
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void logout() async{
    _ui.loadState(true);
    try{
      await _auth.logout().then((value){
        Navigator.of(context).pushReplacementNamed('/login');
      })
          .catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
      });
    }catch(err){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    }
    _ui.loadState(false);
  }

  late GlobalUIViewModel _ui;
  late AuthViewModel _auth;

  @override
  void initState() {
    _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    _auth = Provider.of<AuthViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (_image != null)
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: FileImage(_image!),
                  )
                else
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: _image == null
                          ? DecorationImage(
                        image: AssetImage('assets/icon/users.jpg'),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _image == null
                        ? IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.grey,
                        size: 40,
                      ),
                      onPressed: _pickImage,
                    )
                        : null,
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(_auth.loggedInUser!.email.toString()),
          ),
          SizedBox(
            height: 25,
          ),
          makeSettings(
            icon: Icon(Icons.sell),
            title: "My Products",
            subtitle: "Get a listing of my products",
            onTap: () {
              Navigator.of(context).pushNamed("/my-products");
            },
          ),
          SizedBox(
            height: 10,
          ),
          makeSettings(
            icon: Icon(Icons.logout),
            title: "Logout",
            subtitle: "Logout from this application",
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }

  makeSettings({required Icon icon, required String title, required String subtitle, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          elevation: 4,
          color: Colors.white,
          child: ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            leading: icon,
            title: Text(
              title,
            ),
            subtitle: Text(
              subtitle,
            ),
          ),
        ),
      ),
    );
  }
}
