import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'textbox.dart';
import '../bloc/bloc.dart';
import '../widget/widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ReasonEvent {}

class EntitySelected extends ReasonEvent {
  final String entity;
  EntitySelected(this.entity);
}

class OtherEntityEntered extends ReasonEvent {
  final String enteredReason;
  OtherEntityEntered(this.enteredReason);
}


//STATE

abstract class ReasonState {}

class ReasonInitialState extends ReasonState {}

class ShowErrorState extends ReasonState {}

class OtherEntitySelectedState extends ReasonState{}

class NavigateToTextBoxState extends ReasonState {
  final String reasonEntity;
  NavigateToTextBoxState(this.reasonEntity);
}




class ReasonBloc extends Bloc<ReasonEvent, ReasonState> {
  ReasonBloc() : super(ReasonInitialState()) {
    on<EntitySelected>(_onEntitySelected);
    on<OtherEntityEntered>(_onOtherEntityEntered);
  }

  final List<String> entities = [
    'School',
    'Work',
    'Family',
    'Relationships',
    'Partner',
    'Money',
    'Health',
    'Friendship',
    'Social Media',
    'Good Sleep',
    'Career',
    'Goals',
    'Sex',
    'Boredom',
    'Addiction',
    'Food',
    'Other', // Added "Other" entity
  ];

  final Map<String, IconData> iconsMap = {
    'School': Icons.school,
    'Work': Icons.work,
    'Family': Icons.family_restroom,
    'Relationships': Icons.favorite,
    'Partner': Icons.favorite_border,
    'Money': Icons.attach_money,
    'Health': Icons.health_and_safety,
    'Friendship': Icons.emoji_people,
    'Social Media': Icons.social_distance,
    'Good Sleep': Icons.nights_stay,
    'Career': Icons.work_outline,
    'Goals': Icons.check_box_outline_blank,
    'Sex': Icons.people_alt,
    'Boredom': Icons.sentiment_dissatisfied,
    'Addiction': Icons.smoking_rooms,
    'Food': Icons.fastfood,
    'Other': Icons.more_horiz,
  };

  IconData getIcon(String entity) {
    return iconsMap[entity]!;
  }

  void _onEntitySelected(EntitySelected event, Emitter<ReasonState> emit) {
    if (event.entity == 'Other') {
      emit(ReasonInitialState());
    } else {
      emit(NavigateToTextBoxState(event.entity));
    }
  }

  void _onOtherEntityEntered(OtherEntityEntered event, Emitter<ReasonState> emit) {
    if (event.enteredReason.split(' ').length == 1 && event.enteredReason.isNotEmpty) {
      emit(NavigateToTextBoxState(event.enteredReason));
    } else {
      emit(ShowErrorState());
    }
  }
}

class ReasonPage extends StatefulWidget {
  ReasonPage({Key? key, required this.feeling, required this.feelingForm, required this.textColor})
      : super(key: key);
  final String feeling;
  final String feelingForm;
  final Color textColor;

  @override
  State<ReasonPage> createState() => _ReasonScreenState();
}

class _ReasonScreenState extends State<ReasonPage> {
  late ReasonBloc _bloc;

  void _handleButtonPress(String entity) {
    context.read<ReasonBloc>().add(EntitySelected(entity));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReasonBloc>(
      create: (context) => _bloc,
      child: BlocConsumer<ReasonBloc, ReasonState>(
        listener: (context, state) {
          if (state is NavigateToTextBoxState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TextBox(
                  feeling: widget.feeling,
                  feelingForm: widget.feelingForm,
                  reasonEntity: state.reasonEntity,
                ),
              ),
            );
          }
        },


builder: (context, state) {
  double screenWidth = MediaQuery.of(context).size.width;
  double emojiSize = 97.w;  // You might want to define these (like .w) based on your needs
  double textSize = 16.sp;  // Same comment as above
  double high_space = 76.w; // Same comment as above

  return Scaffold(
    backgroundColor: Color(0xFF2D425F),
    appBar: AppBar(
      backgroundColor: Color(0xFF2D425F),
      elevation: 0,
      title: Text(
        '',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0.w),
                child: Text(
                  "What is making you ${widget.feeling.toLowerCase()}?",
                  style: TextStyle(
                    fontSize: 22.0.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 40),
              if (state is ShowErrorState)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: Please enter a valid reason',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Container(
                color: Color(0xFF2D425F),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Wrap(
                      spacing: 25.0.w,
                      runSpacing: high_space,
                      children: _bloc.entities.map(
                        (entity) => SizedBox(
                          width: screenWidth / 5,
                          child: GestureDetector(
                            onTap: () => _handleButtonPress(entity),
                            child: Column(
                              children: [
                                Icon(
                                  _bloc.getIcon(entity),
                                  size: emojiSize,
                                  color: Colors.white,
                                ),
                                Text(
                                  entity,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: textSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
},

      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
