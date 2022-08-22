- bugs
  - In ask-word question, wrong answer given by user doesn't show up
  - blankify
    - word: foster in
    - sentence: The professor hoped to foster a genuine interest in his students to pursue research.
    - expected: The professor hoped to __ a genuine interest __ his students to pursue research.
    - reality: The professor hoped to __ a genuine __terest in his students to pursue research.
  - When editing a word, check if the word name is one of predefined words.

- todo
  - Test scheduling after reboot. It didn't work on Monday.
  - Show the correct answer within the blank in ask-word test with color
  - prevent duplicates on suggestions in ask-word test
  - blankify example when touching it in practice page
  - removing circle in front of each selection in ask-def test
    - change colors of selections upon user's choice
  - warning..
w: Runtime JAR files in the classpath should have the same version. These files were found in the classpath:
    /home/j/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib-jdk8/1.5.30/5fd47535cc85f9e24996f939c2de6583991481b0/kotlin-stdlib-jdk8-1.5.30.jar (version 1.5)
    /home/j/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib-jdk7/1.6.21/568c1b78a8e17a4f35b31f0a74e2916095ed74c2/kotlin-stdlib-jdk7-1.6.21.jar (version 1.6)
    /home/j/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib/1.6.21/11ef67f1900634fd951bad28c53ec957fabbe5b8/kotlin-stdlib-1.6.21.jar (version 1.6)
    /home/j/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib-common/1.6.21/5e5b55c26dbc80372a920aef60eb774b714559b8/kotlin-stdlib-common-1.6.21.jar (version 1.6)
w: Some runtime JAR files in the classpath have an incompatible version. Consider removing them from the classpath

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
  - Better titles for practice and test
