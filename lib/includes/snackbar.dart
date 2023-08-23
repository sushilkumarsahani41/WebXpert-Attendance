import 'package:flutter/material.dart';

// ignore: camel_case_types
class showSnackbar {
  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>> ShowSnakbar(
          context, msg) async =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurRadius: 15,
                  spreadRadius: 2,
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                ),
              ],
              border:
                  Border.all(width: 2, color: Color.fromRGBO(97, 75, 207, 1)),
              color: Color.fromRGBO(242, 243, 246, 1),
              borderRadius: BorderRadius.circular(20)),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              msg,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        padding: EdgeInsets.only(bottom: 40, right: 20, left: 20, top: 10),
      ));
}
