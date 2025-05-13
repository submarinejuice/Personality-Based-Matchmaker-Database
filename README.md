**The Personality-Based Matchmaking System**

A Java-MySQL application designed to match users based on their personality traits, 
interests, and interaction data. Users are paired through calculated compatibility scores derived from psychological profiling
and shared preferences. The system integrates CRUD operations, relational algebra logic, and an interactive UI menu to simulate a 
real-world matchmaking app backend.

**📊 Features**

Relational Database Design: Normalized schema with 10+ interconnected tables
Compatibility Matching: Calculates and ranks users based on personality test scores
Query Menu System: Built-in interface for creating, populating, and querying the database
Personality Types: Ranges from Big Five traits (OCEAN) to fun social labels like “Peppy” and “Cranky”
Activity Logging: Tracks user interactions and behavior over time
Full CRUD Functionality: Create, Read, Update, Delete operations on all core entities
Relational Algebra Translation: SQL queries mapped to formal RA expressions for learning clarity

**🗃️ Database Schema**

User, PersonalityTypes, PersonalityProfile, Matches, InteractionHistory
UserPreferences, Interests, UserInterests, ActivityLog, Compatibility
Example Entity Relationships:

A User can have multiple Interests, Preferences, and Interactions
Personality profiles drive compatibility, which fuels the match suggestions
🛠️ Installation & Setup

**Requirements:** Java, MySQL, MySQL JDBC Connector, VSCode (recommended)

**📁 Project Structure**
MySQLJavaApp/

├── MySQLMenuApp.java
├── lib/
│   └── mysql-connector-j-8.3.0.jar


**⚙️ Run Instructions**
Clone the repo or download the files
Make sure MySQL server is running
Place the JDBC connector in the /lib folder
Compile with:
Windows:

javac -cp "lib/*" MySQLMenuApp.java
java -cp "lib/*;." MySQLMenuApp
macOS:

javac -cp "lib/*" MySQLMenuApp.java
java -cp "lib/*:." MySQLMenuApp
For GUI version (MyGUILore.java), update classpaths accordingly.
**
🧪 Sample Queries (SQL + Relational Algebra)
**
Find compatible matches with score > 80
List interests of a specific user
Retrieve all users who share interests with a given user
Log latest user activity
Get full personality profiles and scores


The system includes a Java console and GUI version for database interaction and testing.

🙌 Acknowledgments
Built with ❤️ by Michelle Chala & Aidan Lin
