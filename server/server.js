const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

// Initialize Express app
const app = express();

// Middleware
app.use(bodyParser.json());

// MongoDB connection
mongoose.connect('mongodb+srv://Steeve:1234@cluster2.ql5jvik.mongodb.net/', 
{ useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Error connecting to MongoDB:', err));

// Define MongoDB Schema
const patientSchema = new mongoose.Schema({
  name: String,
  gender: String,
  age: Number,
  diagnosis: String
});

// Define MongoDB Model
const Patient = mongoose.model('Patient', patientSchema);

// Endpoint to add patient record
app.post('/addPatient', async (req, res) => {
  try {
    const { name, gender, age, diagnosis } = req.body;
    
    // Create a new patient document
    const newPatient = new Patient({
      name,
      gender,
      age,
      diagnosis
    });

    // Save patient record to the database
    await newPatient.save();

    res.status(201).json({ message: 'Patient record added successfully' });
  } catch (error) {
    console.error('Error adding patient record:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Start the server connection
const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
