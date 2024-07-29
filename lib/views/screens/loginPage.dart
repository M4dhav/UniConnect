import 'package:flutter/material.dart';

class loginPage extends StatelessWidget {
  const loginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize=MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/Memojiswelcome.jpg",
              ),
            ),
            Text(
              "Find your friends.\nAnytime. Anywhere.",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            FilledButton(
              onPressed: () {},
            
              style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll(Size(screenSize.width*0.8,screenSize.height*0.07)),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))
              ),
              child: const Text("SignIn With Google"),
            )
          ],
        ),
      ),
    );
  }
}
