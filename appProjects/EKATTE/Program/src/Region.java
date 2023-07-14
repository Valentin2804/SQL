import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Region {

    private static final String INSERT_INTO = "INSERT INTO Regions VALUES (?, ?)";

    private static final String ROWS_COUNT = "SELECT COUNT(*) AS 'COUNT' FROM Regions;";

    public Region(String id, String name) throws ClassNotFoundException, SQLException
    {

        try (Connection con = JDBCHelper.getConnection())
        {
            con.setAutoCommit(false);

            try {
                PreparedStatement query = con.prepareStatement(INSERT_INTO);
                query.setString(1, id);
                query.setString(2, name);
                query.executeUpdate();
                con.commit();
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public static void regionsCount() throws SQLException, ClassNotFoundException {
        try (Connection con = JDBCHelper.getConnection()) {

            con.setAutoCommit(false);

            PreparedStatement query1 = con.prepareStatement(ROWS_COUNT);
            ResultSet resultSet1 = query1.executeQuery();


            if(resultSet1.next())
            {
                System.out.println("Regions: " + resultSet1.getInt("COUNT"));
            }
        }
    }
}
