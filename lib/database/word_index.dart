import 'package:annoyer/global.dart';

/// A trie which index a list of sentences for faster search
/// Each node is reachable by a string.
/// The type of the satellite value is T.
class WordIndex<T> {
  WordIndex({this.fullTextMode = false});

  /// If true, a word in a sentence matches even with a non-prefix of the word
  /// Example: The word 'google' is found by 'oog' only if fullTextMode is true.
  final bool fullTextMode;

  final _IndexNode<T> _root = _IndexNode<T>('');

  /// add an entry
  ///
  /// key: a word or a sentence to be indexed
  ///
  /// value: a satellite data bind to the key
  void add(String key, T value) {
    // split key into words with preprocesses
    List<String> keySplitted = _splitKey(key);

    // for each word
    for (String word in keySplitted) {
      // pass empty string
      if (word == '') continue;

      // add
      _root.add(word, 0, value);

      // add even more if full text mode
      if (fullTextMode) {
        for (int i = 1; i < word.length; i++) {
          _root.add(word, i, value);
        }
      }
    }
  }

  /// remove all nodes by a value
  void removeByValue(T value) {
    _root.removeByValue(value);
  }

  /// Search a key throughout the trie and return the value
  ///
  /// For a key consisting of more than one word, a value in the trie is found
  /// if and only if every word reaches to a node with the value. That is,
  /// a whitespace between two words works like AND operation.
  Set<T> search(String key) {
    // split key into words with preprocesses
    List<String> keySplitted = _splitKey(key);

    // search for the first word
    Set<T> values = _root.search(keySplitted[0], 0);

    // search for the rest
    for (int i = 1; i < keySplitted.length; i++) {
      Set<T> additionalValues = _root.search(keySplitted[i], 0);
      values = values.intersection(additionalValues);
    }

    return values;
  }

  /// Empty the entire data
  void clear() {
    // unlink the root and let the garbage collector does the job
    _root._children.clear();
  }

  /// split key into words with
  /// 1. removing special characters
  /// 2. lowering cases, and
  /// 3. removing empty strings
  List<String> _splitKey(String key) {
    return Global.removeSpecials(key)
        .toLowerCase()
        .replaceAll('  ', ' ')
        .split(' ');
  }
}

// possibly heavy implementation..
// Use a primitive data structure if it turns out heavy.
class _IndexNode<T> {
  _IndexNode(this.key);

  final String key;
  final Map<String, _IndexNode<T>> _children = {};
  final Set<T> _values = {};

  /// add (word[i..], value) pair to the children recursively
  void add(String word, int i, T value) {
    // finished?
    if (i < word.length) {
      String nextKey = word[i];

      // Get the child or create one
      _IndexNode<T>? child = _children[nextKey];
      child ??= _children[nextKey] = _IndexNode<T>(nextKey);

      // adding..
      child._values.add(value);

      // do the rest
      child.add(word, i + 1, value);
    }
  }

  /// Remove all values in the children.
  /// The current node will not be modified.
  void removeByValue(T value) {
    // If current node contains value, it means that
    // the children also can have value in themselves.
    List<String> toDetach = [];
    for (_IndexNode<T> child in _children.values) {
      if (child._values.contains(value)) {
        // eliminate the value from a child
        child._values.remove(value);

        if (child._values.isEmpty) {
          // if the child has no information anymore, detach it
          // and let the garbage collector dispose of it
          toDetach.add(child.key);
        } else {
          // go deeper recursively
          child.removeByValue(value);
        }
      }
    }

    // detach outside the loop
    for (String key in toDetach) {
      _children.remove(key);
    }
  }

  /// get the values for word[i..] from the children recursively
  Set<T> search(String word, int i) {
    // finished?
    if (i < word.length) {
      String nextKey = word[i];

      // Get the child
      _IndexNode<T>? child = _children[nextKey];

      // search down only if there exist the child
      if (child != null) {
        return child.search(word, i + 1);
      } else {
        // not found
        return {};
      }
    } else {
      // found
      return _values;
    }
  }
}
