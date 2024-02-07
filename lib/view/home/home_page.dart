import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:testapp_1/bloc/file_bloc/file_bloc.dart';
import 'package:testapp_1/model/uploaded_file.dart';
import 'package:testapp_1/view/home/pdf_reader.dart';

import '../../helpers/factory.dart';
import '../../helpers/spacer.dart';
import '../authentication/login_page.dart';

class HomePageScreen extends StatefulWidget {
  static const String route = '/home-page-screen';
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final FileUploadBloc fileUploadBloc = FileUploadBloc();
  final GetFilesBloc getFilesBloc = GetFilesBloc();
  String? _dropdownValue;
  String? _subCategoryValue;
  String? filePath;
  var dropdownItems = ["Identity", "Residence", "Finance"];
  var subCategoryItems = [
    "Bill",
    "Aadhar",
    "Pancard",
    "Passport",
    "Rent Agreement"
  ];
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget get _getCurrentScreen {
    return SingleChildScrollView(
      child: Column(
        children: [
          vSpacing(10),
          _getUploadDocuments,
          vSpacing(2),
          _getUploadedFiles
        ],
      ),
    );
  }

  Widget get _getUploadDocuments{
    return Container(
      margin: const EdgeInsets.all(10).copyWith(top: 0),
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      // height: MediaQuery.of(context).size.height * 0.6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xffa0a0a0).withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            // width: MediaQuery.of(context).size.width*0.33,
            child: BlocListener(
              bloc: fileUploadBloc,
              listener: (context, state) {
                if (state is FileUploading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const AlertDialog(
                      content: SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  );
                } else if (state is FileUploadFailed) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text(state.errorMessage),
                    ),
                  );
                } else if (state is FileUploaded) {
                  Navigator.of(context).pop();
                  _dropdownValue = null;
                  _subCategoryValue = null;
                  filePath = null;
                  descriptionController.clear();
                  setState(() {});
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text("Successfully uploaded!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Ok"),
                        )
                      ],
                    ),
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upload Documents',
                    style:
                    ProjectProperty.fontFactory.robotoStyle.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontSize: 16,
                      height: 21 / 18,
                    ),
                  ),
                  vSpacing(30),
                  Row(
                    children: [
                      Text(
                        'Select Category',
                        style: ProjectProperty.fontFactory.robotoStyle
                            .copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 12,
                          height: 21 / 18,
                        ),
                      ),
                      hSpacing(10),
                      Container(
                        padding:
                        const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5)),
                        height: 30,
                        child: DropdownButton(
                          hint: const Text("Category"),
                          underline: Container(),
                          style: ProjectProperty.fontFactory.robotoStyle
                              .copyWith(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 12),
                          items: dropdownItems
                              .map((String item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                              .toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _dropdownValue = value!;
                            });
                          },
                          value: _dropdownValue,
                        ),
                      )
                    ],
                  ),
                  vSpacing(20),
                  Row(
                    children: [
                      Text(
                        'Select Sub Category',
                        style: ProjectProperty.fontFactory.robotoStyle
                            .copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 12,
                          height: 21 / 18,
                        ),
                      ),
                      hSpacing(10),
                      Container(
                        padding:
                        const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5)),
                        height: 30,
                        child: DropdownButton(
                          underline: Container(),
                          hint: const Text("Sub Category"),
                          style: ProjectProperty.fontFactory.robotoStyle
                              .copyWith(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 12),
                          items: subCategoryItems
                              .map((String item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                              .toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _subCategoryValue = value!;
                            });
                          },
                          value: _subCategoryValue,
                        ),
                      )
                    ],
                  ),
                  vSpacing(20),
                  Row(
                    children: [
                      Text(
                        'Description',
                        style: ProjectProperty.fontFactory.robotoStyle
                            .copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 12,
                          height: 21 / 18,
                        ),
                      ),
                      hSpacing(10),
                      SizedBox(
                        // height: 50,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextFormField(
                          cursorColor: Theme.of(context).primaryColor,
                          maxLines: 3,
                          controller: descriptionController,
                          decoration: InputDecoration(
                            prefixIconConstraints: const BoxConstraints(
                                minHeight: 0, minWidth: 30, maxHeight: 5),
                            isDense: true,
                            alignLabelWithHint: true,
                            // hintText: hintText,
                            labelStyle:
                            ProjectProperty.fontFactory.robotoStyle,
                            floatingLabelAlignment:
                            FloatingLabelAlignment.start,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  vSpacing(30),
                  Center(
                    child: Container(
                      height: 150,
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                            color:
                            const Color(0xffa0a0a0).withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.upload_file_outlined,
                              size: 60,
                            ),
                            vSpacing(10),
                            Text(
                              filePath != null ? filePath!.split("/").last :'Select a PDF file to upload',
                              style: ProjectProperty
                                  .fontFactory.robotoStyle
                                  .copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontSize: 14,
                                height: 21 / 18,
                              ),
                            )
                          ],
                        ),
                        onPressed: () async {
                          var file = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ["pdf"],
                            allowMultiple: false,
                          );
                          if (file != null &&
                              file.files.isNotEmpty &&
                              file.files.first.extension != "pdf") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Choose a correct file to upload")));
                          } else if (file != null &&
                              file.files.isNotEmpty) {
                            if (file.files.first.size >= 2000000) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "File should be less 2MB")));
                            } else {
                              filePath = file.files.first.path;
                              setState(() {

                              });
                            }
                          }
                          print(file);
                        },
                      ),
                    ),
                  ),
                  vSpacing(20),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          minimumSize:
                          MaterialStateProperty.all(Size(200, 40))),
                      onPressed: () {
                        if (_dropdownValue == null ||
                            _subCategoryValue == null ||
                            filePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Fill all values"),
                            ),
                          );
                        } else {
                          UploadedFilesModel file = UploadedFilesModel(
                            category: _dropdownValue!,
                            comments: descriptionController.text,
                            subCategory: _subCategoryValue!,
                            url: filePath!,
                          );
                          fileUploadBloc.add(FileUploadAdded(file));
                        }
                        // FirebaseStorage.instance.ref().child(path).
                      },
                      child: Text(
                        "Upload",
                        style: ProjectProperty.fontFactory.robotoStyle
                            .copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          vSpacing(10),
        ],
      ),
    );
  }

  Widget get _getUploadedFiles{
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.all(10),
          // width: MediaQuery.of(context).size.width*0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Your Uploaded Files',
                    style:
                    ProjectProperty.fontFactory.robotoStyle.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontSize: 16,
                      height: 21 / 18,
                    ),
                  ),
                ],
              ),
              vSpacing(30),
              StreamBuilder<List<UploadedFilesModel>>(
                  stream: getFilesBloc.getFiles(),
                  builder: (context, snapshot) {
                    return Table(
                      border: const TableBorder(
                        horizontalInside: BorderSide(),
                      ),
                      children: [
                        TableRow(
                          children: [
                            "Category",
                            "Sub-Category",
                            "Comments"
                          ]
                              .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              e,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                              .toList(),
                        ),
                        if (snapshot.hasData)
                          ...snapshot.data!
                              .map(
                                (e) => TableRow(children: [e.category,e.subCategory,e.comments].map((row) {

                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PdfReader(url: e.url),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(row),
                                ),
                              );
                            }).toList(),

                            ),
                          )
                              .toList(),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ProjectProperty.colorFactory.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 81),
        child: HomePageAppbar(scaffoldKey: scaffoldKey, appTitle: "Dashboard"),
      ),
      drawer: const ProjectDrawer(),
      body: SafeArea(
        child: _getCurrentScreen,
      ),
    );
  }
}

class HomePageAppbar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String appTitle;

  const HomePageAppbar(
      {Key? key, required this.scaffoldKey, required this.appTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              scaffoldKey.currentState?.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                "assets/images/menu.svg",
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.38),
            child: Text(
              appTitle,
              style: ProjectProperty.fontFactory.robotoStyle.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black,
                fontSize: 18,
                height: 21 / 18,
              ),
            ),
          ),
          // const Spacer(
          //   flex: 3,
          // ),
          // Spacer(flex: 5),
        ],
      ),
    );
  }
}

class DrawerItems {
  final Function(BuildContext context) onTap;
  final String title;
  final String iconURL;

  DrawerItems({
    required this.onTap,
    required this.title,
    required this.iconURL,
  });
}

class ProjectDrawer extends StatefulWidget {
  const ProjectDrawer({Key? key}) : super(key: key);

  @override
  State<ProjectDrawer> createState() => _ProjectDrawerState();
}

class _ProjectDrawerState extends State<ProjectDrawer> {
  List<DrawerItems> get items => [
        DrawerItems(
          onTap: (context) {
            FirebaseAuth.instance.signOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(LoginPage.route, (route) => false);
          },
          title: "Logout",
          iconURL: "save_menu.svg",
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ProjectProperty.colorFactory.drawerColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSpacing(100),
            Divider(
              height: 1,
              color: Colors.white.withOpacity(0.27),
              endIndent: 80,
            ),
            ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    items[index].onTap(context);
                  },
                  leading:
                      SvgPicture.asset("assets/images/${items[index].iconURL}"),
                  title: Text(
                    items[index].title,
                    style: ProjectProperty.fontFactory.robotoStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                );
              },
              itemCount: items.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return vSpacing(0);
              },
            ),
            Divider(
              height: 1,
              color: Colors.white.withOpacity(0.27),
              endIndent: 80,
            ),
          ],
        ),
      ),
    );
  }
}
