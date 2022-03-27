import 'package:annoyer/database/word.dart';
import 'package:annoyer/global.dart';
import 'package:annoyer/i18n/strings.g.dart';
import 'package:annoyer/pages/word_page.dart';
import 'package:flutter/material.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage>
    with AutomaticKeepAliveClientMixin {
  // mode flags
  bool _searchMode = false;
  bool _selectionMode = false;

  final TextEditingController _searchController = TextEditingController();

  final Set<int> _selectedIds = {};
  List<Word> _allWords = [];
  final List<Word> _searchWords = [];

  @override
  void initState() {
    // set change listeners
    Word.getStream().listen(_onWordChange);
    _searchController.addListener(_onSearchTextChange);

    // initial refresh
    _onWordChange();

    super.initState();
  }

  /// update all words
  void _onWordChange([_]) async {
    _allWords = await Word.getAll();
    _allWords.sort((a, b) => (a.name.compareTo(b.name)));
    if (mounted) {
      setState(() {});
    }
  }

  /// update word list on searching
  void _onSearchTextChange() async {
    var ids = Word.nameIndex.search(_searchController.text.trim());
    var wordsBeforeValid = await Word.gets(ids);
    _searchWords.clear();
    for (Word? word in wordsBeforeValid) {
      if (word != null) {
        _searchWords.add(word);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _enableSelectionMode(Word? initialSelection) {
    // clear the previous selections
    _selectedIds.clear();

    // add the initial selection
    if (initialSelection != null) {
      _selectedIds.add(initialSelection.id!);
    }
    setState(() {
      _selectionMode = true;
    });
  }

  void _disableSelectionMode() {
    _selectedIds.clear();
    setState(() {
      _selectionMode = false;
    });
  }

  /// If [selected] is true, then `word` is selected.
  /// If [selected] is false, then `word` is deselected.
  /// If [selected] is null, then toggle the selection state of `word`.
  void _updateSelection(Word word, bool? selected) {
    int id = word.id!;
    if (selected == null) {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    } else if (selected) {
      _selectedIds.add(id);
    } else {
      _selectedIds.remove(id);
    }
    setState(() {});
  }

  /// Delete selected words
  Future<void> _deleteWords() {
    return Word.deletes(_selectedIds);
  }

  void _enableSearchMode() {
    setState(() {
      _searchMode = true;
    });
  }

  void _disableSearchMode() {
    setState(() {
      _searchMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // determine word list to display
    List<Word> words = _searchMode ? _searchWords : _allWords;

    // floating buttons
    Widget floatingActionButtons;
    if (_selectionMode) {
      floatingActionButtons = Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (_selectedIds.length == words.length) {
                // deselect all
                _selectedIds.clear();
              } else {
                // select all
                _selectedIds.addAll(words.map((e) => e.id!));
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

    // wordCount
    String wordCount = _selectionMode
        ?
        // number of selected words
        t.wordsSelected(count: _selectedIds.length)
        :
        // number of total words
        t.totalNumWords(count: words.length);

    return WillPopScope(
      onWillPop: () {
        if (_searchMode || _selectionMode) {
          // If in search or selection mode,
          // go back to non-search mode, not exit app.
          _disableSearchMode();
          _disableSelectionMode();
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
                    onPressed: _disableSearchMode,
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
                : Text(t.dictionary),
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
                      onPressed: _enableSearchMode,
                    ),
            ]),
        body: ListView.builder(
          itemCount: words.length + 1,
          itemBuilder: (context, index) {
            Widget widget;
            if (index == 0) {
              //-- header --//
              widget = ListTile(
                title: Text(wordCount, textAlign: TextAlign.center),
                dense: true,
              );
            } else {
              //-- data --//
              // exclude title tile
              index--;

              Word word = words[index];
              bool idiom = word.name.trim().contains(' ');
              Widget leading;
              if (_selectionMode) {
                leading = Checkbox(
                  value: _selectedIds.contains(word.id!),
                  onChanged: (bool? value) => _updateSelection(word, value),
                );
              } else {
                leading = CircleAvatar(
                  child: Text(
                    idiom ? t.idiom : t.word,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor:
                      idiom ? Theme.of(context).secondaryHeaderColor : null,
                );
              }
              widget = ListTile(
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
                          word: word,
                        ),
                      ),
                    );
                  }
                },
                onLongPress: () => _enableSelectionMode(word),
              );
            }
            return widget;
          },
        ),
        floatingActionButton: floatingActionButtons,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
