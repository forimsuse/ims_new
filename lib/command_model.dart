import 'list_commands.dart';

class CommandModel{
  final EnCommand command;
  final List<int> data;
  final bool required;

  CommandModel({required this.command, required this.data,this.required = false});

  @override
  String toString() {
    return command.toString();
  }
}