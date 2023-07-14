import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Main {
    public static void main(String[] args) {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        String connectionString = "jdbc:mysql://127.0.0.1:3306/schoolTB?user=root&password=0000";

        List<String> firstNames = new ArrayList<>();

        firstNames.add("Ivan");
        firstNames.add("Zumbul");
        firstNames.add("George");
        firstNames.add("Aleksandur");
        firstNames.add("Blagoi");

        List<String> lastNames = new ArrayList<>();

        lastNames.add("Georgiev");
        lastNames.add("Ivanov");
        lastNames.add("Aleksandrov");
        lastNames.add("Blagoev");
        lastNames.add("Dimitrov");

        List<String> classLetters = new ArrayList<>();

        classLetters.add("a");
        classLetters.add("b");
        classLetters.add("v");
        classLetters.add("g");

        Random random = new Random();

        Connection con = null;
        try {
            con = DriverManager.getConnection(connectionString);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        final String INSERT_INTO =
                "INSERT INTO Students (FirstName, LastName, Num, ClassNum, ClassLetter) VALUES (?, ?, ?, ?, ?);";


        try {
            con.setAutoCommit(false);

            try {
                for (int i = 0; i < 1_000_000; i++) {

                    con.setAutoCommit(false);

                    PreparedStatement query = con.prepareStatement(INSERT_INTO);
                    query.setString(1, firstNames.get(random.nextInt(firstNames.size())));
                    query.setString(2, lastNames.get(random.nextInt(lastNames.size())));
                    query.setInt(3, random.nextInt(30) + 1);
                    query.setInt(4, random.nextInt(12) + 1);
                    query.setString(5, classLetters.get(random.nextInt(classLetters.size())));
                    query.executeUpdate();
                    con.commit();

                    System.out.println(i);
                }
            } catch (Exception e)
            {
                con.rollback();
                throw e;
            }finally {
                con.setAutoCommit(true);
            }

        }catch (Exception e)
        {
            throw new RuntimeException(e);
        }
    }
}