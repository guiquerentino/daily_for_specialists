import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:gap/gap.dart';

import '../../../core/ui/daily_bottom_navigation_bar.dart';
import '../../../core/ui/daily_text.dart';
import '../../../domain/models/change_account_dto.dart';
import '../../../domain/models/user_dto.dart';
import '../../../utils/environment_utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  int? _selectedGender;
  bool sucessfullChange = false;
  bool failedChange = false;
  bool showSaveButton = false;
  String? _originalName;
  String? _originalEmail;
  int? _originalGender;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      UserDto? user = EnvironmentUtils.getLoggedUser();

      user!.profilePhoto = imageBytes;
      EnvironmentUtils.loggedUser = user;

      String base64Image = base64Encode(imageBytes);
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8080/api/v1/user/profile-photo?userId=${user.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'image': base64Image,
        }),
      );
      if (response.statusCode == 200) {

        user.profilePhoto = imageBytes;

        EnvironmentUtils.loggedUser = user;

        setState(() {
          showSaveButton = false;
        });
      }
    }
  }

  Future<void> updateAccount(int userId, String fullName, String email, int gender) async {
    UserDto? user = EnvironmentUtils.getLoggedUser();

    ChangeAccountDto request = new ChangeAccountDto(userId: userId, fullName: fullName, email: email, gender: gender);

    final response = await http.put(
        Uri.parse('http://10.0.2.2:8080/api/v1/user/update-profile?userId=${user!.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson())
    );

    if(response.statusCode == 200){
      user.email = email;
      user.name = fullName;
      user.gender = gender;
      EnvironmentUtils.loggedUser = user;
      setState(() {
        sucessfullChange = true;
      });

      return;
    }

    setState(() {
      failedChange = true;
    });

  }

  String? emailValidator(String? value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (value == null || value.isEmpty || !emailRegex.hasMatch(value)) {
      return 'Por favor, digite um e-mail válido.';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      UserDto? user = EnvironmentUtils.getLoggedUser();
      if (user != null) {
        setState(() {
          _nameController = TextEditingController(text: user.name ?? '');
          _emailController = TextEditingController(text: user.email ?? '');
          _selectedGender = user.gender;

          _originalName = user.name;
          _originalEmail = user.email;
          _originalGender = user.gender;
        });
      }
    });
  }

  void _checkForChanges() {
    final currentName = _nameController?.text;
    final currentEmail = _emailController?.text;
    final currentGender = _selectedGender;

    setState(() {
      showSaveButton = currentName != _originalName ||
          currentEmail != _originalEmail ||
          currentGender != _originalGender;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserDto? user = EnvironmentUtils.getLoggedUser();

    if (_nameController == null || _emailController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      bottomNavigationBar: const DailyBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_outlined),
                    onPressed: () {
                      Modular.to.navigate('/home');
                    },
                  ),
                  DailyText.text("Meu Perfil").header.medium.bold,
                  Container(),
                  Container(),
                ],
              ),
              const Gap(10),
              Stack(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: user?.profilePhoto == null
                            ? const Color.fromRGBO(158, 181, 103, 1)
                            : Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: user?.profilePhoto != null
                          ? ClipOval(
                        child: Image.memory(
                          user!.profilePhoto!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      )
                          : const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 75,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 25,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nome",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const Gap(5),
                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: TextFormField(
                      controller: _nameController,
                      onChanged: (_) => _checkForChanges(),
                      decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromRGBO(196, 196, 196, 0.20),
                      ),
                    ),
                  ),
                  const Gap(20),
                  const Text("E-mail",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const Gap(5),
                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: TextFormField(
                      validator: emailValidator,
                      controller: _emailController,
                      onChanged: (_) {
                        _checkForChanges();
                        _formKey.currentState?.validate();
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromRGBO(196, 196, 196, 0.20),
                      ),
                    ),
                  ),
                  const Gap(20),
                  const Text("Gênero",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const Gap(5),
                  SizedBox(
                    width: double.maxFinite,
                    height: 70,
                    child: DropdownButtonFormField<int>(
                      value: _selectedGender,
                      items: const [
                        DropdownMenuItem<int>(
                          value: 0,
                          child: Text("Feminino"),
                        ),
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text("Masculino"),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text("Prefiro não informar"),
                        ),
                      ],
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                          _checkForChanges();
                        });
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color.fromRGBO(196, 196, 196, 0.20),
                      ),
                    ),
                  ),
                  const Gap(10),
                  if(failedChange)
                  const Center(child: Text("Erro ao salvar informações!", style: TextStyle(color: Colors.red, fontSize: 18))),
                  if(sucessfullChange)
                    const Center(child: Text("Informações atualizadas com sucesso!", style: TextStyle(fontSize: 18))),
                  const Gap(30),
                  if (showSaveButton)
                    Center(
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            UserDto? user = EnvironmentUtils.getLoggedUser();

                            user!.name = _nameController!.text;
                            user.email = _emailController!.text;
                            user.gender = _selectedGender;
                            EnvironmentUtils.loggedUser = user;

                            updateAccount(user.id, _nameController!.text, _emailController!.text, _selectedGender!);
                          }
                        },
                        style: const ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(Size(200, 40)),
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromRGBO(158, 181, 103, 1)),
                        ),
                        child: const Text(
                          "Salvar",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
