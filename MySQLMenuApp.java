import java.sql.*;
import java.util.Scanner;

public class MySQLMenuApp {

    private static final String URL = "jdbc:mysql://localhost:3306/personalitymatch";
    private static final String USER = "root";
    private static final String PASSWORD = "IloveTopik889**";
    private static Connection connection;

    public static void main(String[] args) {
        try {
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            Scanner scanner = new Scanner(System.in);

            while (true) {
                System.out.println("\n=== MySQL Application Menu ===");
                System.out.println("1. Create Tables");
                System.out.println("2. Populate Tables");
                System.out.println("3. Query Tables");
                System.out.println("4. Drop Tables");
                System.out.println("5. Exit");
                System.out.print("Choose an option: ");

                int choice = scanner.nextInt();
                scanner.nextLine();  // consume newline

                switch (choice) {
                    case 1:
                        createTables();
                        break;
                    case 2:
                        populateTables();
                        break;
                    case 3:
                        queryTables();
                        break;
                    case 4:
                        dropTables();
                        break;
                    case 5:
                        System.out.println("Exiting application...");
                        scanner.close();
                        connection.close();
                        return;
                    default:
                        System.out.println("Invalid option, please try again.");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 1. Create Tables
    private static void createTables() {
        String createTableSQL = """
                CREATE TABLE IF NOT EXISTS Developers (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(50) NOT NULL,
                    position VARCHAR(50),
                    salary DECIMAL(10, 2)
                );
                """;

        try (Statement stmt = connection.createStatement()) {
            stmt.execute(createTableSQL);
            System.out.println("Table 'Developers' created successfully (if it didn't exist).");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 2. Populate Tables
    private static void populateTables() {
        String insertSQL = """
                INSERT INTO Developers (name, position, salary) VALUES
                ('Aidan', 'Designer', 60000),
                ('Michelle', 'Developer', 65000),
                ('Kareem', 'Tester', 50);
                """;

        try (Statement stmt = connection.createStatement()) {
            int rows = stmt.executeUpdate(insertSQL);
            System.out.println(rows + " rows inserted into Developers.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 3. Query Tables
    private static void queryTables() {
        String querySQL = "SELECT * FROM Developers";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(querySQL)) {

            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            // Header
            for (int i = 1; i <= columnCount; i++) {
                System.out.printf("%-15s", metaData.getColumnName(i));
            }
            System.out.println();

            // Rows
            while (rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    System.out.printf("%-15s", rs.getString(i));
                }
                System.out.println();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 4. Drop Tables
    private static void dropTables() {
        String dropTableSQL = "DROP TABLE IF EXISTS Developers";

        try (Statement stmt = connection.createStatement()) {
            stmt.execute(dropTableSQL);
            System.out.println("Table 'Developers' dropped successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
