// diceToValues() copies the values of each Die into an array of ints
// and returns that array of ints
int[] diceToValues(Die[] from) {
  int[] to = new int[from.length]; 
  for(int i=0;i<to.length;i++){
     to[i]=from[i].value;  
   }  
  return to;         
}

// Sum the pips on just those dice that match the selected score value
// Example: Given dice values of { 6, 6, 5, 6, 3 } and the value 6, then
// sumPips should return 18
int sumPips(Die[] dice, int value) {
  int count=0;
  for(int i=0;i<5;i++){
    if(dice[i].value==value){
      count++;
    } 
  }
  return count*value;
}

// isTrips() returns true if there are at least three of a kind.
// Examples for arrays of dice values:
// { 1, 1, 5, 1, 6 } --> true
// { 1, 2, 3, 4, 4 } --> false
// { 2, 2, 2, 2, 4 } --> true (at least three of a kind, can be more of a kind)
boolean isTrips(Die[] dice) {
  int count[]= new int[6];
  for(Die die : dice){
    count[die.value-1]++;
  }
  for(int i=0;i<6;i++){
    if(count[i]>=3){
      return true;
    }
  }
  return false;
}

// isQuads() returns true if there are at least four of a kind.
// Examples for arrays of dice values:
// { 1, 1, 5, 1, 6 } --> false
// { 1, 2, 3, 4, 4 } --> false
// { 2, 2, 2, 2, 4 } --> true 
// { 3, 3, 3, 3, 3 } --> true (at least four of a kind, can be more of a kind)
boolean isQuads(Die[] dice) {
   int count[]= new int[6];
  for(Die die : dice){
    count[die.value-1]++;
  }
  for(int i=0;i<6;i++){
    if(count[i]>=4){
      return true;
    }
  }
  return false;
}

// isYahtzee() returns true if all five dice have the same value
// Examples for arrays of dice values:
// { 1, 1, 5, 1, 6 } --> false
// { 3, 3, 3, 3, 3 } --> true
boolean isYahtzee(Die[] dice) {
  int count[]= new int[6];
  for(Die die : dice){
    count[die.value-1]++;
  }
  for(int i=0;i<6;i++){
    if(count[i]==5){
      return true;
    }
  }
  return false;
}

// isFullHouse() returns true if three dice have a common value and the
// other two dice have a common value. A Yahtzee is also a full house.
// Examples for arrays of dice values:
// { 1, 1, 5, 1, 5 } --> true
// { 3, 3, 3, 4, 2 } --> false
// { 4, 4, 4, 4, 4 } --> true
boolean isFullHouse(Die[] dice) {
  if(isYahtzee(dice)){
    return true;
  }
  int count[]= new int[6];
  for(Die die : dice){
    count[die.value-1]++;
  }
  boolean three = false;
  boolean two = false;
  for(int i=0;i<6;i++){
    if(count[i]==3){
      three = true;
    }
    if(count[i]==2){
      two=true;
    }
  }
  if(three && two){
    return true;
  }
  return false;
}

// Returns the largest number of consecutive ints in a sorted array
// Example: consec({1, 2, 4, 5, 6}) returns 3 because the longest
// consecutive sequence is {4, 5, 6}.
int consec(int[] sortedNums) {
  int max = 0;
  int tempCount =0;
  for(int i=0;i<sortedNums.length-1;i++){
    if(sortedNums[i]+1==sortedNums[i+1]){
      tempCount+=1;
    }
    else {
      max=Math.max(max,tempCount);
      tempCount=0;
    }
  }   
  return max+1;  
}

// isLargeStraight() returns true if, when sorted, the dice values are
// consecutive integers
// Examples for arrays of dice values:
// { 1, 2, 3, 4, 5 } --> true
// { 2, 3, 4, 5, 6 } --> true
// Anything else --> false
boolean isLargeStraight(Die[] dice) {
  if(consec(diceToValues(dice))==5){
    return true;
  }
  else{
    return false;
  }
}

// isSmallStraight() returns true if you can find four dice that
// have consecutive values. TEST isSmallStraight CAREFULLY.
// Examples for arrays of dice values:
// { 1, 2, 3, 4, 4 } --> true
// { 1, 2, 3, 5, 6 } --> false
// { 1, 3, 4, 5, 6 } --> true
// { 2, 3, 4, 4, 5 } --> true
// { 1, 2, 2, 3, 3 } --> false
boolean isSmallStraight(Die[] dice) {
  int max = 0;
  int tempCount =0;
  int[] arr = new int[dice.length];
  arr = sort(diceToValues(dice));
  for(int i=0;i<arr.length-1;i++){
    if(arr[i]+1==arr[i+1]){
      tempCount+=1;
    }
    else if(arr[i]==arr[i+1]){
      // duplicate, do nothing
    }
    else {
      max=Math.max(max,tempCount);
      tempCount=0;
    }
  }   
  if(max+1 >= 4){
    return true;
  }
  else{
    return false;
  }
}

// chance() returns the sum of the dice values
// Examples for arrays of dice values:
// { 1, 2, 3, 4, 4 } --> 14
// { 1, 2, 3, 5, 6 } --> 17
int chance(Die[] dice) {
  int res = 0;
  for(Die die : dice){
    res+=die.value;
  }
  return res;
}

// You can test your work by printing out stuff in testSuite()
void testSuite() {
  System.out.println(isSmallStraight(dice));
}
