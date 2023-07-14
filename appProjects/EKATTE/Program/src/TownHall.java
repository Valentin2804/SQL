import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TownHall {

    private static final String INSERT_INTO = "INSERT INTO TownHalls VALUES(?, ?, ?, ?)";

    private static final String CHECK_IF_TOWNHALL_EXIST =
            """ 
                SELECT COUNT(*) AS COUNT
                FROM TownHalls
                WHERE TownHalls.Id = ?
            """;

    private static final String ROWS_COUNT = "SELECT COUNT(*) AS 'COUNT' FROM TownHalls;";

    public TownHall(String id, Integer category, String name, String townshipId) throws ClassNotFoundException, SQLException
    {
        try (Connection con = JDBCHelper.getConnection()) {
            con.setAutoCommit(false);

            try {
                PreparedStatement query = con.prepareStatement(INSERT_INTO);
                query.setString(1, id);
                query.setInt(2, category);
                query.setString(3, name);
                query.setString(4, townshipId);
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

    public static boolean checkTownHallExists(String townHallId) throws SQLException, ClassNotFoundException {
        try (Connection con = JDBCHelper.getConnection()) {
            con.setAutoCommit(false);

            PreparedStatement query = con.prepareStatement(CHECK_IF_TOWNHALL_EXIST);
            query.setString(1, townHallId);

            ResultSet result = query.executeQuery();


            if (result.next())
            {
                return result.getInt("COUNT") != 0;
            }
            con.setAutoCommit(true);
        }
        return false;
    }

    public static void townHallsCount() throws SQLException, ClassNotFoundException {
        try (Connection con = JDBCHelper.getConnection()) {

            con.setAutoCommit(false);

            PreparedStatement query1 = con.prepareStatement(ROWS_COUNT);
            ResultSet resultSet1 = query1.executeQuery();


            if(resultSet1.next())
            {
                System.out.println("Town Halls: " + resultSet1.getInt("COUNT"));
            }
        }
    }
}
