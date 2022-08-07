import 'package:annoyer/database/training_instance.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/training.dart';
import 'package:flutter/material.dart';

import 'practice_page.dart';
import 'test_page.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  List<TrainingInstance> insts = [];

  @override
  void initState() {
    // add listeners
    TrainingInstance.getStream().listen(_onInstanceUpdate);

    // initial refresh
    _refresh();

    super.initState();
  }

  void _onInstanceUpdate(_) {
    _refresh();
  }

  _refresh() async {
    insts = await TrainingInstance.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.training)),
      body: ListView.builder(
        itemCount: insts.length,
        itemBuilder: (context, index) {
          var inst = insts[index];
          Widget title;
          Widget? subtitle;
          void Function() onTap;
          if (Training.isPractice(inst.trainingIndex)) {
            title = Text(PracticePage.getTitle(inst.trainingIndex));
            subtitle = Text(TestPage.getTitle(inst.trainingId));
            onTap = () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => PracticePage(inst: inst)),
                );
          } else {
            title = Text(TestPage.getTitle(inst.trainingId));
            subtitle = null;
            onTap = () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          TestPage(trainingId: inst.trainingId)),
                );
          }

          return ListTile(
            title: title,
            subtitle: subtitle,
            leading: const Icon(Icons.sms_outlined),
            onTap: onTap,
          );
        },
      ),
    );
  }
}
