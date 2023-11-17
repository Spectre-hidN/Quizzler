import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

List<QuizData> parsedDataList = [];
Future fetchQuizData(http.Client client) async {
  final response = await client.get(Uri.parse("https://pastebin.com/raw/9bPZTmHb"));

  if (response.statusCode == 200) {
    debugPrint("Successfully fetched quiz data!");
    parsedDataList = parseData(response.body);
  }
  else{
    debugPrint("Couldn't able to fetch quiz Data");
  }
}

List<QuizData> parseData(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<QuizData>((json) => QuizData.fromJSON(json)).toList();
}

class QuizData {
  final int id;
  final String question;
  final bool answer;

  const QuizData({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory QuizData.fromJSON(Map<String, dynamic> json) {
    return QuizData(id: json['id'] as int, 
                    question: json['question'] as String,
                    answer: json['answer'] as bool);
  }
}

Future getQuestions({required List quizDataList}) async {
  await fetchQuizData(http.Client());

  while (parsedDataList.isNotEmpty){ 
    int index = Random().nextInt(parsedDataList.length);
    var quiz = parsedDataList[index];
    quizDataList.add([quiz.question, quiz.answer]);
    parsedDataList.removeAt(index);     //Clear the QuizData element to prevent repetition.
  }
}