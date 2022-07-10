import "package:flutter/material.dart";
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "contact-new": (context) => NewContactAdd(),
      },
      home: HomePage(),
    );
  }
}

class Contact {
  final String name;
  Contact({required this.name});
}

// making singleton ContactBook class
class ContactBook {
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;
  final List<Contact> _contacts = [
    Contact(name: "Harsh"),
    Contact(name: "Ansh")
  ];
  int get length => _contacts.length;
  void add(Contact contact) => _contacts.add(contact);
  void remove(Contact contact) => _contacts.remove(contact);
  Contact? contact({required int atIndex}) =>
      _contacts.length > atIndex ? _contacts[atIndex] : null;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Contacts"),
      ),
      body: ListView.builder(
        itemCount: contactBook.length,
        itemBuilder: (context, index) {
          final contact = contactBook.contact(atIndex: index);
          return ListTile(
            title: Text(contact!.name),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushNamed(context, "contact-new"),
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

late TextEditingController mycontroller;

class NewContactAdd extends StatefulWidget {
  const NewContactAdd({Key? key}) : super(key: key);

  @override
  State<NewContactAdd> createState() => _NewContactAddState();
}

class _NewContactAddState extends State<NewContactAdd> {
  @override
  void initState() {
    // TODO: implement initState
    mycontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    mycontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ContactBook contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: Text("New Contact"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: mycontroller,
            decoration: InputDecoration(
              hintText: "Add your contact here",
            ),
          ),
          TextButton(
              onPressed: () {
                contactBook.add(Contact(name: mycontroller.text));
                Navigator.pop(context);
              },
              child: Text("Add"))
        ],
      ),
    );
  }
}
