import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) throws SQLException, ClassNotFoundException {

        Scanner scanner = new Scanner(System.in);

        while (true)
        {
            Region.regionsCount();
            Township.townshipsCount();
            TownHall.townHallsCount();
            Place.placesCount();
            System.out.println("====================");

            System.out.println(
                    """
                            Type:
                            1 to FIll the database
                            2 to Get information for a place
                            3 to exit
                            """
            );

            int num = scanner.nextInt();

            if(num == 1)
            {
                String regionsExel =
                        "C:\\Users\\Lenovo\\Documents\\TelebidPro" +
                                "\\valentin.m-practice\\Telebid\\July2023\\EKATTE\\exelTxtFilesWithData\\ek_obl.xlsx";

                String townshipsExel = "C:\\Users\\Lenovo\\Documents\\TelebidPro" +
                        "\\valentin.m-practice\\Telebid\\July2023\\EKATTE\\exelTxtFilesWithData\\ek_obst.xlsx";

                String townHallsExel = "C:\\Users\\Lenovo\\Documents\\TelebidPro" +
                        "\\valentin.m-practice\\Telebid\\July2023\\EKATTE\\exelTxtFilesWithData\\ek_kmet.xlsx";

                String placesExel = "C:\\Users\\Lenovo\\Documents\\TelebidPro" +
                        "\\valentin.m-practice\\Telebid\\July2023\\EKATTE\\exelTxtFilesWithData\\ek_atte.xlsx";

                List<Integer> regionsColumns = new ArrayList<>();
                regionsColumns.add(2);
                regionsColumns.add(3);

                List<Integer> townshipsColumns = new ArrayList<>();
                townshipsColumns.add(0);
                townshipsColumns.add(3);

                List<Integer> townHallColumns = new ArrayList<>();
                townHallColumns.add(0);
                townHallColumns.add(8);
                townHallColumns.add(1);

                List<Integer> placesColumns = new ArrayList<>();
                placesColumns.add(0);
                placesColumns.add(2);
                placesColumns.add(8);

                JDBCHelper.insertDataIntoDatabase(regionsColumns, "RE", regionsExel);
                JDBCHelper.insertDataIntoDatabase(townshipsColumns, "TS", townshipsExel);
                JDBCHelper.insertDataIntoDatabase(townHallColumns, "TH", townHallsExel);
                JDBCHelper.insertDataIntoDatabase(placesColumns, "PL", placesExel);

                System.out.println("Database filled!");
            } else if (num == 2) {
                System.out.println("What is the name of the place you want to get information?");
                String place = scanner.next();
                JDBCHelper.getPlaceByName(place);
            } else if (num == 3) {
                scanner.close();
                JDBCHelper.resetDatabase();
                return;
            } else
            {
                System.out.println("Invalid number provided!");
            }
        }
    }
}