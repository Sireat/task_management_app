import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../provider/task_provider.dart';

class AddEditTaskScreen extends StatefulWidget {
  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  bool _isCompleted = false;
  bool _isSaving = false;
  String? _errorMessage;

  late ConfettiController _confettiController;
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Task'),
        backgroundColor: const Color.fromARGB(255, 231, 234, 236), // Dark Blue for the app bar
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                _buildTextField(
                  controller: _titleController,
                  label: 'Title',
                  placeholder: 'Enter task title...',
                  isTitle: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  placeholder: 'Enter task description...',
                  isTitle: false,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickDateTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white, // White background for the date picker field
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Due Date: ${_dueDate == null ? '' : '${_dueDate!.toLocal().toString().split(' ')[0]} ${_dueDate!.toLocal().toString().split(' ')[1].substring(0, 8)}'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.blueAccent),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Completed', style: TextStyle(fontSize: 16)),
                    Checkbox(
                      value: _isCompleted,
                      onChanged: _titleController.text.isEmpty
                          ? null // Disable checkbox if title is empty
                          : (value) {
                              setState(() {
                                _isCompleted = value!;
                                if (_isCompleted) {
                                  _confettiController.play();
                                  _iconAnimationController.forward();
                                }
                              });
                            },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveTask,
                  child: const Text('Save Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 234, 236, 240), // Primary color for button
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue],
            ),
          ),
          _buildSuccessIcons(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    required bool isTitle,
  }) {
    return Opacity(
      opacity: _titleController.text.isEmpty && isTitle ? 0.5 : 1.0,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
        keyboardType: TextInputType.text,
        maxLines: isTitle ? 1 : 3,
      ),
    );
  }

  Widget _buildSuccessIcons() {
    return Positioned(
      top: 100,
      left: MediaQuery.of(context).size.width * 0.25,
      child: FadeTransition(
        opacity: _iconAnimation,
        child: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50.0),
            SizedBox(height: 10),
            Icon(Icons.star, color: Colors.yellow, size: 50.0),
            SizedBox(height: 10),
            Icon(Icons.thumb_up, color: Colors.blue, size: 50.0),
          ],
        ),
      ),
    );
  }

  void _pickDateTime() async {
    final pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDateTime != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _dueDate = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
            0, // Seconds set to 0
          );
        });
      }
    }
  }

  void _saveTask() async {
    if (_titleController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Title is required';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      await taskProvider.addTask(
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate ?? DateTime.now(),
        isCompleted: _isCompleted,
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save task. Please try again.';
      });
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }
}
