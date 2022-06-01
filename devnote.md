- bugs
  - blankify not working
    - sentence: Send an email before dropping by a professor.
    - idiom: drop by
  - blankify not working
    - sentence: She propped her chin in the palm of her right hand.
    - word: prop
  - blankify not working after altering idiom
    - sentence: The place was filled with sleeping people. I tripped over perfect strangers on my way to the door.
    - idiom: trip on -> trip over
  - blankify not working
    - sentence: I'm exhausted after lugging these suitcases all the way across the city.
    - word: lug
  - search and modifying a term doesn't display right after the operation, although it did actually.
  
- todo
  - notification
    - On tapping consolidated notifications?
    - When practice/test instance is resolved, remove the corresponding notification.
  - documentation
  - Replace widgets with better ones
    - flutter_typeahead (During the loading, only 'not found' is shown)
    - day_night_time_picker (unhandy.. better to get it back to the original one)
      - https://pub.dev/packages/time_picker_widget
      - https://api.flutter.dev/flutter/cupertino/CupertinoDatePicker-class.html
  - animation
  - In ask word widget, display the correct/wrong clearly as askDef widget does. Show the target word like askDef does?
  - replace all 'loading' with CircularProgressIndicator
  - word/idiom auto complete with dictionary APIs
    - offline dictionary
      - https://github.com/wordset/wordset-dictionary
  - reschedule the training as timezone changes
  
- considerations
  - index
    - delete non-fulltext mode?
    - in full text mode, delete all whitespaces and put the word into the trie
      - but this will prevent searching `go up against` by `gua`
  - show level on dictionary, practice and test page?
  
- client db
  - training_data
  - practice_instances
  - test_instances
  - settings
  
- server db
  - words
  - users
  
- training system

  - total time : L
  - num. of words a day : n
  - num. of repetitions a word : m
  - num. of terms an alarm : k
  - num. of alarms per day: A = ceil(mn/k)
  - alarm interval : T = L / A
  - implementation
    - L = 8 hr, n = 16, m = k = 3 => A = 16, T = 0.5 hr
  - The chosen words on a day are distinct.
  - If the total number of words is less than n, then always choose all of them.
  
- level system
  - Every word has a level(positive integer).
  - The initial and the minimum level is 1.
  - When the user correctly answers the quiz pertaining to a word, its level increases, while it decreases when he or she fails.
