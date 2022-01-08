public boolean between(int a, int lower, int upper) {
  return (a >= lower) && (a <= upper);
}

public static void printArray(int[] nums) {
  for (int n : nums) {
    print(n + " ");
  } println();
}

public boolean allScored() {
  for (int i = 1; i < scores.length; i++) {
    if (scores[i] == -1) return false;
  }
  return true;
}
