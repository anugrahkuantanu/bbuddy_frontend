import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/di/di.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bbuddy_app/features/reflection_app/services/service.dart';
import 'package:bbuddy_app/features/reflection_app/models/model.dart';
import 'package:bbuddy_app/features/reflection_app/blocs/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewReflectionResults extends StatelessWidget {
  final List topics;
  final List? userReflections;
  final Reflection? reflection;

  const ViewReflectionResults({
    Key? key,
    required this.topics,
    this.userReflections,
    this.reflection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterStats = Provider.of<CounterStats>(context, listen: false);

    return BlocProvider(
      create: (context) => ViewReflectionResultBloc(
          counterStats: counterStats,
          reflectionService: locator.get<ReflectionService>())
        ..add(LoadMoodReflectionsEvent(
          topics,
          userReflections,
          '',
          reflection,
        )),
      child: BlocBuilder<ViewReflectionResultBloc, ViewReflectionResultState>(
        builder: (context, state) {
          if (state is ReflectionResultLoadingState) {
            return const LoadingUI();
          } else if (state is ReflectionResultLoadedState) {
            final reflectionData = state.reflection;
            return _buildUI(context, reflectionData);
          } else if (state is ReflectionResultErrorState) {
            return const ErrorUI(errorMessage: 'An error occurred.');
          }
          return Container(); // Default empty state
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context, reflectionData) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          reflectionData.heading,
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.labelLarge!.color),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (reflection != null) {
              Navigator.pop(context);
            } else {
              Nav.toNamed(context, '/reflections');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reflectionData.topicReflections.length,
                  itemBuilder: (BuildContext context, int index) {
                    final reflection = reflectionData.topicReflections[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                ' ${reflection.topic}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 8),
                              if (reflection.humanInsight.content != '')
                                Text(
                                  '"' +
                                      '${reflection.humanInsight.content}' +
                                      '"',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF3C896D),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Column(
                                children: reflection.aiInsights
                                    .map<Widget>(
                                      (ai) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          '${ai.content}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
