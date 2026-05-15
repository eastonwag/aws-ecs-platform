const express = require('express');
const { Pool } = require('pg');

const app = express();
app.use(express.json());

// Database connection
const pool = new Pool({
    host:     process.env.DB_HOST,
    database: process.env.DB_NAME,
    user:     process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    port:     process.env.DB_PORT || 5432,
    ssl: {
      rejectUnauthorized: false
    }
  });
  
// Health check — ALB will use this to verify the container is alive
app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

// Get all jobs
app.get('/jobs', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM jobs ORDER BY created_at DESC');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// Create a job
app.post('/jobs', async (req, res) => {
  const { title, company, status } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO jobs (title, company, status) VALUES ($1, $2, $3) RETURNING *',
      [title, company, status || 'applied']
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});