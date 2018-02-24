import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.IOException;


/**
 * Allows clients to query and update the database in order to log in, search
 * for flights, reserve seats, show reservations, and cancel reservations.
 */
public class FlightsDB {

  /** Maximum number of reservations to allow on one flight. */
  private static int MAX_FLIGHT_BOOKINGS = 3;

  /** Holds the connection to the database. */
  private Connection conn;

  /** Opens a connection to the database using the given settings. */
  public void open(Properties settings) throws Exception {
    // Make sure the JDBC driver is loaded.
    String driverClassName = settings.getProperty("flightservice.jdbc_driver");
    Class.forName(driverClassName).newInstance();

    // Open a connection to our database.
    conn = DriverManager.getConnection(
        settings.getProperty("flightservice.url"),
        settings.getProperty("flightservice.sqlazure_username"),
        settings.getProperty("flightservice.sqlazure_password"));
  }

  /** Closes the connection to the database. */
  public void close() throws SQLException {
    conn.close();
    conn = null;
  }

  // SQL statements with spaces left for parameters:
  private PreparedStatement beginTxnStmt;
  private PreparedStatement commitTxnStmt;
  private PreparedStatement abortTxnStmt;

  /** Performs additional preparation after the connection is opened. */
  public void prepare() throws SQLException {
    // NOTE: We must explicitly set the isolation level to SERIALIZABLE as it
    //       defaults to allowing non-repeatable reads.
    beginTxnStmt = conn.prepareStatement(
        "SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; BEGIN TRANSACTION;");
    commitTxnStmt = conn.prepareStatement("COMMIT TRANSACTION");
    abortTxnStmt = conn.prepareStatement("ROLLBACK TRANSACTION");

    // TODO: create more prepared statements here
  }

  /**
   * Tries to log in as the given user.
   * @returns The authenticated user or null if login failed.
   */
  public User logIn(String handle, String password) throws SQLException {
    // TODO: implement this properly

    String loginInfo = 
      "SELECT handle, password, full_name, uid\n" +
      "FROM Customer\n" + 
      "WHERE handle = ? AND password = ? \n";

    PreparedStatement searchLoginInfo = conn.prepareStatement(loginInfo);
    searchLoginInfo.clearParameters();
    searchLoginInfo.setString(1,handle);
    searchLoginInfo.setString(2,password);
    ResultSet loginResults = searchLoginInfo.executeQuery();

    while(loginResults.next()){
      String h = loginResults.getString("handle");
      String p = loginResults.getString("password");
      String f = loginResults.getString("full_name");
      int u = loginResults.getInt("uid");
      if(h.equals(handle) && p.equals(password)){
        return new User(u,h,f);
      }
    }
    loginResults.close();

    return null;
  }

  /**
   * Returns the list of all flights between the given cities on the given day.
   */
  public List<Flight[]> getFlights(
      int year, int month, int dayOfMonth, String originCity, String destCity)
      throws SQLException {

    List<Flight[]> results = new ArrayList<Flight[]>();

    String direct_result_string = 
        "SELECT TOP (?) fid, name, flight_num, origin_city, dest_city, " +
        "    actual_time\n" +
        "FROM Flights F1, Carriers\n" +
        "WHERE carrier_id = cid AND actual_time IS NOT NULL AND " +
        "    year = ? AND month_id = ? AND day_of_month = ? AND " + 
        "    origin_city = ? AND dest_city = ? \n" +
        "ORDER BY actual_time ASC";

    PreparedStatement searchDirectResult = conn.prepareStatement(direct_result_string);
    searchDirectResult.clearParameters();
    searchDirectResult.setInt(1, 99);
    searchDirectResult.setInt(2, year);
    searchDirectResult.setInt(3, month);
    searchDirectResult.setInt(4, dayOfMonth);
    searchDirectResult.setString(5, originCity);
    searchDirectResult.setString(6, destCity);
    ResultSet directResults = searchDirectResult.executeQuery();


    while (directResults.next()) {
      results.add(new Flight[] {
          new Flight(directResults.getInt("fid"), year, month, dayOfMonth,
              directResults.getString("name"),
              directResults.getString("flight_num"),
              directResults.getString("origin_city"),
              directResults.getString("dest_city"),
              (int)directResults.getFloat("actual_time"))
        });
    }
    directResults.close();

    String twoHopString = 
      "SELECT TOP (?) F1.fid as fid1, C1.name as name1, " +
        "    F1.flight_num as flight_num1, F1.origin_city as origin_city1, " +
        "    F1.dest_city as dest_city1, F1.actual_time as actual_time1, " +
        "    F2.fid as fid2, C2.name as name2, " +
        "    F2.flight_num as flight_num2, F2.origin_city as origin_city2, " +
        "    F2.dest_city as dest_city2, F2.actual_time as actual_time2\n" +
        "FROM Flights F1, Flights F2, Carriers C1, Carriers C2\n" +
        "WHERE F1.carrier_id = C1.cid AND F1.actual_time IS NOT NULL AND " +
        "    F2.carrier_id = C2.cid AND F2.actual_time IS NOT NULL AND " +
        "    F1.year = ? AND F1.month_id = ? AND F1.day_of_month = ? AND " +
        "    F2.year = ? AND F2.month_id = ? AND F2.day_of_month = ? AND " +
        "    F1.origin_city = ? AND F2.dest_city = ? AND" +
        "    F1.dest_city = F2.origin_city\n" +
        "ORDER BY F1.actual_time + F2.actual_time ASC";
    PreparedStatement searchTwoHopResult = conn.prepareStatement(twoHopString);
    searchTwoHopResult.clearParameters();
    searchTwoHopResult.setInt(1, 99);
    searchTwoHopResult.setInt(2, year);
    searchTwoHopResult.setInt(3, month);
    searchTwoHopResult.setInt(4, dayOfMonth);
    searchTwoHopResult.setInt(5, year);
    searchTwoHopResult.setInt(6, month);
    searchTwoHopResult.setInt(7, dayOfMonth);
    searchTwoHopResult.setString(8, originCity);
    searchTwoHopResult.setString(9, destCity);
    ResultSet twoHopResults = searchTwoHopResult.executeQuery();


    while (twoHopResults.next()) {
      results.add(new Flight[] {
          new Flight(twoHopResults.getInt("fid1"), year, month, dayOfMonth,
              twoHopResults.getString("name1"),
              twoHopResults.getString("flight_num1"),
              twoHopResults.getString("origin_city1"),
              twoHopResults.getString("dest_city1"),
              (int)twoHopResults.getFloat("actual_time1")),
          new Flight(twoHopResults.getInt("fid2"), year, month, dayOfMonth,
              twoHopResults.getString("name2"),
              twoHopResults.getString("flight_num2"),
              twoHopResults.getString("origin_city2"),
              twoHopResults.getString("dest_city2"),
              (int)twoHopResults.getFloat("actual_time2"))
        });
    }
    twoHopResults.close();

    return results;
  }

  /** Returns the list of all flights reserved by the given user. */
  public List<Flight> getReservations(int userid) throws SQLException {
    // TODO: implement this properly

    String getReservation = 
    "SELECT f.fid AS fid, f.year AS year, f.month_id AS month, " +
            "f.day_of_month AS dayOfMonth, f.carrier_id AS carrier, " +
            "f.flight_num AS flight_num, f.origin_city AS originCity, " + 
            "f.dest_city AS destCity, f.actual_time AS actual_time\n" +
      "FROM Reservation r, Flights f\n" +
      "WHERE user_id = ? AND r.flight_id = f.fid";
    PreparedStatement searchReservation = conn.prepareStatement(getReservation);
    searchReservation.clearParameters();
    searchReservation.setInt(1,userid);
    ResultSet reservationResults = searchReservation.executeQuery();
    List<Flight> results = new ArrayList<Flight>();
    while(reservationResults.next()){
      results.add(new Flight(
          reservationResults.getInt("fid"),
          reservationResults.getInt("year"),
          reservationResults.getInt("month"),
          reservationResults.getInt("dayOfMonth"),
          reservationResults.getString("carrier"),
          reservationResults.getString("flight_num"),
          reservationResults.getString("originCity"),
          reservationResults.getString("destCity"),
          reservationResults.getInt("actual_time")
        ));
    }
    reservationResults.close();
    
    return results;
  }

  /** Indicates that a reservation was added successfully. */
  public static final int RESERVATION_ADDED = 1;

  /**
   * Indicates the reservation could not be made because the flight is full
   * (i.e., 3 users have already booked).
   */
  public static final int RESERVATION_FLIGHT_FULL = 2;

  /**
   * Indicates the reservation could not be made because the user already has a
   * reservation on that day.
   */
  public static final int RESERVATION_DAY_FULL = 3;

  /**
   * Attempts to add a reservation for the given user on the given flights, all
   * occurring on the given day.
   * @returns One of the {@code RESERVATION_*} codes above.
   */
  public int addReservations(
      int userid, int year, int month, int dayOfMonth, List<Flight> flights)
      throws SQLException {

    // TODO: implement this in a transaction (see beginTransaction etc. below)

    String reservationCountString = 
      "SELECT COUNT(*) AS res_count\n" +
      "FROM Reservation\n" + 
      "WHERE flight_id = ?";
    PreparedStatement hasReservationCheck = conn.prepareStatement(reservationCountString);
    hasReservationCheck.clearParameters();

    String reservationDayString = 
      "SELECT f.year AS year, f.month_id AS month, f.day_of_month AS dayofmonth\n" +
      "FROM Reservation r, Flights f\n" + 
      "WHERE r.flight_id = f.fid\n" +
      "AND r.user_id = ?";
    PreparedStatement reservationDayCheck = conn.prepareStatement(reservationDayString);
    reservationDayCheck.clearParameters();

    String getHandle = "SELECT handle FROM Customer WHERE uid = ?";
    PreparedStatement getHandleStatement = conn.prepareStatement(getHandle);
    getHandleStatement.clearParameters();
    getHandleStatement.setInt(1,userid);
    ResultSet handleSet = getHandleStatement.executeQuery();
    String handle = "";
    while(handleSet.next()){
      handle = handleSet.getString("handle");
    }
    getHandleStatement.close();

    String insertFlightString = 
      "INSERT INTO Reservation\n" +
      "VALUES(?, ?, ?)";
    PreparedStatement insertFlightStatement = conn.prepareStatement(insertFlightString);
    insertFlightStatement.clearParameters();
    insertFlightStatement.setInt(1,userid);
    insertFlightStatement.setString(2,handle);

    try{
      beginTransaction();
      ResultSet reservationCheckResults = null;
      for(Flight f : flights){
        hasReservationCheck.setInt(1,f.id);
        reservationCheckResults = hasReservationCheck.executeQuery();
        int reservationCount = 0;
        while(reservationCheckResults.next()){
          reservationCount = reservationCheckResults.getInt("res_count");
        }
        if(reservationCount >= 3){
          rollbackTransaction();
          return RESERVATION_FLIGHT_FULL;
        }
      }
      hasReservationCheck.close();

      reservationDayCheck.setInt(1,userid);
      ResultSet dayCheck = reservationDayCheck.executeQuery();
      while(dayCheck.next()){
        int fyear = dayCheck.getInt("year");
        int fmonth = dayCheck.getInt("month");
        int fdom = dayCheck.getInt("dayofmonth");

        if(year == fyear && month == fmonth && fdom == dayOfMonth){
          rollbackTransaction();
          return RESERVATION_DAY_FULL;
        }
      }
      dayCheck.close();

      System.out.println("Press any key to continue...");
      try{
        System.in.read();
      }catch(IOException ie){}

      for(Flight f: flights){
        insertFlightStatement.setInt(3,f.id);
        insertFlightStatement.execute();
      }
      insertFlightStatement.close();

      commitTransaction();
    }catch(SQLException e){
      try{
        rollbackTransaction();
      }catch(SQLException se){}
    }

    return RESERVATION_ADDED;
  }

  /** Cancels all reservations for the given user on the given flights. */
  public void removeReservations(int userid, List<Flight> flights)
      throws SQLException {

    // TODO: implement this in a transaction (see beginTransaction etc. below)

    String removeReservation = 
      "DELETE FROM Reservation\n"+
      "WHERE user_id = ?";
    PreparedStatement deleteReservation = conn.prepareStatement(removeReservation);

    try{
      beginTransaction();
      deleteReservation.clearParameters();
      deleteReservation.setInt(1,userid);
      deleteReservation.execute();
      commitTransaction();
    }catch(SQLException e){
      try{
        rollbackTransaction();
      }catch(SQLException se){}
    }
  }

  /** Puts the connection into a new transaction. */    
  public void beginTransaction() throws SQLException {
    conn.setAutoCommit(false);  // do not commit until explicitly requested
    beginTxnStmt.executeUpdate();  
  }

  /** Commits the current transaction. */
  public void commitTransaction() throws SQLException {
    commitTxnStmt.executeUpdate(); 
    conn.setAutoCommit(true);  // go back to one transaction per statement
  }

  /** Aborts the current transaction. */
  public void rollbackTransaction() throws SQLException {
    abortTxnStmt.executeUpdate();
    conn.setAutoCommit(true);  // go back to one transaction per statement
  } 
}
