import 'package:flutter/material.dart';
import './view_reflection_results.dart';

class NewReflection extends StatelessWidget {
  final List topics;

  const NewReflection({Key? key, required this.topics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<String> userReflections = List.generate(topics.length, (index) => '');
    return Scaffold(
      backgroundColor: Color(0xFF2D425F),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(17, 32, 55, 1.0),
                          borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          // border: Border.all(
                          //   color: Colors.white,
                          //   width: screenWidth * 0.005,
                          // ),
                          // boxShadow: [
                          //   // BoxShadow(
                          //   //   color: Colors.grey.withOpacity(0.5),
                          //   //   spreadRadius: 2,
                          //   //   blurRadius: 5,
                          //   //   offset: Offset(0, 3),
                          //   // ),
                          // ],
                        ),
                        child: Text(
                          topics[index],
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          //  textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        
                        decoration: InputDecoration(
                          hintText: 'Enter your thoughts here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: EdgeInsets.all(16.0),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Color(0xFF404659),
                              width: 1.5,
                            ),
                          ),
                        ),
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          userReflections[index] = value;
                        },
                      ),
                      SizedBox(height: 25),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewReflectionResults(
                topics: topics,
                userReflections: userReflections,
              ),
            ),
          );
        },
        backgroundColor: Color.fromRGBO(17, 32, 55, 1.0),
        child: Icon(Icons.arrow_forward, color: Colors.white),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endDocked.withOffset(Offset(0, -50.0)),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      
    );
  }
}

extension CustomFloatingActionButtonLocation on FloatingActionButtonLocation {
  FloatingActionButtonLocation withOffset(Offset offset) {
    return FloatingActionButtonLocationWithOffset(this, offset);
  }
}

class FloatingActionButtonLocationWithOffset
    extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation delegate;
  final Offset offset;

  FloatingActionButtonLocationWithOffset(this.delegate, this.offset);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset standardOffset = delegate.getOffset(scaffoldGeometry);
    return Offset(standardOffset.dx + offset.dx, standardOffset.dy + offset.dy);
  }

  @override
  String toString() => '$delegate with offset $offset';
}
