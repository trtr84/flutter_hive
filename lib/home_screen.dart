import 'package:flutter/material.dart';
import 'package:flutter_hive/boxes.dart';
import 'package:flutter_hive/person.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textAgeController = TextEditingController();
  final _textNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Создаем ключ формы для валидации

  void putData() {
    if (_formKey.currentState!.validate()) {
      // Проверка валидности формы
      personBox.put(
        'key_${_textNameController.text}',
        Person(
          name: _textNameController.text,
          age: int.parse(_textAgeController.text),
        ),
      );
      _textNameController.clear(); // Очищаем поля после добавления данных
      _textAgeController.clear();
    }
  }

  void deleteData() {
    personBox.deleteAll(personBox.keys);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Column(
        children: [
          Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Form(
              key: _formKey, // Привязываем форму к ключу для валидации
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 24),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        labelStyle: TextStyle(fontSize: 24),
                      ),
                      controller: _textNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name'; // Сообщение об ошибке, если поле пустое
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 24),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Age',
                        labelStyle: TextStyle(fontSize: 24),
                      ),
                      controller: _textAgeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an age'; // Сообщение об ошибке для пустого значения
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number'; // Сообщение, если введено не число
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            putData();
                          });
                        },
                        child: const Text(
                          'Add person',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            deleteData();
                          });
                        },
                        child: const Text(
                          'Delete all',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: Card(
              color: Colors.white,
              child: ListView.builder(
                itemCount: personBox.length,
                itemBuilder: (context, index) {
                  Person person = personBox.getAt(index);
                  if (personBox.isEmpty) {
                    return CircularProgressIndicator();
                  } else {
                    return ListTile(
                      leading: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.minimize_outlined),
                      ),
                      title: Text(person.name),
                      subtitle: Text(
                        person.age.toString(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
