import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormInput {
  final String name;
  final String email;
  final String message;

  FormInput({required this.name, required this.email, required this.message});
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ContactAppBar(),
              Expanded(
                child: Center(
                  child: ContactForm(),
                ),
              ),
              Center(
                child: Text(
                  'github.com/omntnsv',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({
    super.key,
  });

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final Color iconBackground = const Color.fromARGB(255, 255, 217, 167);
  final Color formColor = const Color.fromARGB(255, 145, 111, 140);
  final GlobalKey<FormState> _contactKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool isLoading = false;
  String sendResult = '';

  Future<void> sendJson(formInput) async {
    //Sending via HTTP
    setState(() {
      isLoading = true;
      sendResult = '';
    });

    String jsonData = json.encode({
      'name': formInput.name,
      'email': formInput.email,
      'message': formInput.message,
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://jsonplaceholder.typicode.com/posts'), // https://api.byteplex.info/api/test/contact/
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );
      if (response.statusCode == 201) {
        sendResult = 'Thank you for contacting us!';
      } else {
        sendResult =
            '${response.statusCode} Failed to send your message. Please try again later.';
      }
    } catch (e) {
      print('An error occurred: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _contactKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                Padding(
                  //* Name Field
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: CircleAvatar(
                          backgroundColor: iconBackground,
                          child: const Icon(
                            Icons.account_circle,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          cursorColor: formColor,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'John Doe',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: formColor),
                            ),
                          ),
                          validator: (String? value) {
                            final pattern = RegExp(r"^[a-zA-Z' ]+$");
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            final nameParts = value.split(' ');
                            if (nameParts.length < 2) {
                              return 'Please enter both name and surname';
                            }
                            final name = nameParts[0];
                            final surname = nameParts[1];
                            if (name.isEmpty || surname.isEmpty) {
                              return 'Please enter both name and surname';
                            }
                            if (!pattern.hasMatch(name) ||
                                !pattern.hasMatch(surname)) {
                              return 'Can\'t contain special characters or numbers';
                            }
                            return null; // Return null to indicate validation success
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  //* Email Field
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: CircleAvatar(
                          backgroundColor: iconBackground,
                          child: const Icon(
                            Icons.mail,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          cursorColor: formColor,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'example@abc.com',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: formColor),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            const emailRegex =
                                r'^[\w-]+(\.[\w-]+)*@([a-z0-9-]+\.)+[a-z]{2,}$';
                            if (!RegExp(emailRegex, caseSensitive: false)
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  //* Message Field
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: CircleAvatar(
                          backgroundColor: iconBackground,
                          child: const Icon(
                            Icons.message_rounded,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          cursorColor: formColor,
                          controller: _messageController,
                          maxLength: 150,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Your message',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: formColor),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter yout message';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                IgnorePointer(
                  //* Send button
                  ignoring: isLoading,
                  child: Opacity(
                    opacity: isLoading ? 0.5 : 1,
                    child: InkWell(
                      onTap: () {
                        if (_contactKey.currentState!.validate()) {
                          sendJson(FormInput(
                              name: _nameController.text,
                              email: _emailController.text,
                              message: _messageController.text));
                        }
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color.fromARGB(255, 145, 111, 140),
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.orange),
                                  ),
                                )
                              : const Text(
                                  'Send',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Center(child: Text(sendResult)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ContactAppBar extends StatelessWidget {
  const ContactAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Contact Us',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 48,
            width: 48,
          ),
        )
      ],
    );
  }
}
