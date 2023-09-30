import 'package:flutter/material.dart';
import '../../../../../core/core.dart';
import '../blocs/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../app.dart';
import '../widgets/widget.dart';
import '../../services/service.dart';
import '../screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: actionsMenuLogin(context),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: BlocProvider(
              create: (context) => LoginBloc(context),
              // create: (context) => LoginFormBloc(),
              child: const LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          LoadingUI();
        } else if (state is LoginSuccess) {
          UserProvider userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.checkLoginStatus();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        } else if (state is LoginFailure) {
          if (state.error.contains(
              'The username you entered isn\'t connected to an account')) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state.error.contains('Incorrect password')) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ));
          }
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              LoginLogo(),
              const SizedBox(height: 20.0),
              Container(
                child: TextFormField(
                  controller: usernameController,
                  // decoration: ThemeHelper()
                  //     .textInputDecoration('User Name', 'Enter your user name'),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter your username";
                    }
                    if (state is UsernameInvalid) {
                      return 'The username you entered isn\'t connected to an account';
                    }
                    return null;
                  },
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),
              const SizedBox(height: 30.0),
              Container(
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  // decoration: ThemeHelper()
                  //     .textInputDecoration('Password', 'Enter your password'),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter your password";
                    }
                    if (state is PasswordInvalid) {
                      return 'Incorrect password';
                    }
                    return null;
                  },
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),
              const SizedBox(height: 15.0),
              Button(
                label: 'Sign In',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginBloc>().add(LoginSubmitted(
                        usernameController.text, passwordController.text));
                  }
                },
              ),
              const SizedBox(height: 15.0),
              Button(
                label: 'Sign Up',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationPage()));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
