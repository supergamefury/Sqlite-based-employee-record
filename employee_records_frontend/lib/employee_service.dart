import 'dart:convert';
import 'package:http/http.dart' as http;
import 'employee.dart'; // Import your Employee class

class EmployeeService {
  Future<Employee> getEmployeeById(int id) async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/employees/$id'));
    if (response.statusCode == 200) {
      return Employee.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load employee');
    }
  }
}
