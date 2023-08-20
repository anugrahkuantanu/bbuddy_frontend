import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final String initialValue;
  final String dialogHeading;
  final Function(String) onEdit;
  final bool allowNullValues;
  final String errorString;

  EditDialog({
    required this.initialValue,
    required this.onEdit,
    required this.dialogHeading,
    this.allowNullValues = true,
    this.errorString = 'Milestone can\'t be empty'
  });

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController _textEditingController;
  String errorMessage = '';
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void validateContent(String value) {
    setState(() {
      if (!widget.allowNullValues && value.isEmpty) {
        errorMessage = widget.errorString;
      } else {
        errorMessage = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dialogHeading),
      /*content: TextField(
        controller: _textEditingController,
        maxLines: null,
      ),*/
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          TextField(
            controller: _textEditingController,
            maxLines: null,
            //onChanged: validateContent,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            String content = _textEditingController.text;
            validateContent(content);
            if (errorMessage == '') {
              widget.onEdit(content);
            }
          },
          child: Text('Save'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
