import 'package:flutter_application_2/tiny_worker_webdev.dart' as tw;
import 'dart:math';

  double NewtonRoot(n, l){
    int estimation = (n.toString().length/2).ceil();
    double x = pow(10, estimation).toDouble();
    //int count = 0;
    double root = 1;
    while (true){
      //count += 1;
      root = 0.5 * (x + (n / BigInt.from(x)));
      //print(count);
      //print(root);
      if ((root - x).abs() < l) {
        break;
      }
      x = root;

    }
    return root;
  }

  int countRoot(BigInt res) {
        
        int temp;
        if (res.isValidInt){
          temp = sqrt(res.toInt()).round();
        }
        else{
          temp = NewtonRoot(res, 1).round();
        }
        return temp;
  }
void main() {
  print('Worker created');
  var worker = tw.Worker();
   var possible_endings = [0, 1, 4, 9, 16, 21, 24, 25, 29, 36, 41, 44, 49, 56, 61, 64, 69, 76, 81, 84, 89, 96];
  worker.onReceive().listen((message) {
    var data = message.toString().split(' ');
    BigInt num = BigInt.parse(data[0]);
    int counts = 0;
    int i = int.parse(data[1]);
    BigInt res;
    double progress_local;
    int temp;
    while (true) {
        counts+=1;
        res = num - BigInt.from(i)*BigInt.from(i);
        progress_local = i/(sqrt(num.toDouble()));
        if (counts%10000==0){
          //print("$progress %");
          worker.sendMessage('progress $progress_local');
        }
          if (res<=BigInt.zero){
            worker.sendMessage('end 0');
          break;
        }
        int last_digits = (res % BigInt.from(100)).toInt();

        if (res>BigInt.from(200) && possible_endings.contains(last_digits) == false){
          i+=10;
          continue;
        }
        temp = countRoot(res);
        if (BigInt.from(temp)*BigInt.from(temp)==res){
          worker.sendMessage('answer $i $temp');

        }
        i+=10;
      }
  });
 
  
  
  
}