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

  int findClosest(int root, int step){
    for (int i = 0; i<=step+1; i++){
      int temp = root - i;
      if ((temp-step)%10==0){
        return temp;
      }
    }
    return 0;
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
    int step = int.parse(data[1]);
    int exactRoot = countRoot(num);
    double approxRoot = sqrt(num.toDouble());
    int i = findClosest(exactRoot, step);
    BigInt res;
    double progress_local;
    int temp;
    while (true) {
        counts+=1;
        res = num - BigInt.from(i)*BigInt.from(i);
        progress_local = 1 - i/approxRoot;
        if (counts%10000==0){
          //print("$progress %");
          worker.sendMessage('progress $progress_local');
        }
        if (i<step){
          worker.sendMessage('end 0');
          break;
        }
        int last_digits = (res % BigInt.from(100)).toInt();

        if (res>BigInt.from(200) && possible_endings.contains(last_digits) == false){
          i-=10;
          continue;
        }
        temp = countRoot(res);
        if (BigInt.from(temp)*BigInt.from(temp)==res){
          worker.sendMessage('answer $i $temp');

        }
        i-=10;
      }
  });
 
  
  
  
}