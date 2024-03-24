import 'package:flutter/material.dart';

void main() {
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Parkez',
     theme: ThemeData(
       primaryColor: Colors.black,
       hintColor: Colors.amber,
       brightness: Brightness.dark,
     ),
     home: LoginPage(),
   );
 }
}

class LoginPage extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       // AppBar customizations would go here
     ),
     body: Center(
       child: Padding(
         padding: const EdgeInsets.all(20.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Image.asset(
               'img/download.png',
               width: 100, // Adjust the size as needed
               height: 100, // Adjust the size as needed
             ),
             Image.asset(
               'img/download2.png',
               width: 300, // Adjust the size as needed
               height: 100, // Adjust the size as needed
             ),
              Container(
               width: MediaQuery.of(context).size.width * 0.3, // Defining 70% of screen width
               child: TextField(
                 decoration: InputDecoration(
                   labelText: 'Email',
                   prefixIcon: Icon(Icons.email), // Email icon
                 ),
               ),
             ),
             SizedBox(height: 10),
             Container(
               width: MediaQuery.of(context).size.width * 0.3, // Defining 70% of screen width
               child: TextField(
                 obscureText: true,
                 decoration: InputDecoration(
                   labelText: 'Password',
                   prefixIcon: Icon(Icons.lock), // Lock icon
                 ),
               ),
             ),
             SizedBox(height: 50),
             Center(
               child: Wrap(
                 alignment: WrapAlignment.center, // Align buttons horizontally
                 spacing: 15, // Spacing between buttons
                 children: [
                   Container(
                     width: 150, // Desired button width
                     height: 50, // Desired button height
                     child: ElevatedButton(
                       onPressed: () {
                         // Perform login action
                       },
                       child: Text('Login',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                       
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.orange, // Button background color
                       ),
                     ),
                   ),
                   Container(
                     width: 150, // Desired button width
                     height: 50, // Desired button height
                     child: ElevatedButton(
                       onPressed: () {
                         // Perform register action
                       },
                       child: Text('Cadastre-se', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Color.fromARGB(255, 30, 45, 187), // Button background color
                       ),
                     ),
                   ),
                   SizedBox(height: 80),
                   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Adicione aqui a lógica para navegar para a tela de redefinição de senha
                          },
                          child: Text(
                            'Esqueceu a senha?',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )
                 ],
               ),
             ),
           ],
         ),
       ),
     ),
   );
 }
}
