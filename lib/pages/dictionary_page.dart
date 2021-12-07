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

class __DictionaryPageMainState extends State<_DictionaryPageMain>
    with AutomaticKeepAliveClientMixin {
  bool _searchMode = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: widget.box.listenable(),
      builder: (context, Box<Word> box, widget) {
        List<Word> words = [];

        // prepare list to show depending on the search mode
        Iterable<dynamic> keys = _searchMode
            ? Dictionary.nameIndex.search(_searchController.text.trim())
            : box.keys;

        // fetch word info
        for (int key in keys) {
          Word word = box.get(key)!;
          word.key = key;
          words.add(word);
        }

        // sort
        words.sort((Word word1, Word word2) =>
            word1.name.toLowerCase().compareTo(word2.name.toLowerCase()));

        return WillPopScope(
          onWillPop: () {
            if (_searchMode) {
              // if in search mode, go back to non-search mode, not exit app
              setState(() {
                _searchMode = false;
              });
              return Future.value(false);
            } else {
              // not in search mode: normal exit
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
                leading: _searchMode
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_outlined),
                        onPressed: () => setState(() {
                          _searchMode = false;
                        }),
                      )
                    : null,
                title: _searchMode
                    ? TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (_) => setState(() {}),
                        // decoration: InputDecoration(
                        //   fillColor: Colors.white,
                        //   // fillColor: Theme.of(context).backgroundColor,
                        // ),
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white))
                    : Text(AppLocalizations.of(context)!.dictionary),
                actions: <Widget>[
                  _searchMode
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 26.0),
                          onPressed: () => setState(() {
                            _searchController.clear();
                          }),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search, size: 26.0),
                          onPressed: () => setState(() {
                            _searchMode = true;
                          }),
                        ),
                ]),
            body: ListView.builder(
              itemCount: words.length + 1,
              itemBuilder: (context, index) {
                Widget widget;
                if (index == 0) {
                  //-- header --//
                  widget = ListTile(
                    title: Text(
                      AppLocalizations.of(context)!
                          .totalNumWords
                          .replaceFirst('\$', words.length.toString()),
                      textAlign: TextAlign.center,
                    ),
                    dense: true,
                  );
                } else {
                  //-- data --//
                  index--;
                  Word word = words[index];
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
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
