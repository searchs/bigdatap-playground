import au.com.bytecode.opencsv.CSVReader;
import org.junit.Test;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.Scanner;


public class CsvBox {

//Get row and column count in parsed CSV
 public static int[] getRowsColsCount(File filename) {
        Scanner scanIn = null;
        int rows = 0;
        int cols = 0;
        String InputLine = "";
        try {
            scanIn = new Scanner(new BufferedReader(
                    new FileReader(filename)));
            scanIn.useDelimiter(",");
            while (scanIn.hasNextLine()) {
                InputLine = scanIn.nextLine();
                String[] InArray = InputLine.split(",");
                rows++;
                cols = InArray.length;
            }

        } catch (Exception e) {
            System.out.println(e);
        }
        return new int[]{rows, cols};
    }


}
