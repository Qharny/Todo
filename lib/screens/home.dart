import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:todo/models/priority.dart';
import 'package:todo/models/task_filter.dart';
import 'package:todo/services/hive.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../models/category.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  bool _showSearch = false;
  TaskFilter _currentFilter = TaskFilter(name: "All Tasks");
  
  // Animation controllers
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Initialize FAB animation
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    );

    // Start the FAB animation
    _fabController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  // Build the app bar with search functionality
  Widget _buildAppBar() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _showSearch
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _showSearch = false;
                    _searchController.clear();
                  });
                },
              ),
              title: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              ),
            )
          : AppBar(
              title: const Text('Task Manager'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => setState(() => _showSearch = true),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterDialog,
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Tasks'),
                  Tab(text: 'Categories'),
                ],
              ),
            ),
    );
  }

  // Build the task statistics card
  Widget _buildStatsCard() {
    return ValueListenableBuilder(
      valueListenable: HiveService.taskBox.listenable(),
      builder: (context, Box box, _) {
        final totalTasks = box.length;
        final completedTasks = box.values
            .where((task) => task['isCompleted'] == true)
            .length;
        
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Task Progress',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '$completedTasks/$totalTasks',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build the task list
  Widget _buildTaskList() {
    return ValueListenableBuilder(
      valueListenable: HiveService.taskBox.listenable(),
      builder: (context, Box box, _) {
        final tasks = box.values.where((task) => 
          _currentFilter.matchesTask(task) &&
          (task['title'] ?? '').toLowerCase().contains(_searchController.text.toLowerCase())
        ).toList();

        return AnimationLimiter(
          child: RefreshIndicator(
            onRefresh: () async {
              // Implement refresh logic
              await Future.delayed(const Duration(seconds: 1));
              setState(() {});
            },
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Dismissible(
                        key: Key(task.key.toString()),
                        background: _buildDismissibleBackground(),
                        secondaryBackground: _buildDismissibleBackground(isRight: true),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.startToEnd) {
                            // Complete task
                            HiveService.updateTask(task.key, {
                              ...task,
                              'isCompleted': true,
                            });
                          } else {
                            // Delete task
                            HiveService.deleteTask(task.key);
                          }
                        },
                        child: _buildTaskItem(task),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Build the category grid
  Widget _buildCategoryGrid() {
    return ValueListenableBuilder(
      valueListenable: HiveService.categoryBox.listenable(),
      builder: (context, Box box, _) {
        return AnimationLimiter(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final category = box.getAt(index);
              return AnimationConfiguration.staggeredGrid(
                position: index,
                columnCount: 2,
                duration: const Duration(milliseconds: 375),
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: _buildCategoryCard(category),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Build individual task item
  Widget _buildTaskItem(dynamic task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            task['isCompleted'] ? Icons.check_circle : Icons.circle_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            HiveService.updateTask(task.key, {
              ...task,
              'isCompleted': !task['isCompleted'],
            });
          },
        ),
        title: Text(
          task['title'],
          style: TextStyle(
            decoration: task['isCompleted'] ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task['description'] ?? ''),
        trailing: task['priority'] != null
            ? _buildPriorityIndicator(task['priority'])
            : null,
      ),
    );
  }

  // Build category card
  Widget _buildCategoryCard(dynamic category) {
    return Card(
      child: InkWell(
        onTap: () {
          // Handle category selection
          setState(() {
            _currentFilter = TaskFilter(
              name: category.name,
              categoryKeys: [category.key],
            );
            _tabController.animateTo(0);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category.icon,
                size: 32,
                color: category.categoryColor,
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build dismissible background
  Widget _buildDismissibleBackground({bool isRight = false}) {
    return Container(
      color: isRight ? Colors.red : Colors.green,
      alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(
        isRight ? Icons.delete : Icons.check,
        color: Colors.white,
      ),
    );
  }

  // Build priority indicator
  Widget _buildPriorityIndicator(Priority priority) {
    final colors = {
      Priority.high: Colors.red,
      Priority.medium: Colors.orange,
      Priority.low: Colors.green,
    };

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors[priority],
      ),
    );
  }

  void _showFilterDialog() {
    // Implement filter dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: const Text('Filter options to be implemented'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 2),
        child: _buildAppBar(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              _buildStatsCard(),
              Expanded(child: _buildTaskList()),
            ],
          ),
          _buildCategoryGrid(),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () {
            _showAddOptions();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  // In the HomePage class, add these methods:

void _showAddOptions() {
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Add Task'),
            onTap: () {
              Navigator.pop(context);
              _showAddTaskDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Add Category'),
            onTap: () {
              Navigator.pop(context);
              _showAddCategoryDialog();
            },
          ),
        ],
      ),
    ),
  );
}

void _showAddTaskDialog() {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  Priority selectedPriority = Priority.medium;
  dynamic selectedCategory;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Task',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: HiveService.categoryBox.listenable(),
                    builder: (context, Box box, _) {
                      final categories = box.values.toList();
                      return DropdownButtonFormField(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<Priority>(
                    value: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: Priority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPriority = value ?? Priority.medium;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(
                selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : 'Select a date',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty || selectedCategory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields'),
                    ),
                  );
                  return;
                }
                
                // Add task to Hive
                HiveService.addTask({
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'categoryKey': selectedCategory.key,
                  'priority': selectedPriority,
                  'dueDate': selectedDate,
                  'isCompleted': false,
                  'isDeleted': false,
                  'createdAt': DateTime.now(),
                });
                
                Navigator.pop(context);
              },
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}

void _showAddCategoryDialog() {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedIcon = 'other';
  Color selectedColor = Colors.blue;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedIcon,
              decoration: const InputDecoration(
                labelText: 'Icon',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'work', child: Text('Work')),
                DropdownMenuItem(value: 'personal', child: Text('Personal')),
                DropdownMenuItem(value: 'shopping', child: Text('Shopping')),
                DropdownMenuItem(value: 'health', child: Text('Health')),
                DropdownMenuItem(value: 'education', child: Text('Education')),
                DropdownMenuItem(value: 'finance', child: Text('Finance')),
                DropdownMenuItem(value: 'home', child: Text('Home')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedIcon = value ?? 'other';
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Category Color'),
              trailing: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pick a color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: selectedColor,
                        onColorChanged: (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a category name'),
                    ),
                  );
                  return;
                }
                
                // Add category to Hive
                final category = Category(
                  name: nameController.text,
                  description: descriptionController.text,
                  color: selectedColor.value,
                  iconName: selectedIcon,
                );
                HiveService.categoryBox.add(category);
                
                Navigator.pop(context);
              },
              child: const Text('Add Category'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}
}