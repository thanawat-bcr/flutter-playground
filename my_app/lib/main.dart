import 'package:flutter/material.dart';

import './quiz.dart';
import './result.dart';

// void main() {
//   runApp(MyApp());
// }

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var _totalScore = 0;
  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex++;
    });
    print(_questionIndex);
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final _questions = [
      {
        'questionText': 'What\'s your favourite color?',
        'answers': [
          {'text': 'Black', 'score': 0},
          {'text': 'Green', 'score': 1},
          {'text': 'Red', 'score': 0},
          {'text': 'White', 'score': 0}
        ]
      },
      {
        'questionText': 'What\'s your favourite animal?',
        'answers': [
          {'text': 'Dog', 'score': 0},
          {'text': 'Cat', 'score': 0},
          {'text': 'Pig', 'score': 0},
          {'text': 'Koala', 'score': 1}
        ]
      },
      {
        'questionText': 'What\'s your favourite language?',
        'answers': [
          {'text': 'Java', 'score': 0},
          {'text': 'Dart', 'score': 1},
          {'text': 'Python', 'score': 0},
          {'text': 'JS', 'score': 0}
        ]
      },
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                questions: _questions,
                questionIndex: _questionIndex,
              )
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
