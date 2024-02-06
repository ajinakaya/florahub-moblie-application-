import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:florhub/models/plantmodel.dart';
import 'package:florhub/services/file_upload.dart';
import 'package:florhub/viewmodels/categoryviewmodel.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController _NameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _DescriptionController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _temperatureController = TextEditingController();
  TextEditingController _potController = TextEditingController();
  String productCategory = "";

  void saveProduct() async{
    _ui.loadState(true);
    try{
      final plantModel data= plantModel(
        imagePath: imagePath,
        imageUrl: imageUrl,
        categoryId: selectedplantCategory,
        description: _DescriptionController.text,
        title: _NameController.text,
        price: num.parse(_priceController.text.toString()),
        userId: _authViewModel.loggedInUser!.userId,
        height:_heightController.text,
        temperature:_temperatureController.text,
        pot:_potController.text,

      );
      await _authViewModel.addMyProduct(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success")));
      Navigator.of(context).pop();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
    }
    _ui.loadState(false);
  }
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  late CategoryViewModel _categoryViewModel;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
      getInit();
    });
    super.initState();
  }

  getInit() async {
    _ui.loadState(true);
    try{
      await _categoryViewModel.getCategories();
    }catch(e){
      print(e);
    }
    _ui.loadState(false);
  }
  String? selectedplantCategory;

  // image uploader
  String? imageUrl;
  String? imagePath;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    var selected = await _picker.pickImage(source: source, imageQuality: 100);
    if (selected != null) {
      setState(() {
        imageUrl = null;
        imagePath=null;

      });

      _ui.loadState(true);
      try{
        ImagePath? image = await FileUpload().uploadImage(selectedPath: selected.path);
        if(image!=null){
          setState(() {
            imageUrl = image.imageUrl;

          });
        }
      }catch(e){}

      _ui.loadState(false);
    }
  }

  void deleteImage() async {

    _ui.loadState(true);
    try{

      await FileUpload().deleteImage(deletePath: imagePath.toString()).then((value){
        setState(() {
          imagePath=null;
          imageUrl=null;
        });
      });
    }catch(e){}

    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Post",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Consumer<CategoryViewModel>(
          builder: (context, categoryVM, child) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 10,),

                      TextFormField(
                        controller: _NameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          border: InputBorder.none,
                          label: Text("Title"),
                          hintText: 'Title',
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: _DescriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          border: InputBorder.none,
                          label: Text("Description"),
                          hintText: 'Description',
                        ),
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          border: InputBorder.none,
                          label: Text("Price"),
                          hintText: 'Price',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          border: InputBorder.none,
                          label: Text("height"),
                          hintText: 'height',
                        ),
                      ),
                      SizedBox(height: 10,),

                      TextFormField(
                        controller: _temperatureController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          border: InputBorder.none,
                          label: Text("temperature"),
                          hintText: 'temperature',
                        ),
                      ),
                      SizedBox(height: 10,),

                      TextFormField(
                        controller: _potController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          border: InputBorder.none,
                          label: Text("pot"),
                          hintText: 'pot',
                        ),
                      ),
                      SizedBox(height: 10,),

                      DropdownButtonFormField(
                        isExpanded: true,
                        value: selectedplantCategory,

                        decoration:  InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          border: InputBorder.none,
                          hintText: 'Category',
                          filled: true,
                        ),
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        items: categoryVM.categoryNames.map((pt) {
                          return DropdownMenuItem(
                            value: _categoryViewModel.getCategoryIdByIndex(categoryVM.categoryNames.indexOf(pt)),
                            child: Text(
                              pt,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            selectedplantCategory = newVal.toString();
                          });
                        },
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Add Image"),
                            SizedBox(width: 10,),
                            IconButton(onPressed: (){
                              _pickImage(ImageSource.camera);
                            },
                                icon: Icon(Icons.camera)),
                            SizedBox(width: 5,),
                            IconButton(onPressed: (){
                              _pickImage(ImageSource.gallery);
                            },
                                icon: Icon(Icons.photo))
                          ],
                        ),
                      ),
                      imageUrl !=null ?
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Image.network(imageUrl!, height: 50, width: 50,),
                          Text(imagePath.toString()),
                          IconButton(onPressed: (){
                            deleteImage();
                          },
                              icon: Icon(Icons.delete, color: Colors.red,)),
                        ],
                      )
                          : Container(),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            key: Key('addProduct'),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Colors.blue)
                                  )
                              ),
                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10)),
                            ),
                            onPressed: (){
                              saveProduct();
                            }, child: Text("Save", style: TextStyle(
                            fontSize: 20
                        ),)),
                      ),


                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

}