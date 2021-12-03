import 'dart:math';

import 'database/word.dart';
import 'global.dart';

enum QuestionType {
  askDefinition,
  askWord,
}

class Question {
  final QuestionType type;
  final Word word;

  static const _blank = '___';

  Question(this.word, this.type);

  Question.random(this.word)
      : type =
            QuestionType.values[Random().nextInt(QuestionType.values.length)];

  /// the question sentence to be shown to the user
  String get question {
    switch (type) {
      case QuestionType.askDefinition:
        return 'What is the definition of';
      case QuestionType.askWord:
        return 'Fill in the blanks in the following sentence.';
      default:
        return '<unknown question type>';
    }
  }

  String get blankfiedEx {
    return _blankify(word.ex, word.name);
  }

  /// Replace `term`(s) in `sentence` with `blank`
  ///
  /// If a term is a single word, then every occurrence is replaced.
  /// Otherwise, only one occurrence is applied whose end-to-end distance
  /// is the shortest. The end-to-end distance is (endIndex - beginIndex) of
  /// the term when the sentence is split into words.
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
  ///   incorrectly blankified example = '__ a __ journey ends, Jenny falls asleep __ long as possible.'
  ///   explanation: There are two occurrences of `as long as`.
  ///                The first one has the end-to-end distance 8-0=8.
  ///                The second one has the end-to-end distance 10-8=2.
  ///                Thus, the second occurrence was chosen.
  ///
  /// TODO: deal with past tenses
  ///       e.g) name: turn the tables on
  ///            ex: Wow, they really turned the tables on their opponents after the intermission.
  String _blankify(String sentence, String term, {String blank = _blank}) {
    // split by spaces
    final List<String> sentenceSplitted = sentence.split(' ');
    final List<String> termSplitted = term.split(' ');

    // map each word to an integer
    // and convert term into integer representation
    final Map<String, int> wordMap = {};
    final List<int> termConverted = [];
    for (String word in termSplitted) {
      String wordEscaped = Global.removeSpecials(word);
      if (!wordMap.containsKey(wordEscaped)) {
        wordMap[wordEscaped] = wordMap.length;
      }
      termConverted.add(wordMap[wordEscaped]!);
    }

    // convert example sentence into integer list
    final List<int> sentenceConverted = [];
    final List<int> sentenceIndices = [];
    for (int i = 0; i < sentenceSplitted.length; i++) {
      String word = sentenceSplitted[i];
      String wordEscapedLowered = Global.removeSpecials(word).toLowerCase();
      if (wordMap.containsKey(wordEscapedLowered)) {
        sentenceIndices.add(i);
        sentenceConverted.add(wordMap[wordEscapedLowered]!);
      }
    }

    // find matching patterns
    final List<int> patternIndices =
        _findPattern(sentenceConverted, termConverted);

    // select occurrence(s) to be blankifed
    if (termSplitted.length == 1) {
      // blankify every occurrences
      for (int i = 0; i < sentenceSplitted.length; i++) {
        String word = sentenceSplitted[i];
        String wordEscaped = Global.removeSpecials(word);
        if (wordMap.containsKey(wordEscaped)) {
          sentenceSplitted[i] = word.replaceFirst(RegExp(wordEscaped), blank);
        }
      }
    } else {
      // blankify only one occurrence which has the minimum end-to-end distance in index
      int minDist = sentenceConverted.length;
      final List<int> selectedIndices = [];
      for (int index in patternIndices) {
        // distance test
        int beginIndex = sentenceIndices[index];
        int endIndex = sentenceIndices[index + termSplitted.length - 1];
        int distance = endIndex - beginIndex;
        if (distance < minDist) {
          //-- new pattern with shorter distance found --//
          // select the new pattern
          minDist = distance;
          selectedIndices.clear();
          for (int i = 0; i < termSplitted.length; i++) {
            selectedIndices.add(sentenceIndices[index + i]);
          }
        }
      }

      // replace the words at the selected indices with blanks
      for (int index in selectedIndices) {
        String word = sentenceSplitted[index];
        String wordEscaped = Global.removeSpecials(word);
        sentenceSplitted[index] = word.replaceFirst(RegExp(wordEscaped), blank);
      }
    }

    // concatenate the blankified words
    return sentenceSplitted.join(' ');
  }

  /// Find all occurrences of `pattern` in `target`.
  /// return the indices at which the pattern matches
  ///
  /// It uses Knuth-Morris-Pratt Algorithm.
  List<int> _findPattern(List target, List pattern) {
    // compute the length of the longest `proper` prefix which is also suffix
    final List<int> lps = List.filled(pattern.length, 0);
    for (int i = 1, j = 0; i < pattern.length;) {
      if (pattern[j] == pattern[i]) {
        lps[i++] = ++j;
      } else {
        if (j > 0) {
          j = lps[j - 1];
        } else {
          lps[i++] = 0;
        }
      }
    }

    // pattern finding
    final List<int> patternIndices = [];
    for (int i = 0, j = 0; i < target.length;) {
      if (target[i] == pattern[j]) {
        i++;
        j++;

        if (j == pattern.length) {
          patternIndices.add(i - pattern.length);
          j = lps[j - 1];
        }
      } else if (j > 0) {
        j = lps[j - 1];
      } else {
        i++;
      }
    }

    return patternIndices;
  }
}
