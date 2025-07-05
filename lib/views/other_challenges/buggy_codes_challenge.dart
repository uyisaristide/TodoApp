// import 'package:flutter/material.dart';
//
// class UserListScreen extends StatefulWidget {
//   @override
//   _UserListScreenState createState() => _UserListScreenState();
// }
//
// class _UserListScreenState extends State<UserListScreen> {
//   List<String> users = ['Alice', 'Bob', 'Charlie', 'Diana'];
//   String selectedUser;
//   //1.  Non-nullable instance field 'selectedUser' must be initialized.
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User List'),
//       ),
//       body: Column(
//         children: [
//           // Search bar
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: TextField(
//               onChanged: (value) => searchUsers(value),
//               decoration: const InputDecoration(
//                 hintText: 'Search users...',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//
//           // Selected user display
//           Container(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Selected: ${selectedUser.toUpperCase()}',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           // 2. ListView inside a Column  exactly causes overflow error when we are running , it must be wrapped in an expanded widget
//           // User list
//           ListView.builder(
//             itemCount: users.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(users[index]),
//                 onTap: () {
//                   setState(() {
//                     selectedUser = users[index];
//                   });
//                 },
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     // 3 Removing task like this may is not safe, if list is used in other place, it can cause problems,
//                     users.removeAt(index);
//                     setState(() {});
//                   },
//                 ),
//               );
//             },
//           ),
//           // 4. And floating action button is not a child of Column of cause Hahaha, it might go in scafold cause it has a nullable  field of Widget type called floatingActionButton. See how i did it in my todoApp
//           // Add user button
//           FloatingActionButton(
//             onPressed: () => addUser(),
//             child: Icon(Icons.add),
//           ),
//         ],
//       ),
//
//     );
//   }
//   // 5. Searched list is overwritting the initial list, which is mistake. We must have the list for searched items so that we can get back initial when we click on backspace
//   void searchUsers(String query) {
//     if (query.isEmpty) {
//       users = ['Alice', 'Bob', 'Charlie', 'Diana'];
//     } else {
//       users = users.where((user) =>
//           user.toLowerCase().contains(query.toLowerCase())
//       ).toList();
//     }
//     setState(() {});
//   }
//
//   void addUser() {
//     users.add('New User ${users.length + 1}');
//     setState(() {});
//   }
// }