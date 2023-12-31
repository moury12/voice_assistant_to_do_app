import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:voice_assistant/CONST/Api_info.dart';
class OpenAiService{
  final List <Map<String, String>> messages=[];
  Future<String> isArtApi(String prompt) async{
    try{
      final response =await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $OpenAiApiKey'
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "user",
            "content":'Does this message want to generate an AI picture, image, art or anything similar? $prompt Simply answer with a yes or no.',
          },
        ]
      }));log(prompt);
      log(response.body);
      if(response.statusCode==200){
        log(prompt);
        String content =jsonDecode(response.body)['choices'][0]['message']['content'];
        content =content.trim();
        switch(content){
          case 'Yes':
          case 'Yes.':
          case 'yes':
          case 'yes.':
        final response=    await dalleApi(prompt);
        return response;
          default:
            final response=    await chatGptApi(prompt);
          return response;
        }
      }
      return 'An error occured';
    }catch(e){
      return e.toString();
    }
  }
  Future<String> chatGptApi (String prompt) async{
    messages.add({
      'role':'user',
      'content': prompt
    });
    try{
      final response =await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $OpenAiApiKey'
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": messages
          }));
      if(response.statusCode==200){
        String content =jsonDecode(response.body)['choices'][0]['message']['content'];
        content =content.trim();
        messages.add({
          'role':'assistant',
          'content': content
        });return content;
      }
      return 'An error occured';
    }catch(e){
      return e.toString();
    }
  }
  Future<String> dalleApi(String prompt) async{
    messages.add({
      'role':'user',
      'content': prompt
    });
    try{
      final response =await http.post(Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $OpenAiApiKey'
          },
          body: jsonEncode({
            "prompt": prompt,
            'n':1,
          }));
      if(response.statusCode==200){
        String imgUrl =jsonDecode(response.body)['data'][0]['url'];
        imgUrl =imgUrl.trim();
        messages.add({
          'role':'assistant',
          'content': imgUrl
        });return imgUrl;
      }
      return 'An error occured';
    }catch(e){
      return e.toString();
    }
  }

}