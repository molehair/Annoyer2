import 'package:annoyer/database/dictionary.dart';
import 'package:annoyer/database/word.dart';
import 'package:annoyer/global.dart';
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
  bool _selectionMode = false;
  final Set<Word> _selections = {};
  final TextEditingController _searchController = TextEditingController();
  final List<Word> words = [];

  void _enableSelectionMode(Word? initialSelection) {
    // clear the previous selections
    _selections.clear();

    // add the initial selection
    if (initialSelection != null) {
      _selections.add(initialSelection);
    }
    setState(() {
      _selectionMode = true;
    });
  }

  void _disableSelectionMode() {
    setState(() {
      _selectionMode = false;
    });
  }

  Future<void> _deleteWords() async {
    return widget.box.deleteAll(_selections.map((word) => word.key));
  }

  /// If `value` is true, then `word` is selected.
  /// If `value` is false, then `word` is deselected.
  /// If `value` is null, then toggle the selection state of `word`.
  void _updateSelection(Word word, bool? selected) {
    if (selected == null) {
      if (_selections.contains(word)) {
        _selections.remove(word);
      } else {
        _selections.add(word);
      }
    } else if (selected) {
      _selections.add(word);
    } else {
      _selections.remove(word);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // clear outdated words
    words.clear();

    return ValueListenableBuilder(
      valueListenable: widget.box.listenable(),
      builder: (context, Box<Word> box, widget) {
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

        // floating buttons
        Widget floatingActionButtons;
        if (_selectionMode) {
          floatingActionButtons = Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  if (_selections.length == words.length) {
                    // deselect all
                    _selections.clear();
                  } else {
                    // select all
                    _selections.addAll(words);
                  }
                  setState(() {});
                },
                child: const Icon(Icons.select_all_outlined),
                heroTag: null,
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                onPressed: () async {
                  await _deleteWords();
                  _disableSelectionMode();
                  Global.showSuccess();
                },
                child: const Icon(Icons.delete_outlined),
                heroTag: null,
              ),
            ],
          );
        } else {
          floatingActionButtons = FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WordPage(createMode: true),
              ),
            ),
            child: const Icon(Icons.add),
            heroTag: null,
          );
        }

        // title
        String title;
        if (_selectionMode) {
          // number of selected words
          title = AppLocalizations.of(context)!
              .wordsSelected
              .replaceFirst('\$', _selections.length.toString());
        } else {
          // number of total words
          title = AppLocalizations.of(context)!
              .totalNumWords
              .replaceFirst('\$', words.length.toString());
        }

        return WillPopScope(
          onWillPop: () {
            if (_searchMode || _selectionMode) {
              // If in search or selection mode,
              // go back to non-search mode, not exit app.
              setState(() {
                _searchMode = _selectionMode = false;
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
                      title,
                      textAlign: TextAlign.center,
                    ),
                    dense: true,
                  );
                } else {
                  //-- data --//
                  // exclude "total" item
                  index--;

                  Word word = words[index];
                  bool idiom = word.name.trim().contains(' ');
                  Widget leading;
                  if (_selectionMode) {
                    leading = Checkbox(
                      value: _selections.contains(word),
                      onChanged: (bool? value) => _updateSelection(word, value),
                    );
                  } else {
                    leading = CircleAvatar(
                      child: Text(
                        idiom ? 'Idiom' : 'Word',
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor:
                          idiom ? Theme.of(context).secondaryHeaderColor : null,
                    );
                  }
                  widget = Card(
                    child: ListTile(
                      leading: leading,
                      title: Text(word.name),
                      // subtitle: Text(word.ex),
                      onTap: () {
                        if (_selectionMode) {
                          _updateSelection(word, null);
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WordPage(
                                createMode: false,
                                storeKey: word.key,
                                word: word,
                              ),
                            ),
                          );
                        }
                      },
                      onLongPress: () => _enableSelectionMode(word),
                    ),
                  );
                }
                return widget;
              },
            ),
            floatingActionButton: floatingActionButtons,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
