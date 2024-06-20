import 'employee.dart';
import 'employee_service.dart';

class GetJson {
  List<String> employeeTitlesAndRoles = [];

  Future<void> makeList() async {
    int id = 1;
    try {
      while (true) {
        // Fetch employee details using id
        Employee employee = await EmployeeService().getEmployeeById(id);

        // If employee found, add name and role to the list
        String titleAndRole = '${employee.name} - ${employee.role}';
        employeeTitlesAndRoles.add(titleAndRole);

        // Increment id for the next employee
        id++;
      }
    } catch (e) {
      // Handle error if employee with the current id does not exist
      print('Error fetching employee with ID $id: $e');
      // You can choose to break the loop or handle the error as needed
    }
  }
}
