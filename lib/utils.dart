import 'dart:math';

double? randomize(num max, {int? multiple = 1}) {
  double number = Random().nextDouble() * max;

  if (number > max && (number % multiple!).toInt()== 0) {
    randomize(max);
  } 
  else {
    return number;
  }
}
