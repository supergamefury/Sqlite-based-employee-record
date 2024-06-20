import 'package:flutter/material.dart';
import 'employee.dart';
import 'employee_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Records',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final EmployeeService employeeService = EmployeeService();

  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Employee> employee;
  int currentEmployeeId = 1; // Start with the first employee ID

  @override
  void initState() {
    super.initState();

    // Load the first employee initially
    loadEmployeeById(currentEmployeeId);
  }

  void loadEmployeeById(int id) {
    setState(() {
      employee = widget.employeeService.getEmployeeById(id);
      currentEmployeeId = id;
    });
  }

  void getNextEmployee() {
    int nextEmployeeId = currentEmployeeId + 1;
    widget.employeeService.getEmployeeById(nextEmployeeId).then((employee) {
      // If employee is found, update the UI
      loadEmployeeById(nextEmployeeId);
    }).catchError((error) {
      // If error occurs (employee not found), keep the current employee
      print('No Employee found: $error');
    });
  }

  void getPreviousEmployee() {
    if (currentEmployeeId > 1) {
      int previousEmployeeId = currentEmployeeId - 1;
      widget.employeeService
          .getEmployeeById(previousEmployeeId)
          .then((employee) {
        // If employee is found, update the UI
        loadEmployeeById(previousEmployeeId);
      }).catchError((error) {
        // If error occurs (employee not found), keep the current employee
        print('Failed to load employee: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Records'),
      ),
      body: Center(
        child: FutureBuilder<Employee>(
          future: employee,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('No data available');
            } else {
              Employee emp = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(emp.name),
                    subtitle: Text(emp.role),
                    onTap: () {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: getPreviousEmployee,
                        child: Text('Previous'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: getNextEmployee,
                        child: Text('Next'),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Employee',
        child: const Icon(Icons.add),
      ),
    );
  }
}
