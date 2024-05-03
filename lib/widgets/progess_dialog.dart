import "package:flutter/material.dart";
class ProgressDialog extends StatelessWidget {
  //ProgressDialog({super.key});

  String message;
  ProgressDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.tealAccent,
      child: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6)
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              const SizedBox(width: 6,),
              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              const SizedBox(width: 26,),
              Text(message,
              style: const TextStyle(color: Colors.black,fontSize: 15),)
            ],
          ),
        ),
      ),
    );
  }
}
