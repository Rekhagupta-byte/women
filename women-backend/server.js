require("dotenv").config(); // Load environment variables
const express = require("express");
const cors = require("cors");
const sqlite3 = require("sqlite3").verbose();
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const app = express();
app.use(cors());
app.use(express.json());

// ✅ Connect to SQLite Database
const db = new sqlite3.Database("./database/women.db", (err) => {
  if (err) {
    console.error("❌ Database connection error:", err.message);
  } else {
    console.log("✅ Connected to SQLite database!");
  }
});

// ✅ Create Users and Friends Tables
db.serialize(() => {
  db.run(
    `CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      dob TEXT NOT NULL,
      location TEXT NOT NULL,
      password TEXT NOT NULL
    )`
  );

  db.run(
    `CREATE TABLE IF NOT EXISTS friends (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      phone_number TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
    )`
  );
});

// ✅ Home Route
app.get("/", (req, res) => {
  res.send("Women Security App Backend is Running!");
});

// ✅ Register New User
app.post("/api/register", async (req, res) => {
  const { name, email, dob, location, password } = req.body;
  if (!name || !email || !dob || !location || !password) {
    return res.status(400).json({ error: "All fields are required" });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const sql = `INSERT INTO users (name, email, dob, location, password) VALUES (?, ?, ?, ?, ?)`;

    db.run(sql, [name, email, dob, location, hashedPassword], function (err) {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: "User registered successfully", userId: this.lastID });
    });
  } catch (error) {
    res.status(500).json({ error: "Server error while hashing password" });
  }
});

// ✅ Login User
app.post("/api/login", (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: "Email and password are required" });
  }

  db.get("SELECT * FROM users WHERE email = ?", [email], async (err, user) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!user) return res.status(401).json({ error: "Invalid credentials" });

    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) return res.status(401).json({ error: "Invalid credentials" });

    const token = generateToken(user);
    res.json({ message: "Login successful", token });
  });
});

// ✅ Fetch All Users (Protected Route)
app.get("/api/users", authenticateToken, (req, res) => {
  db.all("SELECT id, name, email, dob, location FROM users", [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// ✅ Add Friend
app.post("/api/add-friend", authenticateToken, (req, res) => {
  const { user_id, phone_number } = req.body;
  if (!user_id || !phone_number) {
    return res.status(400).json({ error: "User ID and phone number are required" });
  }

  db.run("INSERT INTO friends (user_id, phone_number) VALUES (?, ?)", [user_id, phone_number], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: "Friend added successfully", friendId: this.lastID });
  });
});

// ✅ Get Friend List
app.get("/api/friends/:user_id", authenticateToken, (req, res) => {
  const { user_id } = req.params;
  db.all("SELECT * FROM friends WHERE user_id = ?", [user_id], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// ✅ Delete Friend
app.delete("/api/delete-friend/:id", authenticateToken, (req, res) => {
  const { id } = req.params;
  db.run("DELETE FROM friends WHERE id = ?", [id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: "Friend deleted successfully" });
  });
});

// ✅ Send SOS Alert (Example Route)
app.post("/api/sos", authenticateToken, (req, res) => {
  const { user_id, location } = req.body;
  if (!user_id || !location) {
    return res.status(400).json({ error: "User ID and location are required" });
  }

  db.all("SELECT phone_number FROM friends WHERE user_id = ?", [user_id], (err, contacts) => {
    if (err) return res.status(500).json({ error: err.message });
    if (contacts.length === 0) return res.status(404).json({ error: "No friends found" });

    // TODO: Implement SMS API
    res.json({ message: "SOS alert sent to friends", contacts });
  });
});

// ✅ Middleware to authenticate token
function authenticateToken(req, res, next) {
  const authHeader = req.header("Authorization");
  const token = authHeader && authHeader.split(" ")[1];
  if (!token) return res.status(401).json({ error: "Access denied. No token provided." });

  jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
    if (err) return res.status(403).json({ error: "Access denied. Invalid token." });
    req.user = user;
    next();
  });
}

// ✅ Function to generate JWT token
function generateToken(user) {
  return jwt.sign({ userId: user.id, email: user.email }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: "1h" });
}

// ✅ Start Server
app.listen(5000, () => {
  console.log("✅ Server running on port 5000");
});
