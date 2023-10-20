import 'package:flutter/material.dart';

// class EditDialog extends StatefulWidget {
//   final String initialValue;
//   final String dialogHeading;
//   final Function(String) onEdit;
//   final bool allowNullValues;
//   final String errorString;

//   const EditDialog(
//       {super.key,
//       required this.initialValue,
//       required this.onEdit,
//       required this.dialogHeading,
//       this.allowNullValues = true,
//       this.errorString = 'Milestone can\'t be empty'});

//   @override
//   _EditDialogState createState() => _EditDialogState();
// }

// class _EditDialogState extends State<EditDialog> {
//   late TextEditingController _textEditingController;
//   String errorMessage = '';
//   @override
//   void initState() {
//     super.initState();
//     _textEditingController = TextEditingController(text: widget.initialValue);
//   }

//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     super.dispose();
//   }

//   void validateContent(String value) {
//     setState(() {
//       if (!widget.allowNullValues && value.isEmpty) {
//         errorMessage = widget.errorString;
//       } else {
//         errorMessage = '';
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.dialogHeading),
//       /*content: TextField(
//         controller: _textEditingController,
//         maxLines: null,
//       ),*/
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (errorMessage.isNotEmpty)
//             Text(
//               errorMessage,
//               style: const TextStyle(
//                 color: Colors.red,
//               ),
//             ),
//           TextField(
//             controller: _textEditingController,
//             maxLines: null,
//             //onChanged: validateContent,
//           ),
//         ],
//       ),
//       actions: [
//         ElevatedButton(
//           onPressed: () {
//             String content = _textEditingController.text;
//             validateContent(content);
//             if (errorMessage == '') {
//               widget.onEdit(content);
//             }
//           },
//           child: const Text('Save'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('Cancel'),
//         ),
//       ],
//     );
//   }
// }

class EditDialog extends StatefulWidget {
  final String initialValue;
  final String dialogHeading;
  final Function(String) onEdit;
  final bool allowNullValues;
  final String errorString;
  final bool isSaving; // New property to track saving state

  const EditDialog({
    super.key,
    required this.initialValue,
    required this.onEdit,
    required this.dialogHeading,
    this.allowNullValues = true,
    this.errorString = 'Milestone can\'t be empty',
    this.isSaving = false, // New property
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          TextField(
            controller: _textEditingController,
            maxLines: null,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: widget.isSaving
              ? null // Disable button when saving
              : () {
                  String content = _textEditingController.text;
                  validateContent(content);
                  if (errorMessage == '') {
                    widget.onEdit(content);
                  }
                },
          child: widget.isSaving
              ? const CircularProgressIndicator() // Show loading indicator
              : const Text('Save'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
