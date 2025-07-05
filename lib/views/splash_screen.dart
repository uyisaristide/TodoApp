import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../utls/callbacks.dart';
import '../utls/font_sizes.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  startTimer() async {
    Future.delayed(const Duration(milliseconds: 3000), () {
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: kPrimaryColor,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset(AssetsUtils.logo, width: 100,),
            const SizedBox(height: 20,),
            buildText(text: 'Task manager',color:  kBlackColor,fontSize:  textBold,
               fontWeight:  FontWeight.w600,textAlign:  TextAlign.center),
            const SizedBox(
              height: 10,
            ),
            const Center(child: CircularProgressIndicator(color: kPrimaryColor,),),
            const SizedBox(
              height: 10,
            ),
            buildText(text: 'Schedule your week with ease',color:  kBlackColor,fontSize:  textTiny,
               fontWeight:  FontWeight.normal,textAlign:  TextAlign.center),
          ],
        )));
  }
}
