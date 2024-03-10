import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:thing_finder/app.dart';
import 'package:thing_finder/counter_observer.dart';

void main() {
  Bloc.observer = const CounterObserver();
  runApp(const CounterApp());
}