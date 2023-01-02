import 'dart:io';
import 'dart:math';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: home(),
    debugShowCheckedModeBanner: false,
  ));
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();

  bool img = false;
  ImagePicker _picker = ImagePicker();
  XFile? image;
  String str = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_permission();
  }

  get_permission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
        title: Text("Form"),
      ),
      body: Column(
        children: [
          TextField(
            controller: t1,
            decoration: InputDecoration(hintText: "Enter name"),
          ),
          TextField(
            controller: t2,
            decoration: InputDecoration(hintText: "Enter contect"),
          ),
          TextField(
            controller: t3,
            decoration: InputDecoration(hintText: "Enter city"),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0))),
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.red)),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Upload image"),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              image = await _picker.pickImage(
                                  source: ImageSource.camera);
                              var path = await ExternalPath
                                      .getExternalStoragePublicDirectory(
                                          ExternalPath.DIRECTORY_DOWNLOADS) +
                                  "/crative";
                              Directory dir = Directory(path);
                              if (!await dir.exists()) {
                                await dir.create();
                              }
                              int r = Random().nextInt(1000);
                              String imagename = "img${r}.jpg";
                              File file = File("${dir.path}/${imagename}");
                              file.writeAsBytes(await image!.readAsBytes());
                              str = file.path;
                              setState(() {
                                img = true;
                              });
                              Navigator.pop(context);
                            },
                            child: Text("camera")),
                        TextButton(
                            onPressed: () async {
                              image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              var path = await ExternalPath
                                  .getExternalStoragePublicDirectory(
                                  ExternalPath.DIRECTORY_DOWNLOADS) +
                                  "/crative";
                              Directory dir = Directory(path);
                              if (!await dir.exists()) {
                                await dir.create();
                              }
                              int r = Random().nextInt(1000);
                              String imagename = "img${r}.jpg";
                              File file = File("${dir.path}/${imagename}");
                              file.writeAsBytes(await image!.readAsBytes());
                              str=file.path;
                              setState(() {
                                img = true;
                              });
                              Navigator.pop(context);
                            },
                            child: Text("Gellery"))
                      ],
                    );
                  },
                );
              },
              child: Text("Upload Image")),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                image: (img == true)
                    ? DecorationImage(
                        fit: BoxFit.fill, image: FileImage(File(image!.path)))
                    : DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("image/images.png"))),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0))),
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.red)),
              onPressed: () async {
                String name, contect, city;
                name = t1.text.toString();
                contect = t2.text.toString();
                city = t3.text.toString();

                var url = Uri.parse(
                    'https://priyeshdobariya.000webhostapp.com/online_insert.php?name=$name&contect=$contect&city=$city&image=$str');
                var response = await http.get(url);
                print(response.body);
                print(response.statusCode);
              },
              child: Text("Submit"))
        ],
      ),
    );
  }
}
