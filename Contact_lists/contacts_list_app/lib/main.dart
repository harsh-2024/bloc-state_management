import "package:flutter/material.dart";
import 'dart:ui';
import 'package:uuid/uuid.dart';

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
  final String id;
  final String name;
  Contact({required this.name}) : id = Uuid().v4();
}

// making singleton ContactBook class
class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;
  final List<Contact> _contacts = [];
  int get length => value.length;

  void add(Contact contact) {
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }

  void remove(Contact contact) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      notifyListeners();
    }
  }

  Contact? contact({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
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
      body: ValueListenableBuilder(
          valueListenable: ContactBook(),
          builder: (context, value, child) {
            final contacts = value as List<Contact>;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contactBook.contact(atIndex: index);
                return Dismissible(
                  onDismissed: (direction) => {
                    contacts.remove(contact),
                  },
                  key: ValueKey(contact?.id),
                  child: Material(
                    color: Colors.white,
                    elevation: 7.0,
                    child: ListTile(
                      title: Text(contact!.name),
                    ),
                  ),
                );
              },
            );
          }),
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
