import 'package:flutter/material.dart';
import './reasons_screen.dart';
import '/core/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/bloc.dart';
import '../widget/widget.dart';

class FeelingFormScreen extends StatefulWidget {
  const FeelingFormScreen({
    Key? key,
    this.feeling = "",
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
  }) : super(key: key);

  final String? feeling;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  _FeelingFormScreenState createState() => _FeelingFormScreenState();
}

class _FeelingFormScreenState extends State<FeelingFormScreen>
    with SingleTickerProviderStateMixin {
  late FeelingFormBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = FeelingFormBloc();
  }

  void _handleButtonPress(String? feelingForm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReasonScreen(
          feeling: widget.feeling ?? "",
          feelingForm: feelingForm ?? "",
          textColor: widget.textColor ?? Colors.black,
          backgroundColor: widget.backgroundColor ?? Colors.black,
        ),
      ),
    );
  }

  List<Widget> _buildFeelingFormButtons() {
    List<Widget> rows = [];
    List<String> feelingForms = _bloc.feelingForms.containsKey(widget.feeling) 
    ? _bloc.feelingForms[widget.feeling]! 
    : [];



    for (int i = 0; i < feelingForms.length; i += 2) {
      var rowButtons = <Widget>[
        Expanded(child: _buildFeelingFormButton(feelingForms[i]))
      ];

      if (i + 1 < feelingForms.length) {
        rowButtons.add(SizedBox(width: 16.0));
        rowButtons.add(
            Expanded(child: _buildFeelingFormButton(feelingForms[i + 1])));
      }

      rows.add(Row(children: rowButtons));
      rows.add(SizedBox(height: 16.0));
    }

    return rows;
  }

    Widget _buildFeelingFormButton(String feelingForm) {
    return EntityButton(
      entity: feelingForm,
      textColor: widget.textColor,
      fontSize: _bloc.computeTextSize(MediaQuery.of(context).size.width).sp,
      onTap: () => _handleButtonPress(feelingForm),
      emojiSize: null,
      buttonStyle: ThemeHelper().buttonStyle().copyWith(
        backgroundColor: MaterialStateProperty.all<Color>(
          _bloc.buttonColors[widget.feeling] ?? Color(0xFF0077C2),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.all(16.0),
        ),
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        elevation: 0,
        title: Text(
          '',
          style: TextStyle(
            color: widget.textColor,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0.w),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
                  ),
                  child: Text(
                    "What manifestation of ${widget.feeling!.toLowerCase()} are you feeling?",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                ..._buildFeelingFormButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
