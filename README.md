hangman
=======

## Required

```sh
gem install rb-libsvm
```

## USAGE

```ruby
# new a game
game = HangMan::Game.new

# add guess strategy to game
# about avaliable strategy, see below
game.add_analysiser(HangMan::SubAnalysiser::HeadAnalysiser.new)

# play a game
# will guess for 80 word once
game.play

# you can set Analysis option to analysis before play, by if you add svm analysiser, time will be 1~2 hours
# game.play(analysis: true)

# get result of a game
game.get_result

# submit to server
game.submit
```

### Avaliable strategy

| Class | Description |
|-------|-------------|
| GlobalAnalysiser | using frequency of letters |
| HeadAnalysiser | using frequency of first letter |
| TailAnalysiser | using frequency of last letter |
| RelationAnalysiser | using relationship with the letter before |
| ReverseRelationAnalysiser | using relationship with next letter |
| SvmAnalysiser | using svm model |

## What I did

### 1. Using Common Language Source

* Get a word frequency source [here](http://www.wordfrequency.info/100k_samples.asp).
* Store word frequency source as 100k_samples.pure file as a library.
* Compute letter frequency and stored them in yaml.

### 2. Try to Fit HangMan Database

* Guess with global frequence of letters.
* If got the a word was guessed, append the word to library 100k_samples.pure

### 3. Using Multi Strategy

* Using Global Letter Frequency.
* Using frequency of first letter.
* Using frequency of last letter.
* Using relationship with the letter before.
* Using relationship with next letter.

### 4. Using svm model

* Logging history guess
* Generate training set
  - dimension 1: word length
  - dimendion 2 ~ 27: letter correct?(1: correct, -1: wrong, 0: not choosed)
  - label: correct guess or not
* Using libsvm to train model
* Using model to predict
