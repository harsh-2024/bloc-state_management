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
  final int phno;
  final String id;
  final String name;
  Contact({required this.name, required this.phno}) : id = Uuid().v4();
}

// making singleton ContactBook class
class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;
  // final List<Contact> _contactsNameName = [];
  int get length => value.length;

  void add(Contact contact) {
    final contactsName = value;
    contactsName.add(contact);
    notifyListeners();
  }

  void remove(Contact contact) {
    final contactsName = value;
    if (contactsName.contains(contact)) {
      contactsName.remove(contact);
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
        title: Text("Your Contact Book"),
      ),
      body: ValueListenableBuilder(
          valueListenable: ContactBook(),
          builder: (context, value, child) {
            final contactsName = value as List<Contact>;
            return ListView.builder(
              itemCount: contactsName.length,
              itemBuilder: (context, index) {
                final contact = contactBook.contact(atIndex: index);
                return Dismissible(
                  onDismissed: (direction) => {
                    contactsName.remove(contact),
                  },
                  key: ValueKey(contact?.id),
                  child: Material(
                    color: Colors.white,
                    elevation: 7.0,
                    child: ListTile(
                      title: Text(contact!.name),
                      subtitle: Text(contact.phno.toString()),
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

late TextEditingController mycontrollerName;
late TextEditingController mycontrollerNumber;

class NewContactAdd extends StatefulWidget {
  const NewContactAdd({Key? key}) : super(key: key);

  @override
  State<NewContactAdd> createState() => _NewContactAddState();
}

class _NewContactAddState extends State<NewContactAdd> {
  @override
  void initState() {
    // TODO: implement initState
    mycontrollerName = TextEditingController();
    mycontrollerNumber = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    mycontrollerName.dispose();
    mycontrollerNumber.dispose();
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
            controller: mycontrollerName,
            decoration: InputDecoration(
              hintText: "Contact Name",
            ),
          ),
          TextFormField(
            controller: mycontrollerNumber,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Contact Number",
            ),
          ),
          TextButton(
              onPressed: () {
                contactBook.add(Contact(
                    name: mycontrollerName.text,
                    phno: int.parse(mycontrollerNumber.text)));
                Navigator.pop(context);
              },
              child: Text("Add"))
        ],
      ),
    );
  }
}
