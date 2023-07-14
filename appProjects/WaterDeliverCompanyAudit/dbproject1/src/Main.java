import java.sql.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Scanner;

public class Main {
    public static void main(String[] args){
        int switcher = 0;

        Scanner scanner = new Scanner(System.in);

        String address;
        String address1;
        String name;
        String egn;
        String egn1;
        String market;
        Integer money;
        Date date;
        Date date1;

        int orderId;

        DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

        while (switcher != 20)
        {
            System.out.println(
                    """
                            Press:
                            1. Create database for your water deliver company
                            2. Add market
                            3. Add worker
                            4. Add order
                            5. Edit market
                            6. Edit worker
                            7. Get your markets
                            8. Get your workers
                            9. Get your orders
                            10. Get the profit between two days
                            11. Get the amount of contracts that a given worker had
                            12. Drop database
                            13. Exit
                            """
            );

            switcher = scanner.nextInt();

            try {
                switch(switcher){
                    case 1:

                        JDBCHelper.createDBStructure();
                        System.out.println("Database with tables " +
                                "market, workers, orders and History table for this three was created");

                        break;
                    case 2:
                        System.out.println("What is the name of the market: ");
                        name = scanner.next();
                        System.out.println("What is the address of the market: ");
                        address = scanner.next();
                        System.out.println("What much money will this market give us per order: ");
                        money = scanner.nextInt();
                        System.out.println("On which date will his contract expire(yyyy-MM-dd): ");
                        try {
                            date = (Date) formatter.parse(scanner.next());
                        } catch (ParseException e) {
                            throw new RuntimeException(e);
                        }
                        new Market(name, address, money, date);
                        break;
                    case 3:
                        System.out.println("What is the name of the worker: ");
                        name = scanner.next();
                        System.out.println("What is the EGN of the worker: ");
                        egn = scanner.next();
                        System.out.println("What is the salary per order of this worker: ");
                        money = scanner.nextInt();
                        System.out.println("On which date will his contract expire(yyyy-MM-dd): ");
                        try {
                            date = (Date) formatter.parse(scanner.next());
                        } catch (ParseException e) {
                            throw new RuntimeException(e);
                        }
                        new Workers(name, egn, money, date);
                        break;
                    case 4:
                        System.out.println("What is the EGN of the worker who have to complete the order: ");
                        egn = scanner.next();
                        System.out.println("What is the address of the market where he have to go: ");
                        address = scanner.next();
                        new Orders(egn, address);
                        break;
                    case 5:
                        System.out.println("\nWhat is the current address of the market you want to edit : ");
                        address = scanner.next();
                        System.out.println("\nWhat is the new name of the market : ");
                        name = scanner.next();
                        System.out.println("\nWhat is the new address of the market : ");
                        address1 = scanner.next();
                        System.out.println("\nWhat is the new money per order that we will receive from the market : ");
                        money = scanner.nextInt();
                        System.out.println("\nOn which date will this market new contract expire(yyyy-MM-dd): ");
                        try {
                            date = (Date) formatter.parse(scanner.next());
                        } catch (ParseException e) {
                            throw new RuntimeException(e);
                        }
                        Market.editMarket(address1, name, address, money, date);
                        break;
                    case 6:
                        System.out.println("\nWhat is the current EGN of the worker you want to edit : ");
                        egn = scanner.next();
                        System.out.println("\nWhat is the new name of the worker : ");
                        name = scanner.next();
                        System.out.println("\nWhat is the new EGN of the worker : ");
                        egn1 = scanner.next();
                        System.out.println("\nWhat is the new salary per order of the worker : ");
                        money = scanner.nextInt();
                        System.out.println("\nOn which date will his new contract expire(yyyy-MM-dd): ");
                        try {
                            date = (Date) formatter.parse(scanner.next());
                        } catch (ParseException e) {
                            throw new RuntimeException(e);
                        }
                        Workers.editWorker(egn1, name, egn, money, date);
                        break;
                    case 7:

                        Market.getMarket();

                        break;
                    case 8:

                        Workers.getWorkers();

                        break;
                    case 9:

                        Orders.getOrders();

                        break;
                    case 10:
                        System.out.println("\nWhat is the first date: ");
                        try {
                            date = (Date) formatter.parse(scanner.next());
                        } catch (ParseException e) {
                            throw new RuntimeException(e);
                        }
                        System.out.println("\nWhat is second first date: ");
                        try {
                            date1 = (Date) formatter.parse(scanner.next());
                        } catch (ParseException e) {
                            throw new RuntimeException(e);
                        }
                        System.out.println(JDBCHelper.getProfitBetweenTwoDays(date, date1));
                        break;
                    case 11:
                        System.out.println("What is the EGN of the worker: ");
                        egn = scanner.next();
                        Workers.getNumOfAllTimeContractsOfAGivenWorker(egn);
                        break;
                    case 12:
                        JDBCHelper.dropDatabase();
                        System.out.println("Database dropped");
                        break;
                    case 13:
                        break;
                }
            } catch (Exception e)
            {
                System.out.println(e.getMessage());
            }
        }
    }
}