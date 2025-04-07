const sqlite3 = require("sqlite3").verbose();

// Connect to SQLite database
const db = new sqlite3.Database("./database/women.db", (err) => {
  if (err) {
    console.error("❌ Database connection error:", err.message);
  } else {
    console.log("✅ Connected to SQLite database!");
  }
});

// Create users table
db.run(
  `CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    email TEXT UNIQUE,
    dob TEXT,
    location TEXT
  )`,
  (err) => {
    if (err) console.error("❌ Error creating users table:", err.message);
  }
);

// Create friends table
db.run(
  `CREATE TABLE IF NOT EXISTS friends (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    phone_number TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
  )`,
  (err) => {
    if (err) console.error("❌ Error creating friends table:", err.message);
  }
);

module.exports = db;
