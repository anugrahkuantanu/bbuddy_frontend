import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../blocs/bloc.dart';

class RegisterView extends HookWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final verifiedPasswordController = useTextEditingController();
    final userNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final firstNameController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Enter your email here...'),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(hintText: 'Enter your password here...'),
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              obscuringCharacter: '◉',
            ),
            SizedBox(height: 20),
            TextField(
              controller: verifiedPasswordController,
              decoration: const InputDecoration(hintText: 'Enter your password again...'),
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              obscuringCharacter: '◉',
            ),
            SizedBox(height: 20),
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(hintText: 'Enter your username here...'),
              keyboardAppearance: Brightness.dark,
            ),
            SizedBox(height: 20),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(hintText: 'Enter your last name here...'),
              keyboardAppearance: Brightness.dark,
            ),
            SizedBox(height: 20),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(hintText: 'Enter your first name here...'),
              keyboardAppearance: Brightness.dark,
            ),
            SizedBox(height: 50),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                final verifiedPassword = verifiedPasswordController.text;
                final userName = userNameController.text;
                final lastName = lastNameController.text;
                final firstName = firstNameController.text;

                context.read<AppBloc>().add(
                  AppEventRegister(
                    email: email,
                    password: password,
                    verifiedPassword: verifiedPassword,
                    userName: userName,
                    lastName: lastName,
                    firstName: firstName,
                  ),
                );
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(const AppEventGoToLogin());
              },
              child: const Text('Already registered? Log in here!'),
            ),
          ],
        ),
      ),
    );
  }
}


// class RegisterView extends HookWidget {
//   const RegisterView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final emailController = useTextEditingController(
//     );

//     final passwordController = useTextEditingController(
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Register',
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter your email here...',
//               ),
//               keyboardType: TextInputType.emailAddress,
//               keyboardAppearance: Brightness.dark,
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter your password here...',
//               ),
//               keyboardAppearance: Brightness.dark,
//               obscureText: true,
//               obscuringCharacter: '◉',
//             ),
//             TextButton(
//               onPressed: () {
//                 final email = emailController.text;
//                 final password = passwordController.text;
//                 context.read<AppBloc>().add(
//                       AppEventRegister(
//                         email: email,
//                         password: password,
//                       ),
//                     );
//               },
//               child: const Text(
//                 'Register',
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 context.read<AppBloc>().add(
//                       const AppEventGoToLogin(),
//                     );
//               },
//               child: const Text(
//                 'Already registered? Log in here!',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
