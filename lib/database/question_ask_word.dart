import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:annoyer/database/question.dart';
import 'package:annoyer/database/word.dart';

class QuestionAskWord extends Question {
  //---------------------------------------------------------------//
  //        instance variables
  //---------------------------------------------------------------//
  String? usersAnswer; // the name of the word chosen by user

  //---------------------------------------------------------------//
  //        static variables
  //---------------------------------------------------------------//

  static const blank = '___';

  //---------------------------------------------------------------//
  //        exported methods
  //---------------------------------------------------------------//

  QuestionAskWord(int index, Word word, QuestionType type)
      : super(index, word, type);

  @override
  QuestionAskWord.fromMap(Map<String, Object?> map)
      : usersAnswer = map['usersAnswer'] as String?,
        super.fromMap(map);

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> map = super.toMap();
    if (usersAnswer != null) {
      map['usersAnswer'] = usersAnswer;
    }
    return map;
  }

  @override
  QuestionAskWord.fromJson(String jsonString)
      : this.fromMap(jsonDecode(jsonString));

  @override
  String toJson() {
    return jsonEncode(toMap());
  }

  String get blankfiedEx {
    return blankify(word.ex, word.name);
  }

  /// Replace `term`(s) in `sentence` with `blank`
  ///
  /// If a term is a single word, then every occurrence is replaced.
  /// Otherwise, at most one occurrence is applied whose end-to-end distance,
  /// (endIndex - beginIndex) of the term, is the shortest.
  ///
  /// example 1
  ///   sentence = 'He pushed the door again and again.'
  ///   term = 'again'
  ///   correctly blankified example = 'He pushed the door __ and __.'
  ///   incorrectly blankified example = 'He pushed the door __ and again.'
  ///
  /// example 2
  ///   sentence = 'As a long journey ends, Jenny falls asleep as long as possible.'
  ///   term = 'as long as'
  ///   correctly blankified example = 'As a long journey ends, Jenny falls asleep __ __ __ possible.'
  ///   explanation: Among the following four possible candidates,
  ///                the correct answer above reveals the shortest end-to-end distance.
  ///                   '__ a __ journey ends, Jenny falls asleep __ long as possible.'
  ///                   '__ a __ journey ends, Jenny falls asleep as long __ possible.'
  ///                   '__ a long journey ends, Jenny falls asleep as __ __ possible.'
  ///                   'As a long journey ends, Jenny falls asleep __ __ __ possible.'
  static String blankify(String sentence, String term, {String blank = blank}) {
    // split the term
    List<String> splittedTerms = [];
    for (var t in term.split(' ')) {
      t = t.trim();
      if (t.isNotEmpty) {
        splittedTerms.add(t.toLowerCase());
      }
    }

    // Find all beginning indices and length of matching words
    List<List<int>> allMatchingIndices = [];
    List<List<int>> allMatchingLengths = [];
    for (var splittedTerm in splittedTerms) {
      // Create {index: len} for single term
      var matchingBeginIndicesMap = SplayTreeMap<int, int>();
      for (var variant in _getVariantsOf(splittedTerm)) {
        var I = _findMatchingBeginIndices(sentence, variant);
        int l = variant.length;
        for (int i in I) {
          matchingBeginIndicesMap[i] = matchingBeginIndicesMap.containsKey(i)
              ? max(matchingBeginIndicesMap[i]!, l)
              : l;
        }
      }

      // pack in acending order
      List<int> matchingIndices = [];
      List<int> matchingLengths = [];
      for (var entry in matchingBeginIndicesMap.entries) {
        matchingIndices.add(entry.key);
        matchingLengths.add(entry.value);
      }
      allMatchingIndices.add(matchingIndices);
      allMatchingLengths.add(matchingLengths);
    }

    // generate blankified sentence
    String blankified;
    int n = allMatchingIndices.length;
    if (n == 1) {
      //-- single-word term --//
      blankified = _blankifyRanges(
        sentence,
        allMatchingIndices[0],
        allMatchingLengths[0],
        blank,
      );
    } else {
      //-- multi-word term --//

      // find (i1, .. , in) such that
      // i1 < .. < in, and
      // all words indicated by i1, .., in are distinct
      List<int> I = List<int>.generate(n, (index) => 0);
      List<int> minI = List<int>.generate(n, (index) => -1);
      int minDist = sentence.length + 1;
      while (I[0] < allMatchingIndices[0].length) {
        // sentence[k..] is considered for I[j]
        int k = 0;

        // fix i1, .. , in (candidate set)
        int j = 0;
        while (j < n && I[j] < allMatchingIndices[j].length) {
          // range: [begin, end)
          var begin = allMatchingIndices[j][I[j]];
          var len = allMatchingLengths[j][I[j]];

          if (k <= begin) {
            // found a blank candidate
            j++;
            k = begin + len;
          } else {
            // overlaps with previously blanked word
            // hence, check the next range
            I[j]++;
          }
        }

        if (j == n) {
          // found a candidate set I
          int dist = allMatchingIndices[n - 1][I[n - 1]] +
              allMatchingLengths[n - 1][I[n - 1]] -
              allMatchingIndices[0][I[0]];
          if (dist < minDist) {
            // found new word sets to be blanked whose distance is shorter
            minI = List<int>.from(I);
            minDist = dist;
          }
        } else {
          // no more candidate set exists
          break;
        }

        // try to catch the next set
        I[0]++;
      }

      // blankify
      if (minDist <= sentence.length) {
        var matchingIndices = List<int>.generate(
          n,
          (index) => allMatchingIndices[index][minI[index]],
        );
        var matchingLengths = List<int>.generate(
          n,
          (index) => allMatchingLengths[index][minI[index]],
        );

        blankified = _blankifyRanges(
          sentence,
          matchingIndices,
          matchingLengths,
          blank,
        );
      } else {
        blankified = sentence;
      }
    }

    return blankified;
  }

  //---------------------------------------------------------------//
  //        internal methods
  //---------------------------------------------------------------//

  /// Given a word without space included, return its all variants.
  /// Some variants may make non-sense linguistically.
  ///
  /// example: drop -> [dropped, droped, drops, droply, ...]
  static List<String> _getVariantsOf(String word) {
    int n = word.length;
    return [
      word,

      // past tense 1 (e.g. turn -> turned)
      word + 'ed',

      // past tense 2 (e.g. liked -> like)
      word + 'd',

      // past tense 3 (e.g. prop -> propped)
      word + word[n - 1] + 'ed',

      // past tense 4 (e.g. study -> studied)
      word.substring(0, n - 1) + 'ied',

      // present participle 1 (e.g. study -> studying)
      word + 'ing',

      // present participle 2 (e.g. like -> liking)
      word.substring(0, n - 1) + 'ing',

      // present participle 3 (e.g. drop -> dropping)
      word + word[n - 1] + 'ing',

      // plural 1 (e.g. apple -> apples)
      word + 's',

      // plural 2 (e.g. box -> boxes)
      word + 'es',

      // adverbs 1 (e.g. abrupt -> abruptly)
      word + 'ly',

      // adverbs 2 (e.g. heavy -> heavily)
      word.substring(0, n - 1) + 'ily',
    ];
  }

  /// Find all occurrences of [word] in [sentence]
  /// Return: the starting indices of each matching in [sentence]
  static List<int> _findMatchingBeginIndices(String sentence, String word) {
    //-- Z algorithm --//

    String lowerSentence = sentence.toLowerCase();
    String s = word + '\x80' + lowerSentence;
    int n = s.length;
    List<int> Z = List.filled(n, 0);
    int L = 0, R = -1;

    for (int i = 1; i < n; i++) {
      int j = R < i ? 0 : min(Z[i - L], R - i + 1);
      int k = i + j;
      while (k < n && s[j] == s[k]) {
        j++;
        k++;
      }
      Z[i] = j;
      if (R < k - 1) {
        L = i;
        R = k - 1;
      }
    }

    // gather beginning indices of occurrences
    List<int> indices = [];
    int m = word.length;
    for (int i = m + 1; i < n; i++) {
      if (Z[i] == m) {
        int j = i - (m + 1);

        // is beginning of a word?
        if (j == 0 ||
            lowerSentence[j - 1].compareTo('a') < 0 ||
            lowerSentence[j - 1].compareTo('z') > 0) {
          indices.add(j);
        }
      }
    }

    return indices;
  }

  /// Replace every sentence[begin, begin+len) with [blank]
  static String _blankifyRanges(
    String sentence,
    List<int> indices,
    List<int> lengths,
    String blank,
  ) {
    int i = 0;
    String blankified = '';
    int n = indices.length;
    for (int j = 0; j < n; j++) {
      blankified += sentence.substring(i, indices[j]) + blank;
      i = indices[j] + lengths[j];
    }
    blankified += sentence.substring(i);

    return blankified;
  }
}
