- bugs
  - search and modifying a term doesn't display right after the operation, although it did actually.
  - Modifying a term doesn't show up right after the change, sometimes.
  
- todo
  - animation
  - documentation
  - firestore if sync over web is planned
  
- training system
  - alarm interval : I
  - num. of words a day : n
  - num. of repetitions a word : m
  - num. of terms an alarm : k
  - num. of alarms per day : A = ceil(mn/k)+1
  - total time : L = I*(A-1)
  - The chosen words on a day are distinct.
  - If the total number of words is less than n, then always choose all of them.
  
- level system
  - Every word has a level(positive integer).
  - The initial and the minimum level is 1.
  - When the user correctly answers the quiz pertaining to a word, its level increases, while it decreases when he or she fails.


- done
  - Change notification system from push to local
  - Discarding notification when a training instance is opened
  - Introduced file-based log
  - Replaced time picker with the original one
  - Word/idiom auto complete with dictionary APIs
    - https://github.com/fluhus/wordnet-to-json
  - Showing level for each word on dictionary page
  - Improved blankification.
  - More clear expression of correctness on test