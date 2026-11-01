import 'package:flutter/material.dart';

import 'app.dart';
import 'data/in_memory_task_repository.dart';

void main() {
  runApp(AuraApp(taskRepository: InMemoryTaskRepository()));
}
