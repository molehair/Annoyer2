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
  String _blankify(String sentence, String term, {String blank = _blank}) {
    // split by spaces
    final List<String> sentenceSplitted = sentence.split(' ');
    final List<String> termSplitted = term.split(' ');

    // Map each word to an integer and convert term into integer representation
    final Map<String, int> wordMap = {};
    final List<int> termConverted = [];
    for (String word in termSplitted) {
      String processedWord = _processWord(word);
      if (!wordMap.containsKey(processedWord)) {
        wordMap[processedWord] = wordMap.length;
      }
      termConverted.add(wordMap[processedWord]!);
    }

    // convert example sentence into integer list
    final List<int> sentenceConverted = [];
    final List<int> sentenceIndices = [];
    for (int i = 0; i < sentenceSplitted.length; i++) {
      String word = sentenceSplitted[i];
      String processedWord = _processWord(word);
      String? matchedWord = _matchingWord(wordMap, processedWord);

      if (matchedWord != null) {
        // `word` or its one of variants matches a word in the map
        sentenceIndices.add(i);
        sentenceConverted.add(wordMap[matchedWord]!);
      }
    }

    // find matching patterns
    final List<int> patternIndices =
        _findPattern(sentenceConverted, termConverted);

    // select occurrence(s) to be blankifed
    final List<int> selectedIndices = [];
    if (termSplitted.length == 1) {
      // blankify every occurrences
      for (int index in patternIndices) {
        selectedIndices.add(sentenceIndices[index]);
      }
    } else {
      // blankify only one occurrence which has the minimum end-to-end distance
      int minDist = sentenceSplitted.length;
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
    }

    // replace the words at the selected indices with blanks
    for (int index in selectedIndices) {
      sentenceSplitted[index] = blank;
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

  /// Given a word,
  ///   1. remove all special characters
  ///   2. make it lower cases, and
  ///   3. trim it.
  String _processWord(String word) {
    return Global.removeSpecials(word).toLowerCase().trim();
  }

  /// Given a processed word and the word map generated from the term,
  /// check if the word is included the map.
  String? _matchingWord(Map<String, int> wordMap, String processedWord) {
    String matchedWord;

    // match as it is (e.g. pay -> pay)
    if (wordMap.containsKey(processedWord)) {
      return processedWord;
    }

    // past tense 1 (e.g. turned -> turn)
    if (processedWord.length > 2 && processedWord.endsWith('ed')) {
      matchedWord = processedWord.substring(0, processedWord.length - 2);
      if (wordMap.containsKey(matchedWord)) {
        return matchedWord;
      }
    }

    // past tense 2 (e.g. liked -> like)
    if (processedWord.length > 1 && processedWord.endsWith('d')) {
      matchedWord = processedWord.substring(0, processedWord.length - 1);
      if (wordMap.containsKey(matchedWord)) {
        return matchedWord;
      }
    }

    // present participle 1 (e.g. studying -> study)
    if (processedWord.length > 3 && processedWord.endsWith('ing')) {
      matchedWord = processedWord.substring(0, processedWord.length - 3);
      if (wordMap.containsKey(matchedWord)) {
        return matchedWord;
      }
    }

    // present participle 2 (e.g. liking -> like)
    if (processedWord.length > 3 && processedWord.endsWith('ing')) {
      matchedWord = processedWord.substring(0, processedWord.length - 3) + 'e';
      if (wordMap.containsKey(matchedWord)) {
        return matchedWord;
      }
    }

    // plural 1 (e.g. apples -> apple)
    if (processedWord.length > 1 && processedWord.endsWith('s')) {
      matchedWord = processedWord.substring(0, processedWord.length - 1);
      if (wordMap.containsKey(matchedWord)) {
        return matchedWord;
      }
    }

    // plural 2 (e.g. boxes -> box)
    if (processedWord.length > 2 && processedWord.endsWith('es')) {
      matchedWord = processedWord.substring(0, processedWord.length - 2);
      if (wordMap.containsKey(matchedWord)) {
        return matchedWord;
      }
    }
  }
}
