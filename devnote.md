- todo
  - notification
    - On tapping consolidated notifications?
  - conceive a way of revisiting practice and test
  - training system
    - introduce training id
    - check if validation date is properly set(currently it seems wrong)
  - log system
  - suppress 'Not found' on ask word page when typing
    - It seems the plugin must be replaced.
  - animation
  - word/idiom auto complete with dictionary APIs
    - offline dictionary
      - https://github.com/wordset/wordset-dictionary
  - reschedule again after reboot
    - user need to fire the app once for scheduling for now

- considerations
  - training system
    - set the training time range instead of starting time
    - let the user adjust details such as # of words a day and so on too?
  - index
    - delete non-fulltext mode?
    - in full text mode, delete all whitespaces and put the word into the trie
      - but this will prevent searching `go up against` by `gua`
  - show level on dictionary, practice and test page?
  
    

- server considerations
  - precedence on managing synchronized devices?
    - If the precedence exists, which one should be? the first device or mobile one?
  - use websocket for real time update
  - which DB?
  - go or java?
  - docker

- to check

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

// tmp

- server db
  - users
    - uid
    - email: string
    - name: string
  - dictionary
    - wid       // word id
    - name: string
    - def: string
    - ex: string
    - mnemonic: string
    - level: int >=1
    - author: (*uid* in *users*)
