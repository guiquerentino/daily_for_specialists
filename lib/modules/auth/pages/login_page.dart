import 'package:daily_for_specialists/core/constants/route_constants.dart';
import 'package:daily_for_specialists/domain/models/login_dto.dart';
import 'package:daily_for_specialists/modules/auth/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import '../../../core/ui/daily_button.dart';
import '../../../core/ui/daily_social_login.dart';
import '../../../core/ui/daily_text.dart';
import '../../../core/ui/login_app_bar.dart';
import '../../../domain/models/user_dto.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool mostrarSenha = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = Modular.get<LoginBloc>();
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              const LoginAppBar(),
              const Gap(31),
              DailyText.text("Bem-vindo(a) de volta!").header.medium.bold,
              const Gap(20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(236, 236, 236, .7),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 45.0, 16.0, 10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                validator: emailValidator,
                                decoration: const InputDecoration(
                                    hintText: "Digite seu e-mail",
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide.none),
                                    fillColor:
                                        Color.fromRGBO(196, 196, 196, 0.20),
                                    suffixIcon: Icon(Icons.email_outlined)),
                              ),
                              const Gap(15),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !mostrarSenha,
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return 'Por favor, digite uma senha válida.';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Senha",
                                    filled: true,
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide.none),
                                    fillColor: const Color.fromRGBO(
                                        196, 196, 196, 0.20),
                                    suffixIcon: IconButton(
                                        icon: mostrarSenha
                                            ? const Icon(Icons.visibility)
                                            : const Icon(Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            mostrarSenha = !mostrarSenha;
                                          });
                                        })),
                              ),
                              const Gap(15),
                              Column(
                                children: [
                                  BlocBuilder<LoginBloc, LoginState>(
                                    bloc: _loginBloc,
                                    builder: (context, state) {
                                      if (state is LoginError) {
                                        return DailyText.text(state.message)
                                            .body
                                            .medium
                                            .danger;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      Modular.to.navigate(RouteConstants.forgotPasswordPage);
                                    },
                                    child: DailyText.text("Esqueceu a senha?")
                                        .body
                                        .medium,
                                  ),
                                ],
                              ),
                              const Gap(20),
                              DailyButton(
                                text: DailyText.text("Entrar")
                                    .body
                                    .regular
                                    .large
                                    .neutral,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {

                                    LoginDto request = LoginDto(
                                        email: _emailController.text,
                                        password: _passwordController.text);

                                    UserDto? userDto = await _loginBloc.login(request);

                                    if(userDto != null){
                                      Modular.to.pushNamed(RouteConstants.homePage);
                                    }

                                  }
                                },
                              ),
                              const Gap(5),
                            ],
                          ),
                        ),
                      ),
                      if (constraints.maxHeight > 680) const DailySocialLogin(),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Modular.to.navigate(RouteConstants.createAccountPage);
                                },
                                child:
                                    DailyText.text("Membro novo? Registre-se")
                                        .header
                                        .small
                                        .regular),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
