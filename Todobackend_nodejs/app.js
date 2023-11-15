const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'todo',
});


const app = express();


app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


app.post('/register', (req, res) => {
  const { username, email, password } = req.body;
  console.log(username,email,password);
  pool.query(
    'INSERT INTO user (username, email, pass) VALUES (?, ?, ?)',
    [username, email, password],
    (err, results) => {
      if (err) {
        console.error(err);
        res.status(500).json({ message: 'Internal server error' });
      } else {
        res.json({ message: 'User registered successfully' });
      }
    }
  );
});
app.post('/login', (req, res) => {
  const { email, password } = req.body;
  // Fetch user data from MySQL database
  pool.query(
    'SELECT * FROM user WHERE email = ? AND pass = ?',
    [email, password],
    (err, results) => {
      if (err) {
        console.error(err);
        res.status(500).json({ message: 'Internal server error' });
      } else {
        if (results.length > 0) {
          res.json({ message: 'Login successful', user: results[0] });
        } else {
          res.status(401).json({ message: 'Invalid username or password' });
        }
      }
    }
  );
});


app.post('/todos', (req, res) => {
  const { email ,todo } = req.body;
  console.log(email,todo);
  pool.query(
    'INSERT INTO todos ( email, todolist) VALUES (?, ?)',
    [email,todo],
    (err, results) => {
      if (err) {
        console.error(err);
        res.status(500).json({ message: 'Internal server error' });
      } else {
        res.json({ message: 'User registered successfully' });
      }
    }
  );
});

app.get("/getUserData/:email",(req,res)=>{
       const email = req.params.email;


       pool.getConnection((err,connection)=>{

        if(err){
          console.error("Error getting database connection :",err);
          res.status(500).json({error:"Internal Server"});
          return;
        }

        const query = 'SELECT todolist FROM todos WHERE email = ?';
        connection.query(query,[email],(err,results)=>{
            if (err){

              console.error("Error querying database :",err);
              res.status(500).json({error: "Internal server error"});
            }
            res.status(200).json(results);
          }
        );
       });



});


app.listen(5000, () => {
  console.log('Server running on http://Santhose:5000');
});