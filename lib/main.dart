import 'package:flutter/material.dart';
import 'fetch_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() async {
  await getQuestions(quizDataList: quizData);
  updateQuestion();
  runApp(const QuizzlerApp());
  initChoiceTracker(num: 15);
}

class QuizzlerApp extends StatelessWidget {
  const QuizzlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AppHomePage());
  }
}

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<AppHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 0, 2), body: AppBody());
  }
}

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _BodyState();
}

var quizData = [];

int qNumber = 1;
String question = "Please Wait...";
bool answer = false;

List<Widget> choiceTracker = [];
void initChoiceTracker({int num = 10}) {
  choiceTracker.clear();
  for (var i = 0; i < num; i++) {
    choiceTracker.add(const Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
      child: Icon(
        Icons.circle,
        color: Color.fromARGB(139, 97, 96, 96),
      ),
    ));
  }
  debugPrint("Choice tracker icons initialized!");
}

bool lastIconChanged = false;

void updateScorePanel(Icon iconData, BuildContext context) {
  if (qNumber == 15 && !lastIconChanged) {
    choiceTracker[14] = Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0), child: iconData);
    lastIconChanged = true;
    Alert(
            context: context,
            title: "Quiz Completed!",
            desc:
                "You've scored $totalScore/15.\nRestart the app to try again!")
        .show();
  } else if (qNumber <= 14) {
    choiceTracker[qNumber - 1] = Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0), child: iconData);
    qNumber++;
    debugPrint("Score panel updated!");
  } else {
    debugPrint("Maximum limit reached! Resetting app state...");
  }
}

int flag = 0;
void updateQuestion() {
  if (qNumber == 15) {
    question = quizData[14][0];
    answer = quizData[14][1];
  } else if (qNumber < 15) {
    question = quizData[flag][0];
    answer = quizData[flag][1];
    flag++;
  } else {
    debugPrint("Already reached the end!");
  }
}

int totalScore = 0;
void checkAnswer(bool choice, BuildContext context) {
  if (choice == answer) {
    debugPrint("choice and asnwer matched!");
    totalScore++;
    updateScorePanel(
        const Icon(Icons.add_circle, color: Color.fromARGB(255, 4, 253, 12)),
        context);
  } else {
    debugPrint("choice and answer mismatched!");
    updateScorePanel(
        const Icon(Icons.remove_circle, color: Color.fromARGB(255, 255, 4, 4)),
        context);
  }
  updateQuestion();
}

class _BodyState extends State<AppBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 50.3),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text("$qNumber.",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontFamily: "BingoDilan",
                        fontSize: 40.0)),
              )
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 15, 30, 5),
            child: Text(
              question,
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: "Louis George Cafe",
                  fontSize: 20.0),
            ),
          )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 50),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        checkAnswer(false, context);
                        debugPrint("False Button Clicked!");
                      });
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(0, 255, 255, 255))),
                    child: const Icon(
                      Icons.cancel,
                      color: Color.fromARGB(255, 255, 2, 2),
                      size: 80,
                    ),
                  )),
              const SizedBox(
                height: 150,
                width: 10,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                  child: VerticalDivider(color: Colors.white),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 50),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        checkAnswer(true, context);
                        debugPrint("True Button clicked!");
                      });
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(0, 255, 255, 255))),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color.fromARGB(255, 3, 247, 3),
                      size: 80,
                    ),
                  )),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: choiceTracker),
        ],
      ),
    );
  }
}
