const express = require('express');
const mongoose = require('mongoose');

const SERVER_NAME = 'WeCare-App';
const PORT = 8000;
const HOST = '127.0.0.1';

const app = express();
app.use(express.json()); // Middleware to parse JSON bodies

const uristring = 'mongodb+srv://adegbesansteeve:test@cluster1.ts2lvbp.mongodb.net/';

mongoose.connect(uristring, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log(`Connected to database: ${uristring}`))
  .catch(err => console.error('Connection error:', err));

// Define user schema
const userSchema = new mongoose.Schema({
    fullname: String,
    email: String,
    password: String
  });
  
  // User Model
  const User = mongoose.model('User', userSchema);
  

// Sign-up Endpoint
app.post('/signup', async (req, res) => {
  try {
    const { fullname, email, password } = req.body;
    const newUser = new User({ fullname, email, password });
    await newUser.save();
    res.status(201).send('User created successfully');
  } catch (error) {
    console.error(error);
    res.status(500).send('Server Error');
  }
});

app.listen(PORT, HOST, () => {
  console.log(`${SERVER_NAME} server running at http://${HOST}:${PORT}`);
});
