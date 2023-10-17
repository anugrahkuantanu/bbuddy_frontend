import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/model.dart';
import '../widgets/widget.dart';

/*class CheckBoxTile extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;
  final Function() onDelete;
  final Function(String) onEdit;
  final Function() onAdd;
  final Function() onUpdateGoal;
  final String title;
  final Color backgroundColor;
  final double textSize;
  final Color themeColor;
  final double iconSize;
  List<Milestone>? subMilestones;

  CheckBoxTile({
    required this.value,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
    required this.onAdd,
    required this.onUpdateGoal,
    required this.title,
    required this.backgroundColor,
    this.textSize = 13.0,
    this.iconSize = 20.0,
    this.themeColor = Colors.white,
    this.subMilestones = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: backgroundColor,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0.w),
        ),
        child: Column(children: [
          ListTile(
            leading: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor:
                      themeColor, // Set the border color to white
                ),
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                )),
            title: Text(
              title,
              style: TextStyle(
                fontSize: textSize.w,
                color: themeColor,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onAdd,
                  icon: Icon(Icons.add),
                  iconSize: iconSize.w,
                  padding: EdgeInsets.zero, // Reduce the padding
                  constraints: BoxConstraints(), // Remove button's constraints
                  color: themeColor,
                ),
                IconButton(
                  onPressed: () {
                    // Edit button pressed
                    showDialog(
                      context: context,
                      builder: (context) => EditDialog(
                        initialValue: title,
                        onEdit: (newTitle) {
                          onEdit(newTitle);
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.edit),
                  iconSize: iconSize.w,
                  padding: EdgeInsets.zero, // Reduce the padding
                  constraints: BoxConstraints(), // Remove button's constraints
                  color: themeColor,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete),
                  iconSize: iconSize.w,
                  padding: EdgeInsets.zero, // Reduce the padding
                  constraints: BoxConstraints(), // Remove button's constraints
                  color: themeColor,
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            itemCount: subMilestones!.length,
            itemBuilder: (context, index) {
              Milestone subMilestone = subMilestones![index];
              return CheckBoxTile(
                value: false,
                onDelete: () {
                  // Remove the milestone from the list
                  subMilestones!.removeAt(index);
                  //updateGoal(goal);
                },
                onChanged: (value) {
                  // Handle checkbox state change
                },
                onEdit: (newTitle) {
                  // Update the milestone text
                  // setState(() {
                  //   subMilestones[index].content = newTitle;
                  // });
                  //updateGoal(goal);
                },
                onAdd: () {
                  // setState(() {
                  //   milestone.subMilestones
                  //       .add(Milestone(content: "New Sub-Milestone"));
                  // });
                },
                onUpdateGoal: onUpdateGoal,
                title: subMilestone.content,
                backgroundColor: Color.fromRGBO(17, 32, 55, 1.0),
                themeColor: themeColor,
                subMilestones: subMilestone.subMilestones,
              );
            },
          ),
        ]),
      ),
    );
  }
}*/

class CheckBoxTile extends StatefulWidget {
  final bool? value;
  final Function(bool?) onChanged;
  final Function() onDelete;
  final Function(String) onEdit;
  final Function() onAdd;
  final Function() onUpdateGoal;
  final String title;
  final Color backgroundColor;
  final double textSize;
  final Color themeColor;
  final double iconSize;
  final List<Milestone>? tasks;

  const CheckBoxTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
    required this.onAdd,
    required this.onUpdateGoal,
    required this.title,
    required this.backgroundColor,
    this.textSize = 13.0,
    this.iconSize = 20.0,
    this.themeColor = Colors.white,
    this.tasks = const [],
  });

  @override
  _CheckBoxTileState createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  List<Milestone>? tasks;

  @override
  void initState() {
    super.initState();
    tasks = widget.tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: widget.backgroundColor,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0.w),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: widget.themeColor,
                ),
                child: Checkbox(
                  value: widget.value,
                  tristate: false,
                  onChanged: widget.onChanged,
                  activeColor: widget.themeColor, // Custom active color
                  checkColor: Colors.white, // Custom check color
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              title: Text(
                widget.title,
                style: TextStyle(
                  decoration:
                      widget.value == true ? TextDecoration.lineThrough : null,
                  fontSize: widget.textSize.w,
                  color: widget.themeColor,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*IconButton(
                    onPressed: widget.onAdd,
                    icon: Icon(Icons.add),
                    iconSize: widget.iconSize.w,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    color: widget.themeColor,
                  ),*/
                  IconButton(
                    onPressed: () {
                      /*showDialog(
                        context: context,
                        builder: (context) => EditDialog(
                          initialValue: widget.title,
                          onEdit: widget.onEdit,
                        ),
                      );*/

                      showDialog(
                        context: context,
                        builder: (context) => EditDialog(
                          dialogHeading: 'Edit Milestone',
                          initialValue: widget.title,
                          allowNullValues: false,
                          onEdit: (content) {
                            widget.onEdit(content);
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    iconSize: widget.iconSize.w,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: widget.themeColor,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.onDelete();
                      });
                    },
                    icon: const Icon(Icons.delete),
                    iconSize: widget.iconSize.w,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: widget.themeColor,
                  ),
                ],
              ),
            ),
            /*ListView.builder(
              shrinkWrap: true,
              itemCount: tasks!.length,
              itemBuilder: (context, index) {
                Milestone task = tasks![index];
                return CheckBoxTile(
                  value: false,
                  onDelete: () {
                    setState(() {
                      tasks!.removeAt(index);
                      widget.onUpdateGoal();
                    });
                  },
                  onChanged: (value) {
                    // Handle checkbox state change
                  },
                  onEdit: (newTitle) {
                    // Update the milestone text
                    widget.onEdit(newTitle);
                  },
                  onAdd: () {
                    // Add sub-milestone logic
                  },
                  onUpdateGoal: widget.onUpdateGoal,
                  title: task.content,
                  backgroundColor: Color.fromRGBO(17, 32, 55, 1.0),
                  themeColor: widget.themeColor,
                  tasks: task.tasks,
                );
              },
            ),*/
          ],
        ),
      ),
    );
  }
}
