import com.mysql.cj.xdevapi.Column;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.*;
import java.util.List;

import static java.sql.Types.NUMERIC;
import static org.apache.xmlbeans.impl.piccolo.xml.Piccolo.STRING;

public class JDBCHelper {

    private static final String GET_PLACE =
            """
                    SELECT Places.Name AS 'Place', TownHalls.Name AS 'Town hall', Townships.Name AS 'Township', Regions.Name AS 'Region'
                    FROM Places
                    LEFT JOIN TownHalls
                    ON Places.TownHallId = TownHalls.Id
                    LEFT JOIN Townships
                    ON TownHalls.TownshipId = Townships.Id
                    LEFT JOIN Regions
                    ON TownShips.RegionId = Regions.Id
                    WHERE Places.Name = ?;
                    """;

    private static final String CHECK_PLACE =
            """
                    SELECT COUNT(*) AS COUNT 
                    FROM Places
                    WHERE Places.Name = ?;
                    """;

    private static final String RESET_DATABASE =
            """
                    DROP TABLE Regions;
                    CREATE TABLE Regions (
                        Id CHAR(3) NOT NULL PRIMARY KEY,
                        Name VARCHAR(25) NOT NULL
                    );
                                        
                    DROP TABLE Townships;
                    CREATE TABLE Townships (
                        Id CHAR(5) NOT NULL PRIMARY KEY,
                        Name VARCHAR(25) NOT NULL,
                        RegionId CHAR(3) NOT NULL,
                       \s
                        FOREIGN KEY (RegionId) REFERENCES Regions(Id)
                    );
                                        
                    DROP TABLE TownHalls;
                    CREATE TABLE TownHalls (
                        Id CHAR(8) NOT NULL,
                        Category INTEGER,
                        Name VARCHAR(25),
                        TownshipId CHAR(5) NOT NULL,
                       \s
                        PRIMARY KEY (Id, Category),
                        FOREIGN KEY (TownshipId) REFERENCES Townships(Id)
                    );
                                        
                    DROP TABLE Places;
                    CREATE TABLE Places (
                        EKATTE CHAR(5) NOT NULL PRIMARY KEY,
                        Name VARCHAR(25) NOT NULL,
                        TownHallId CHAR(8) NOT NULL,
                       \s
                        FOREIGN KEY (TownHallId) REFERENCES TownHalls(Id)
                    );
                    """;

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        // инициализация на driver-а
        Class.forName("com.mysql.cj.jdbc.Driver");

        // създаване на connection string
        String connectionString = "jdbc:mysql://127.0.0.1:3306/EKATTE?user=root&password=";

        // създаване на връзка към БД
        Connection con = DriverManager.getConnection(connectionString);

        return con;


    }

    public static void insertDataIntoDatabase(List<Integer> columns, String table, String path)
    {
        int columnIndex1 = columns.get(0);
        int columnIndex2 = columns.get(1);
        int columnIndex3 = 0;
        int count = 11;

        if(columns.size() == 3)
        {
            columnIndex3 = columns.get(2);
        }

        if(columns.size() == 2)
        {
            try (FileInputStream fis = new FileInputStream(path)) {
                Workbook workbook = new XSSFWorkbook(fis);
                Sheet sheet = workbook.getSheetAt(0);

                for(int rowIndex = 4; rowIndex <= sheet.getLastRowNum(); rowIndex++)
                {
                    Row row = sheet.getRow(rowIndex);

                    Cell cell1 = row.getCell(columnIndex1);
                    Cell cell2 = row.getCell(columnIndex2);
                    if (cell2 != null && cell1 != null) {
                        String cellValue1 = cell1.getStringCellValue();
                        String cellValue2 = cell2.getStringCellValue();

                        switch (table) {
                            case "RE" -> new Region(cellValue1, cellValue2);
                            case "TS" -> {
                                String regionId = cellValue1.substring(0, 3);
                                new Township(cellValue1, cellValue2, regionId);
                            }
                            default -> throw new IllegalArgumentException("Invalid table provided");
                        }
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            } catch (SQLException | ClassNotFoundException e) {
                throw new RuntimeException(e);
            }
        } else if (columns.size() == 3) {

            try (FileInputStream fis = new FileInputStream(path)) {
                Workbook workbook = new XSSFWorkbook(fis);
                Sheet sheet = workbook.getSheetAt(0);

                for(int rowIndex = 4; rowIndex <= sheet.getLastRowNum(); rowIndex++)
                {
                    Row row = sheet.getRow(rowIndex);

                    Cell cell1 = row.getCell(columnIndex1);
                    Cell cell2 = row.getCell(columnIndex2);
                    Cell cell3 = row.getCell(columnIndex3);
                    if (cell2 != null && cell1 != null && cell3 != null) {

                        switch (cell1.getCellTypeEnum()) {
                            case STRING -> {
                                String cellValue1 = cell1.getStringCellValue();
                                String cellValue3 = cell3.getStringCellValue();
                                if (table.equals("PL")) {
                                    String cellValue2 = cell2.getStringCellValue();
                                    if (TownHall.checkTownHallExists(cellValue3)) {
                                        new Place(cellValue1, cellValue2, cellValue3);
                                    } else {
                                        getConnection().setAutoCommit(false);
                                        new TownHall(cellValue3, count, "Селището", cellValue3.substring(0, 5));
                                        getConnection().setAutoCommit(true);
                                        new Place(cellValue1, cellValue2, cellValue3);
                                        count++;
                                    }
                                } else if (table.equals("TH")) {
                                    double cellValue2 = cell2.getNumericCellValue();
                                    String townshipId = cellValue1.substring(0, 5);
                                    new TownHall(cellValue1, (int) cellValue2, cellValue3, townshipId);
                                } else {
                                    throw new IllegalArgumentException("Invalid table abbreviation provided");
                                }
                            }
                            case NUMERIC -> {
                                double cellValue1 = cell1.getNumericCellValue();
                                String cellValue3 = cell3.getStringCellValue();

                                String cellValue2 = cell2.getStringCellValue();
                                if (TownHall.checkTownHallExists(cellValue3)) {
                                    String ekatte = Integer.toString((int) cellValue1);
                                    new Place(ekatte, cellValue2, cellValue3);
                                } else {
                                    getConnection().setAutoCommit(false);
                                    new TownHall(cellValue3, count, "Селището", cellValue3.substring(0, 5));
                                    getConnection().setAutoCommit(true);
                                    String ekatte = Integer.toString((int) cellValue1);
                                    new Place(ekatte, cellValue2, cellValue3);
                                    count++;
                                }
                            }
                        }

                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            } catch (SQLException | ClassNotFoundException e) {
                throw new RuntimeException(e);
            }

        }else
        {
            System.out.println("Invalid arguments");
        }
    }

    public static void getPlaceByName(String name) throws SQLException, ClassNotFoundException {
        try (Connection con = JDBCHelper.getConnection()) {

            con.setAutoCommit(false);

            PreparedStatement query1 = con.prepareStatement(CHECK_PLACE);
            query1.setString(1, name);
            ResultSet resultSet1 = query1.executeQuery();


            if(resultSet1.next())
            {
                if(resultSet1.getInt("COUNT") == 0)
                {
                    throw new IllegalArgumentException("This place does not exists");
                }else
                {
                    PreparedStatement query = con.prepareStatement(GET_PLACE);
                    query.setString(1, name);
                    ResultSet resultSet = query.executeQuery();

                    con.setAutoCommit(true);

                    int i = 1;
                    while (resultSet.next())
                    {
                        System.out.println("Place" + i);
                        System.out.println("Name of the place: " + resultSet.getString("Place"));
                        System.out.println("Its town hall: " + resultSet.getString("Town hall"));
                        System.out.println("Its township: " + resultSet.getString("Township"));
                        System.out.println("Its region: " + resultSet.getString("Region"));
                        i++;
                    }
                }
            }else
            {
                throw new IllegalArgumentException("This place does not exists");
            }

        }
    }

    public static void resetDatabase() throws SQLException, ClassNotFoundException {
        try (Connection con = JDBCHelper.getConnection()) {

            con.setAutoCommit(false);

            PreparedStatement query1 = con.prepareStatement(RESET_DATABASE);
            query1.executeQuery();

            con.setAutoCommit(true);
        }
    }
}
