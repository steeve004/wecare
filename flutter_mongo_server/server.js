const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

/* const SERVER_NAME = 'WeCare-App';
const PORT = 8000;
const HOST = '127.0.0.1'; */

const app = express();
app.use(express.json()); // Middleware to parse JSON bodies

mongoose.connect('mongodb+srv://adegbesansteeve:test@cluster1.ts2lvbp.mongodb.net/', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

//const uristring = 'mongodb+srv://adegbesansteeve:test@cluster1.ts2lvbp.mongodb.net/';

/* mongoose.connect(uristring, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log(`Connected to database: ${uristring}`))
  .catch(err => console.error('Connection error:', err)); */

// Define user schema
const userSchema = new mongoose.Schema({
    fullname: String,
    email: String,
    password: String
  });
  
  // User Model
  const User = mongoose.model('User', userSchema);
  
// Create a new user
server.post('/users', function (req, res, next) {
  console.log('POST /users params=>' + JSON.stringify(req.params));
  console.log('POST /users body=>' + JSON.stringify(req.body));

  let newUser = new UsersModel ({
   
    fullname:req.body.fullname, 
    email: req.body.email,
    password: req.body.password, 

  });

  //create the patient and save on db
  newUser.save()
    .then((user)=>{
      console.log("saved patient:" + user);
        //send patient if no issue
        res.send(201, user)
        return next();
    })

    .catch((error)=>{
      console.log("error:" +error);
      return next(new error(JSON.stringify(error.errors)));
    })

  
})


// Sign-up Endpoint
/* app.post('/signup', async (req, res) => {
  try {
    const { fullname, email, password } = req.body;
    const newUser = new User({ 
      
      fullname:req.body.fullname, 
      email: req.body.email,
      password: req.body.password, 
    
    });
    await newUser.save();
    res.status(201).send('User created successfully');
  } 
  
  catch (error) {
    console.error(error);
    res.status(500).send('Server Error');
  }

}); */

/* app.listen(PORT, HOST, () => {
  console.log(`${SERVER_NAME} server running at http://${HOST}:${PORT}`);
}); */

app.listen(8000, () => {
  console.log('Server is running on port 8000');
});
