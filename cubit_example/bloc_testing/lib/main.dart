import 'package:flutter/material.dart';
import 'dart:math' as math show Random;
import 'package:bloc/bloc.dart';

void main() {
  runApp(MyApp());
}

const names = ["Foo", "Bar", "Baz", "Harsh", "Ansh"];

extension RandomElement<T> on Iterable<T> {
  getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement());
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
    cubit.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HomePage"),
        ),
        body: StreamBuilder<String?>(
            stream: cubit.stream,
            builder: (context, snapshot) {
              final button = TextButton(
                  onPressed: () => cubit.pickRandomName(),
                  child: Text("Pick a random name"));
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return button;

                case ConnectionState.active:
                  return Column(
                    children: [Text(snapshot.data ?? " "), button],
                  );

                case ConnectionState.done:
                  return SizedBox();

                case ConnectionState.waiting:
                  return button;
              }
            }));
  }
}
