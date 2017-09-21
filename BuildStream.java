package self.softcreative.coded;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

public class BuildStream {


    public static void main(String[] args) {


        List<Integer> firstList = new ArrayList<Integer>();
        firstList.add(1);
        firstList.add(5);
        firstList.add(8);
        firstList.add(18);
        firstList.add(80);
//        convert to a Stream
        Stream<Integer> firstStream = firstList.stream();
        System.out.println(firstStream.count());


        Integer[] secondArrayList = {2, 34, 56, 87};
        Stream<Integer> secondArrayNowStream = Arrays.stream(secondArrayList);
        System.out.println(secondArrayNowStream.count());

//        Maps, Filters, Reduce
        String[] myArray = new String[]{"bob", "alice", "paul", "ellie"};
        Stream<String> myStream = Arrays.stream(myArray);
//MAP
        Stream<String> myNewStream = myStream.map(String::toUpperCase);
//        Stream<String> myNewStream = myStream.map( s -> s.toUpperCase() );
        myNewStream.forEach(System.out::println);

//        String[] myNewArray = myNewStream.toArray(String[]::new);
//        System.out.println(myNewArray);


//        FILTER
        String[] myFilteredArray = Arrays.stream(myArray)
                .filter(s -> s.length() > 4)
                .toArray(String[]::new);

        for (int i = myFilteredArray.length - 1; i >= 0; i--) {
            System.out.println(myFilteredArray[i]);
        }

//        REDUCE
        int[] numsArray = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        int sumArray = Arrays.stream(numsArray).sum();
        System.out.println(sumArray);

//        Reduce on Strings
        String[] myStringArray = { "this", "is", "a", "sentence" };
        String result = Arrays.stream(myStringArray)
                .reduce("", (a,b) -> a + "-BUG-" + b);

        System.out.println(result);

    }
}
