import 'package:flutter/material.dart';
// In this file i am correcting 5 issues found in this give file which are:
//1.  Non-nullable instance field 'selectedUser' must be initialized.
// 2. ListView inside a Column  exactly causes overflow error when we are running , it must be wrapped in an expanded widget
// 3 Removing task like this may is not safe, if list is used in other place, it can cause problems,
// 4.  Floating action button is not a child of Column  , it might go in scafold cause it has a nullable  field of Widget type called floatingActionButton. See how i did it in my todoApp
// 5. Searched list is overwritting the initial list, which is mistake. We must have the list for searched items so that we can get back initial when we click on backspace

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}
class _UserListScreenState extends State<UserListScreen> {
  List<String> allUsers = ['Alice', 'Bob', 'Charlie', 'Diana'];
  List<String> filteredUsers = [];
  String? selectedUser;

  @override
  void initState() {
    filteredUsers = List.from(allUsers);
    super.initState();
  }

  void searchUsers(String query) {
    setState(() {
      filteredUsers = query.isEmpty
          ? List.from(allUsers)
          : allUsers.where((user) => user.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void addUser() {
    setState(() {
      final newUser = 'New User ${allUsers.length + 1}';
      allUsers.add(newUser);
      filteredUsers.add(newUser);
    });
  }

  void deleteUser(int index) {
    final user = filteredUsers[index];
    setState(() {
      allUsers.remove(user);
      filteredUsers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: searchUsers,
              decoration: const InputDecoration(
                hintText: 'Search users...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Selected: ${selectedUser?.toUpperCase() ?? "None"}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredUsers[index]),
                  onTap: () {
                    setState(() {
                      selectedUser = filteredUsers[index];
                    });
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteUser(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
