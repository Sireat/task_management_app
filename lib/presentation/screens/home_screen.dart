import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../provider/quote_provider.dart'; // Import QuoteProvider
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch quote when screen is initialized
    _fetchQuote();
  }

  Future<void> _fetchQuote() async {
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    await quoteProvider.fetchQuotes(); // Call the public method to initialize
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final quoteProvider = Provider.of<QuoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        backgroundColor: const Color.fromARGB(255, 213, 216, 218), // Darker, professional color
      ),
      body: Container(
        color: Colors.blueGrey[100], // Light background color
        child: Column(
          children: [
            if (quoteProvider.currentQuote != null) ...[
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 4),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '"${quoteProvider.currentQuote!.quote}"',
                      style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '- ${quoteProvider.currentQuote!.author}',
                      style: TextStyle(
                        color: Colors.blueGrey[600],
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskProvider.tasks[index];
                  return TaskTile(task: task);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_edit_task'),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueGrey[800], // Match AppBar color
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey[800], // Match AppBar color
              ),
              child: const Text(
                'Task Manager',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.blueGrey[700]),
              title: const Text('Home'),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.blueGrey[700]),
              title: const Text('Completed Tasks'),
              onTap: () => Navigator.pushNamed(context, '/completed_tasks'),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blueGrey[700]),
              title: const Text('Settings'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
    );
  }
}
