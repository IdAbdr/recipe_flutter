import 'dart:convert';
import 'package:flutter_application_1/models/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeApi{
static Future<List<Recipe>> getRecipe() async{
  var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/list', 
    {'limit': '24', 'start': '0',  "tag": "list.recipe.popular"});
  
  final response = await http.get(uri, headers: {
    'X-RapidAPI-Key': 'f431d76af8msh61c03e9bab69e0dp199490jsn71e6e2b12760',
	  'X-RapidAPI-Host': 'yummly2.p.rapidapi.com',
    "useQueryString": "true"
  });

  Map data = jsonDecode(response.body);
  List _temp = [];

  for (var i in data['feed']){
    _temp.add(i['content']['details']);
  }

  return Recipe.recipesFromSnapshot(_temp);
}



}