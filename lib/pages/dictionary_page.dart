import 'package:annoyer/database/dictionary.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/pages/word_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DictionaryPage extends StatelessWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox<Word>(Dictionary.boxName),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Text('SomethingWentWrong();');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return _DictionaryPageMain(box: snapshot.data as Box<Word>);
        }

        return const Text('Loading...');
      },
    );
  }
}

class _DictionaryPageMain extends StatefulWidget {
  const _DictionaryPageMain({
    Key? key,
    required this.box,
  }) : super(key: key);

  final Box<Word> box;

  @override
  __DictionaryPageMainState createState() => __DictionaryPageMainState();
}

class __DictionaryPageMainState extends State<_DictionaryPageMain> {
  final List<Word> dictionary = [];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.box.listenable(),
      builder: (context, Box<Word> box, widget) {
        // clean up the previous list
        dictionary.clear();

        // add the current ones
        for (int key in box.keys) {
          Word word = box.get(key)!;
          word.key = key;
          dictionary.add(word);
        }
        return Scaffold(
          appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.dictionary),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.search,
                      size: 26.0,
                    ),
                  ),
                ),
              ]),
          body: ListView.builder(
            itemCount: dictionary.length + 1,
            itemBuilder: (context, index) {
              Widget widget;
              if (index == 0) {
                //-- header --//
                widget = ListTile(
                  title: Text(
                    'Total ${dictionary.length} word' +
                        (dictionary.length > 1 ? 's' : ''),
                    textAlign: TextAlign.center,
                  ),
                  dense: true,
                );
              } else {
                //-- data --//
                index--;
                Word word = dictionary[index];
                widget = Card(
                  child: ListTile(
                    title: Text(word.name),
                    subtitle: Text(word.ex),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WordPage(
                          createMode: false,
                          storeKey: word.key,
                          word: word,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return widget;
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WordPage(createMode: true),
              ),
            ),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
