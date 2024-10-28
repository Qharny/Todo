// // In the HomePage class, add these methods:

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:todo/models/category.dart';
// import 'package:todo/models/priority.dart';
// import 'package:todo/services/hive.dart';

// void _showAddOptions() {
//   showModalBottomSheet(
//     context: context,
//     builder: (context) => Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             leading: const Icon(Icons.task),
//             title: const Text('Add Task'),
//             onTap: () {
//               Navigator.pop(context);
//               _showAddTaskDialog();
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.category),
//             title: const Text('Add Category'),
//             onTap: (dynamic categoriesBox) {
//               Navigator.pop(context);
//               _showAddCategoryDialog(
//                 categoriesBox.get('categories') as List<Category>,
                
//               );
//             },
//           ),
//         ],
//       ),
//     ),
//   );
// }

// void _showAddTaskDialog() {
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   DateTime? selectedDate = DateTime.now();
//   Priority selectedPriority = Priority.medium;
//   dynamic selectedCategory;

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (context) => StatefulBuilder(
//       builder: (context, setState) => Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: 16,
//           right: 16,
//           top: 16,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Add New Task',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(
//                 labelText: 'Task Title',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: descriptionController,
//               decoration: const InputDecoration(
//                 labelText: 'Description',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: ValueListenableBuilder(
//                     valueListenable: HiveService.categoryBox.listenable(),
//                     builder: (context, Box box, _) {
//                       final categories = box.values.toList();
//                       return DropdownButtonFormField(
//                         value: selectedCategory,
//                         decoration: const InputDecoration(
//                           labelText: 'Category',
//                           border: OutlineInputBorder(),
//                         ),
//                         items: categories.map((category) {
//                           return DropdownMenuItem(
//                             value: category,
//                             child: Text(category.name),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCategory = value;
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: DropdownButtonFormField<Priority>(
//                     value: selectedPriority,
//                     decoration: const InputDecoration(
//                       labelText: 'Priority',
//                       border: OutlineInputBorder(),
//                     ),
//                     items: Priority.values.map((priority) {
//                       return DropdownMenuItem(
//                         value: priority,
//                         child: Text(priority.toString().split('.').last),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedPriority = value ?? Priority.medium;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ListTile(
//               title: const Text('Due Date'),
//               subtitle: Text(
//                 selectedDate != null
//                     ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
//                     : 'Select a date',
//               ),
//               trailing: const Icon(Icons.calendar_today),
//               onTap: () async {
//                 final picked = await showDatePicker(
//                   context: context,
//                   initialDate: selectedDate ?? DateTime.now(),
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime(2101),
//                 );
//                 if (picked != null) {
//                   setState(() {
//                     selectedDate = picked;
//                   });
//                 }
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 if (titleController.text.isEmpty || selectedCategory == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please fill in all required fields'),
//                     ),
//                   );
//                   return;
//                 }
                
//                 // Add task to Hive
//                 HiveService.addTask({
//                   'title': titleController.text,
//                   'description': descriptionController.text,
//                   'categoryKey': selectedCategory.key,
//                   'priority': selectedPriority,
//                   'dueDate': selectedDate,
//                   'isCompleted': false,
//                   'isDeleted': false,
//                   'createdAt': DateTime.now(),
//                 });
                
//                 Navigator.pop(context);
//               },
//               child: const Text('Add Task'),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// void _showAddCategoryDialog(dynamic context) {
//   final nameController = TextEditingController();
//   final descriptionController = TextEditingController();
//   String selectedIcon = 'other';
//   Color selectedColor = Colors.blue;

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (context) => StatefulBuilder(
//       builder: (context, setState) => Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: 16,
//           right: 16,
//           top: 16,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Add New Category',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Category Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: descriptionController,
//               decoration: const InputDecoration(
//                 labelText: 'Description',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 2,
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: selectedIcon,
//               decoration: const InputDecoration(
//                 labelText: 'Icon',
//                 border: OutlineInputBorder(),
//               ),
//               items: const [
//                 DropdownMenuItem(value: 'work', child: Text('Work')),
//                 DropdownMenuItem(value: 'personal', child: Text('Personal')),
//                 DropdownMenuItem(value: 'shopping', child: Text('Shopping')),
//                 DropdownMenuItem(value: 'health', child: Text('Health')),
//                 DropdownMenuItem(value: 'education', child: Text('Education')),
//                 DropdownMenuItem(value: 'finance', child: Text('Finance')),
//                 DropdownMenuItem(value: 'home', child: Text('Home')),
//                 DropdownMenuItem(value: 'other', child: Text('Other')),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   selectedIcon = value ?? 'other';
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             ListTile(
//               title: const Text('Category Color'),
//               trailing: Container(
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: selectedColor,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Pick a color'),
//                     content: SingleChildScrollView(
//                       child: ColorPicker(
//                         pickerColor: selectedColor,
//                         onColorChanged: (color) {
//                           setState(() {
//                             selectedColor = color;
//                           });
//                         },
//                       ),
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('Done'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 if (nameController.text.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please enter a category name'),
//                     ),
//                   );
//                   return;
//                 }
                
//                 // Add category to Hive
//                 final category = Category(
//                   name: nameController.text,
//                   description: descriptionController.text,
//                   color: selectedColor.value,
//                   iconName: selectedIcon,
//                 );
//                 HiveService.categoryBox.add(category);
                
//                 Navigator.pop(context);
//               },
//               child: const Text('Add Category'),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// // Update the FAB onPressed in the build method:
// floatingActionButton: ScaleTransition(
//   scale: _fabAnimation,
//   child: FloatingActionButton(
//     onPressed: _showAddOptions,
//     child: const Icon(Icons.add),
//   ),
// ),