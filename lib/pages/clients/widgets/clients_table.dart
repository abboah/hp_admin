import 'package:flutter/material.dart';
import 'package:hp_admin/constants/style.dart';
import 'package:hp_admin/widgets/custom_text.dart';

class ClientsTable extends StatelessWidget {
  const ClientsTable({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration purposes
    List<Map<String, dynamic>> userList = [
      {
        "name": "User1",
        "location": "New York City",
        "rating": 4.5,
        "action": "Block"
      },
      // Add more user data...
    ];

    // PaginatedDataTable settings
    final PaginatedDataTable paginatedDataTable = PaginatedDataTable(
      header: const Text('User Management'),
      columns: const [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Location')),
        DataColumn(label: Text('Rating')),
        DataColumn(label: Text('Action')),
      ],
      source: UserDataTableSource(userList),
      rowsPerPage: 10, // Adjust as needed
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 6),
              color: lightGrey.withOpacity(.1),
              blurRadius: 12)
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: paginatedDataTable,
      ),
    );
  }
}

class UserDataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> userList;

  UserDataTableSource(this.userList);

  @override
  DataRow getRow(int index) {
    final user = userList[index];
    return DataRow(cells: [
      DataCell(CustomText(text: user["name"])),
      DataCell(CustomText(text: user["location"])),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star,
              color: Colors.deepOrange,
              size: 18,
            ),
            SizedBox(width: 5),
            CustomText(text: user["rating"].toString()),
          ],
        ),
      ),
      DataCell(
        Container(
          decoration: BoxDecoration(
            color: light,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: active, width: .5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: CustomText(
            text: user["action"],
            color: active.withOpacity(.7),
            weight: FontWeight.bold,
          ),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => userList.length;

  @override
  int get selectedRowCount => 0;
}
