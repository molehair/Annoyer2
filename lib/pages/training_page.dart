import 'package:annoyer/database/practice_instance.dart';
import 'package:annoyer/database/question.dart';
import 'package:annoyer/database/test_instance.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:flutter/material.dart';

import 'practice_page.dart';
import 'test_page.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  List<PracticeInstance> _pracInsts = [];
  List<TestInstance> _testInsts = [];

  @override
  void initState() {
    // add listeners
    PracticeInstance.getStream().listen(_onInstanceUpdate);
    TestInstance.getStream().listen(_onInstanceUpdate);

    // initial refresh
    _refresh();

    super.initState();
  }

  void _onInstanceUpdate(_) {
    _refresh();
  }

  _refresh() async {
    _pracInsts = await PracticeInstance.getAll();
    _testInsts = await TestInstance.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.training)),
      body: ListView.builder(
        itemCount: _pracInsts.length + _testInsts.length,
        itemBuilder: (context, index) {
          if (index < _pracInsts.length) {
            //-- practice --//
            PracticeInstance inst = _pracInsts[index];
            return ListTile(
              title: Text('${t.practice} ${inst.dailyIndex}'),
              subtitle: Text('for the test ${inst.trainingId}'),
              leading: const Icon(Icons.sms_outlined),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PracticePage(inst: inst),
                  ),
                );
              },
            );
          } else {
            //-- test --//
            index -= _pracInsts.length;
            TestInstance inst = _testInsts[index];
            int finished = inst.questions
                .where((q) => q.state != QuestionState.intertermined)
                .length;
            return ListTile(
              title: Text('${t.test} ${inst.trainingId}'),
              subtitle: LinearProgressIndicator(
                value: finished / inst.questions.length,
              ),
              leading: const Icon(Icons.contact_support_outlined),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TestPage(inst: inst),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
