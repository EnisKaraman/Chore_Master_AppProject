import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'CHORES MASTER',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 200,
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'email@domain.com',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'şifrenizi giriniz',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'giriş yap',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ));
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'üye ol',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 200,
              ),
              SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Adınızı giriniz',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'email@domain.com',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'şifrenizi giriniz',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Üye olma işlemini burada gerçekleştirin
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'üye ol',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Task> tasks = [];
  List<Task> completedTasks = [];
  Map<String, int> userTaskCounts = {};

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _completeTask(Task task) {
    setState(() {
      tasks.remove(task);
      completedTasks.add(task);
      userTaskCounts.update(task.owner, (count) => count + 1, ifAbsent: () => 1);
    });
  }

  void _reactivateTask(Task task) {
    setState(() {
      completedTasks.remove(task);
      tasks.add(task);
      userTaskCounts.update(task.owner, (count) => count - 1);
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      completedTasks.remove(task);
      userTaskCounts.update(task.owner, (count) => count - 1);
    });
  }

  void _addTask(Task task) {
    setState(() {
      task.isNew = true;
      tasks.add(task);
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });
  }

  void _updateTask(Task updatedTask) {
    setState(() {
      int index = tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      }
    });
  }

  void _removeTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? HomePage(
        tasks: tasks,
        onTaskUpdated: () {
          setState(() {});
        },
        onCompleteTask: _completeTask,
      )
          : _selectedIndex == 1
          ? TaskListPage(
        tasks: tasks,
        onTaskAdded: (newTask) {
          _addTask(newTask);
        },
        onTaskUpdated: () {
          setState(() {});
        },
        onCompleteTask: _completeTask,
        onUpdateTask: _updateTask,
        onRemoveTask: _removeTask,
      )
          : _selectedIndex == 2
          ? CompletedTasksPage(
        completedTasks: completedTasks,
        onTaskReactivated: _reactivateTask,
        onDeleteTask: _deleteTask,
      )
          : ProfilePage(userTaskCounts: userTaskCounts),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Görevler',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Tamamlanan Görevler',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            backgroundColor: Colors.black,
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback onTaskUpdated;
  final ValueChanged<Task> onCompleteTask;

  HomePage(
      {required this.tasks,
        required this.onTaskUpdated,
        required this.onCompleteTask});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 200,
            ),
            SizedBox(height: 5),
            Text(
              'Hoş Geldiniz',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'Yaklaşan Görevler',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: tasks.isEmpty
                          ? Center(
                        child: Text(
                          'Mevcut görev yok',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )
                          : ListView.builder(
                        itemCount:
                        tasks.length > 3 ? 3 : tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Column(
                            children: [
                              TaskItemWidget(
                                task: task,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskDetailPage(
                                            task: task,
                                            onCompleteTask: () {
                                              onCompleteTask(task);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                    ),
                                  ).then((_) => onTaskUpdated());
                                },
                              ),
                              SizedBox(height: 10), // Add space between tasks
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListPage extends StatelessWidget {
  final List<Task> tasks;
  final ValueChanged<Task> onTaskAdded;
  final VoidCallback onTaskUpdated;
  final ValueChanged<Task> onCompleteTask;
  final ValueChanged<Task> onUpdateTask;
  final ValueChanged<Task> onRemoveTask;

  TaskListPage(
      {required this.tasks,
        required this.onTaskAdded,
        required this.onTaskUpdated,
        required this.onCompleteTask,
        required this.onUpdateTask,
        required this.onRemoveTask});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Görev Listesi'),
      ),
      body: tasks.isEmpty
          ? Center(
        child: Text(
          'Mevcut görev yok',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      )
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Column(
            children: [
              TaskItemWidget(
                task: task,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TaskDetailPage(
                        task: task,
                        onCompleteTask: () {
                          onCompleteTask(task);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ).then((_) => onTaskUpdated());
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final TextEditingController _titleController =
                      TextEditingController(text: task.title);
                      final TextEditingController _descriptionController =
                      TextEditingController(
                          text: task.description);
                      final TextEditingController _ownerController =
                      TextEditingController(text: task.owner);
                      DateTime _dueDate = task.dueDate;

                      return AlertDialog(
                        title: Text('Görevi Düzenle'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: 'Başlık',
                              ),
                            ),
                            TextField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Açıklama',
                              ),
                            ),
                            TextField(
                              controller: _ownerController,
                              decoration: InputDecoration(
                                labelText: 'Görev Sahibi',
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                _dueDate =
                                    await showDatePicker(
                                      context: context,
                                      initialDate: _dueDate,
                                      firstDate:
                                      DateTime(2000),
                                      lastDate: DateTime(2100),
                                    ) ??
                                        _dueDate;
                                setState(() {});
                              },
                              child: Text(
                                  'Son Tarih: ${_dueDate.toString().substring(0, 10)}'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('İptal'),
                          ),
                          TextButton(
                            onPressed: () {
                              final updatedTask = Task(
                                id: task.id,
                                title: _titleController.text,
                                description:
                                _descriptionController.text,
                                owner: _ownerController.text,
                                dueDate: _dueDate,
                              );
                              onUpdateTask(updatedTask);
                              Navigator.of(context).pop();
                            },
                            child: Text('Güncelle'),
                          ),
                          TextButton(
                            onPressed: () {
                              onRemoveTask(task);
                              Navigator.of(context).pop();
                            },
                            child: Text('Sil'),
                          ),
                        ],
                      );
                    },
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController
                            _titleController =
                            TextEditingController(
                                text: task.title);
                            final TextEditingController
                            _descriptionController =
                            TextEditingController(
                                text: task.description);
                            final TextEditingController
                            _ownerController =
                            TextEditingController(
                                text: task.owner);
                            DateTime _dueDate = task.dueDate;

                            return AlertDialog(
                              title: Text('Görevi Düzenle'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller:
                                    _titleController,
                                    decoration:
                                    InputDecoration(
                                      labelText: 'Başlık',
                                    ),
                                  ),
                                  TextField(
                                    controller:
                                    _descriptionController,
                                    decoration:
                                    InputDecoration(
                                      labelText: 'Açıklama',
                                    ),
                                  ),
                                  TextField(
                                    controller:
                                    _ownerController,
                                    decoration:
                                    InputDecoration(
                                      labelText: 'Görev Sahibi',
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () async {
                                      _dueDate =
                                          await showDatePicker(
                                            context: context,
                                            initialDate:
                                            _dueDate,
                                            firstDate:
                                            DateTime(
                                                2000),
                                            lastDate:
                                            DateTime(
                                                2100),
                                          ) ??
                                              _dueDate;
                                    },
                                    child: Text(
                                        'Son Tarih: ${_dueDate.toString().substring(0, 10)}'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('İptal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final updatedTask = Task(
                                      id: task.id,
                                      title:
                                      _titleController.text,
                                      description:
                                      _descriptionController
                                          .text,
                                      owner:
                                      _ownerController.text,
                                      dueDate: _dueDate,
                                    );
                                    onUpdateTask(updatedTask);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Güncelle'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Görevi Sil'),
                              content: Text(
                                  'Bu görevi silmek istiyor musunuz?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Hayır'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onRemoveTask(task);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Evet'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10), // Add space between tasks
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddTaskDialog(
                onTaskAdded: (newTask) {
                  onTaskAdded(newTask);
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void setState(Null Function() param0) {}
}

class CompletedTasksPage extends StatelessWidget {
  final List<Task> completedTasks;
  final ValueChanged<Task> onTaskReactivated;
  final ValueChanged<Task> onDeleteTask;

  CompletedTasksPage(
      {required this.completedTasks,
        required this.onTaskReactivated,
        required this.onDeleteTask});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tamamlanan Görevler'),
      ),
      body: completedTasks.isEmpty
          ? Center(
        child: Text(
          'Tamamlanmış görev yok',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      )
          : ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return Column(
            children: [
              TaskItemWidget(
                task: task,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TaskDetailPage(
                        task: task,
                        onCompleteTask: () {
                          onTaskReactivated(task);
                          Navigator.of(context).pop();
                        },
                        isCompleted: true,
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Görevi Sil'),
                        content: Text(
                            'Bu görevi silmek istiyor musunuz?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Hayır'),
                          ),
                          TextButton(
                            onPressed: () {
                              onDeleteTask(task);
                              Navigator.of(context).pop();
                            },
                            child: Text('Evet'),
                          ),
                        ],
                      );
                    },
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Görevi Sil'),
                          content: Text(
                              'Bu görevi silmek istiyor musunuz?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Hayır'),
                            ),
                            TextButton(
                              onPressed: () {
                                onDeleteTask(task);
                                Navigator.of(context).pop();
                              },
                              child: Text('Evet'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10), // Add space between tasks
            ],
          );
        },
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final Map<String, int> userTaskCounts;

  ProfilePage({required this.userTaskCounts});

  @override
  Widget build(BuildContext context) {
    final sortedUserTaskCounts = userTaskCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 75,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            SizedBox(height: 10),
            Text(
              'Adınız Soyadınız',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'email@domain.com',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'En Çok Görev Tamamlayanlar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sortedUserTaskCounts.length,
                itemBuilder: (context, index) {
                  final user = sortedUserTaskCounts[index];
                  return ListTile(
                    title: Text(user.key),
                    trailing: Text('${user.value} Görev'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskDetailPage extends StatelessWidget {
  final Task task;
  final VoidCallback onCompleteTask;
  final bool isCompleted;

  TaskDetailPage(
      {required this.task,
        required this.onCompleteTask,
        this.isCompleted = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Görev Detayları'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style:
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Görev Sahibi: ${task.owner}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Açıklama: ${task.description}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Son Tarih: ${task.dueDate}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: onCompleteTask,
                child: Text(isCompleted
                    ? 'Görevi Yeniden Aktif Et' : 'Görevi Tamamla'),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.greenAccent),)
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;

  TaskItemWidget(
      {required this.task,
        required this.onTap,
        this.onLongPress,
        this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: task.isNew ? Colors.blue[100] : Colors.blue[100],
      title: Text(task.title),
      subtitle: Text(
          'Görev Sahibi: ${task.owner}\nSon Tarih: ${task.dueDate.toString().substring(0, 10)}'),
      onTap: onTap,
      onLongPress: onLongPress,
      trailing: trailing,
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  final ValueChanged<Task> onTaskAdded;

  AddTaskDialog({required this.onTaskAdded});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController =
  TextEditingController();
  final TextEditingController _descriptionController =
  TextEditingController();
  final TextEditingController _ownerController =
  TextEditingController();
  DateTime _dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Görev Ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Başlık',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Açıklama',
            ),
          ),
          TextField(
            controller: _ownerController,
            decoration: InputDecoration(
              labelText: 'Görev Sahibi',
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              _dueDate = await showDatePicker(
                context: context,
                initialDate: _dueDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              ) ??
                  _dueDate;
              setState(() {});
            },
            child: Text(
                'Son Tarih: ${_dueDate.toString().substring(0, 10)}'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('İptal'),
        ),
        TextButton(
          onPressed: () {
            final newTask = Task(
              id: DateTime.now().toString(),
              title: _titleController.text,
              description: _descriptionController.text,
              owner: _ownerController.text,
              dueDate: _dueDate,
              isNew: true,
            );
            widget.onTaskAdded(newTask);
            Navigator.of(context).pop();
          },
          child: Text('Ekle'),
        ),
      ],
    );
  }
}

class Task {
  String id;
  String title;
  String description;
  String owner;
  DateTime dueDate;
  bool isNew;

  Task(
      {required this.id,
        required this.title,
        required this.description,
        required this.owner,
        required this.dueDate,
        this.isNew = false});
}
