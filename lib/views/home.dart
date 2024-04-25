import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/recipe.api.dart';
import 'package:flutter_application_1/models/recipe.dart';
import 'package:flutter_application_1/views/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   late List<Recipe> _recipes;
  bool _isLoading = true;
  late Timer _timer;
  int _seconds = 0;
  bool _isTimerRunning = false;
  int _inputMinutes = 0;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getRecipes();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isTimerRunning) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
          } else {
            _isTimerRunning = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  Future<void> getRecipes() async {
    _recipes = await RecipeApi.getRecipe();
    setState(() {
      _isLoading = false;
    });
  }

  void startCountdown() {
    setState(() {
      _seconds = _inputMinutes * 60;
      _isTimerRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isTimerRunning && _seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _isTimerRunning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant_menu),
                SizedBox(width: 10),
                Text('Food Recipe'),
              ],
            ),
            Row(
              children: [
                Text('$_seconds s'),
                SizedBox(width: 10),
                Container(
                  width: 100,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter minutes',
                      suffixText: 'min',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _inputMinutes = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: startCountdown,
                  child: Text('Start'),
                ),
                SizedBox(width: 10),
                
              ],
            ),
          ],
        ),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator()) 
        : ListView.builder(
          itemCount: _recipes.length,
          itemBuilder: (context, index){
            return RecipeCard(
              title: _recipes[index].name, 
              cookTime: _recipes[index].totalTime, 
              rating: _recipes[index].rating.toString(), 
              thumbnailUrl: _recipes[index].images);
          },
        ),
    );
  }
}