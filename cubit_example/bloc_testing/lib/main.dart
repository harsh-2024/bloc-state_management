/* app genrating random name from the names list */

import 'package:flutter/material.dart';
import 'dart:math' as math show Random;
import 'package:bloc/bloc.dart';

void main() {
  runApp(MyApp());
}

const names = ["Foo", "Bar", "Baz"];

/* 
extension method on iterable to get random element from name list.                               */
extension RandomElement<T> on Iterable<T> {
  getRandomElement() => elementAt(math.Random().nextInt(length));
}

/* cubits constructor */
class NamesCubit extends Cubit<String?> {
  NamesCubit()
      : super(
            null); // here initial state is null. If we want any initial state other than null use
  // NamesCubit(String anyState) : super(String anyState);
  // initial state.
  void pickName() => emit(
      names.getRandomElement()); //emit function to return the current state.
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("HomePage"),
    ));
  }
}
