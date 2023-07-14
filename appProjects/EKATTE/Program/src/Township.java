import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Township {

    private static final String INSERT_INTO = "INSERT INTO Townships VALUES(?, ?, ?)";

    private static final String ROWS_COUNT = "SELECT COUNT(*) AS 'COUNT' FROM Townships;";

    public Township(String id, String name, String regionId) throws ClassNotFoundException, SQLException
    {
        try (Connection con = JDBCHelper.getConnection()) {
            con.setAutoCommit(false);

            try {
                PreparedStatement query = con.prepareStatement(INSERT_INTO);
                query.setString(1, id);
                query.setString(2, name);
                query.setString(3, regionId);
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

    public static void townshipsCount() throws SQLException, ClassNotFoundException {
        try (Connection con = JDBCHelper.getConnection()) {

            con.setAutoCommit(false);

            PreparedStatement query1 = con.prepareStatement(ROWS_COUNT);
            ResultSet resultSet1 = query1.executeQuery();


            if(resultSet1.next())
            {
                System.out.println("Townships: " + resultSet1.getInt("COUNT"));
            }
        }
    }
}
