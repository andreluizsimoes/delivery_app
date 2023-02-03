import 'package:delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:delivery_app/app/core/ui/styles/colors_app.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:delivery_app/app/pages/auth/register/register_controller.dart';
import 'package:delivery_app/app/pages/auth/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController> {
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> passwordVN = ValueNotifier(true);
  ValueNotifier<bool> confirmPasswordVN = ValueNotifier(true);

  @override
  void dispose() {
    super.dispose();
    _nameEC.dispose();
    _passwordEC.dispose();
    _emailEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          error: () {
            hideLoader();
            showError('Erro ao registrar o usuário');
          },
          success: () {
            hideLoader();
            showSuccess('Cadastro realizado com sucesso!');
            Navigator.of(context).pop();
          },
        );
      },
      child: Scaffold(
        appBar: DeliveryAppbar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cadastro', style: context.textStyles.textTitle),
                  Text(
                    'Preencha os campos abaixo para criar o seu cadastro.',
                    style: context.textStyles.textMedium.copyWith(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _nameEC,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: Validatorless.multiple([
                      Validatorless.required('Nome é obrigatório!'),
                      Validatorless.min(1, 'Digite um nome válido!')
                    ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _emailEC,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: Validatorless.multiple([
                      Validatorless.required('E-mail é obrigatório!'),
                      Validatorless.email('Digite um e-mail válido!')
                    ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ValueListenableBuilder(
                    valueListenable: passwordVN,
                    builder: (_, obscureTextValue, __) {
                      return TextFormField(
                        controller: _passwordEC,
                        obscureText: obscureTextValue,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          suffixIcon: IconButton(
                            onPressed: () {
                              passwordVN.value = !passwordVN.value;
                            },
                            icon: Icon(
                              obscureTextValue
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                          ),
                        ),
                        validator: Validatorless.multiple([
                          Validatorless.required('Senha é obrigatória!'),
                          Validatorless.min(
                              6, 'Senha deve conter pelo menos 6 caracteres')
                        ]),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ValueListenableBuilder(
                    valueListenable: confirmPasswordVN,
                    builder: (_, obscureTextValue, __) {
                      return TextFormField(
                        obscureText: obscureTextValue,
                        decoration: InputDecoration(
                          labelText: 'Confirma Senha',
                          suffixIcon: IconButton(
                            onPressed: () {
                              confirmPasswordVN.value =
                                  !confirmPasswordVN.value;
                            },
                            icon: Icon(
                              obscureTextValue
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                          ),
                        ),
                        validator: Validatorless.multiple([
                          Validatorless.required(
                              'Confirma Senha é obrigatória!'),
                          Validatorless.compare(
                              _passwordEC, 'Senha diferente de Confirma Senha!')
                        ]),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: DeliveryButton(
                      width: double.infinity,
                      label: 'CADASTRAR',
                      onPressed: () {
                        final valid =
                            _formKey.currentState?.validate() ?? false;

                        if (valid) {
                          controller.register(
                            _nameEC.text,
                            _emailEC.text,
                            _passwordEC.text,
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
