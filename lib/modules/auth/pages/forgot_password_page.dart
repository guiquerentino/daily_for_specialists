import 'package:daily_for_specialists/core/constants/route_constants.dart';
import 'package:daily_for_specialists/modules/auth/bloc/login_bloc.dart';
import 'package:daily_for_specialists/modules/auth/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import '../../../core/ui/daily_button.dart';
import '../../../core/ui/daily_text.dart';
import '../../../core/ui/login_app_bar.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String ROUTE_NAME = '/forgot-password';

  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool erroTrocarSenha = false;
  bool mostrarSenha = false;
  bool mostrarSenhaConfirm = false;
  late final LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = Modular.get<LoginBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double? fontSize = constraints.maxWidth < 700 ? 12 : 16;
          return SingleChildScrollView(
            child: Column(
              children: [
                const LoginAppBar(),
                const Gap(15),
                const Text(
                  "Redefinição de Senha",
                  style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Por favor, insira seu email para que possamos redefinir sua senha. Será necessário uma etapa de confirmação.",
                    style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(236, 236, 236, .7),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 25.0, 16.0, 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null ||
                                  value == '' ||
                                  !value.contains('@')) {
                                return 'Por favor, digite um e-mail válido.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: "Digite seu e-mail",
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide.none),
                                fillColor: Color.fromRGBO(196, 196, 196, 0.20),
                                suffixIcon: Icon(Icons.email_outlined)),
                          ),
                          const Gap(10),
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
                                hintText: "Senha nova",
                                filled: true,
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide.none),
                                fillColor:
                                    const Color.fromRGBO(196, 196, 196, 0.20),
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
                          const Gap(10),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: !mostrarSenhaConfirm,
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Por favor, digite uma senha válida.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Confirme sua senha nova",
                                filled: true,
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide.none),
                                fillColor:
                                    const Color.fromRGBO(196, 196, 196, 0.20),
                                suffixIcon: IconButton(
                                    icon: mostrarSenhaConfirm
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        mostrarSenhaConfirm =
                                            !mostrarSenhaConfirm;
                                      });
                                    })),
                          ),
                          BlocBuilder(
                              bloc: _loginBloc,
                              builder: (BuildContext context, state) {
                                if (state is PasswordRecoverError) {
                                  return const Text(
                                      "Erro ao alterar senha, verifique as informações.",
                                      style: TextStyle(color: Colors.red));
                                } else {
                                  return Container();
                                }
                              }),
                          const Gap(30),
                          DailyButton(
                              text: DailyText.text("Redefinir")
                                  .neutral
                                  .body
                                  .large,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {

                                  if (await _loginBloc.recoverPassword(
                                      _emailController.text,
                                      _newPasswordController.text)) {
                                    Modular.to.pushNamed(RouteConstants.passwordChangedPage);
                                  }
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Container(
        width: 50.0,
        height: 50.0,
        child: FloatingActionButton(
          onPressed: () {
            Modular.to.navigate(RouteConstants.loginPage);
          },
          backgroundColor: const Color.fromRGBO(53, 56, 63, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.arrow_back_outlined,
              color: Colors.white, size: 20.0),
        ),
      ),
    );
  }
}
