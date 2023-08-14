import 'package:flutter/material.dart';
import './reasons_screen.dart';
import '/features/main_app/utils/helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/bloc.dart';

class FeelingFormScreen extends StatefulWidget {
  FeelingFormScreen({Key? key, 
  required this.feeling,
  required this.backgroundColor,
  required this.textColor,
  }) : super(key: key);

  final String feeling;
  final Color backgroundColor;
  final Color textColor;

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

  void _handleButtonPress(String feelingForm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ReasonScreen(feeling: widget.feeling, feelingForm: feelingForm, textColor: widget.textColor, backgroundColor: widget.backgroundColor),
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
        iconTheme: IconThemeData(color: Colors.white), // Set the icon color to white
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
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
                  ),
                  child: Text(
                    "What manifestation of ${widget.feeling.toLowerCase()} are you feeling?",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 20.0,
                      runSpacing: 30.0,
                      children: _bloc.feelingForms[widget.feeling]!
                          .map((feelingForm) => _buildFeelingFormButton(feelingForm))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeelingFormButton(String feelingForm) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.5,
      child: OutlinedButton(
        onPressed: () => _handleButtonPress(feelingForm),
        style: ThemeHelper().buttonStyle().copyWith(
          backgroundColor: MaterialStateProperty.all<Color>(
            _bloc.buttonColors[widget.feeling] ?? Color(0xFF0077C2),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.all(16.0),
          ),
        ),
        child: Text(
          feelingForm,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.textColor,
            fontWeight: FontWeight.bold,
            fontSize: _bloc.computeTextSize(MediaQuery.of(context).size.width).sp,
          ),
        ),
      ),
    );
  }
}
