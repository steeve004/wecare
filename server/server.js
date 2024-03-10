const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

// Initialize Express app
const app = express();

// Middleware
app.use(bodyParser.json());

// Log middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

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

// Endpoint to get patient details
app.get('/patients', async (req, res) => {
  try {
    // Fetch all patient records from the database
    const patients = await Patient.find();
    
    res.status(200).json(patients);
  } catch (error) {
    console.error('Error fetching patient details:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint to delete a patient record by ID
app.delete('/patients/:id', async (req, res) => {
  try {
    const patientId = req.params.id;

    // Find the patient by ID and delete it from the database
    await Patient.findByIdAndDelete(patientId);

    res.status(200).json({ message: 'Patient record deleted successfully' });
  } catch (error) {
    console.error('Error deleting patient record:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Endpoint to edit patient details by ID
app.put('/patients/:id', async (req, res) => {
  try {
    const patientId = req.params.id;
    const { name, gender, age, diagnosis } = req.body;

    // Find the patient by ID and update its details
    const updatedPatient = await Patient.findByIdAndUpdate(
      patientId,
      { name, gender, age, diagnosis },
      { new: true }
    );

    if (!updatedPatient) {
      return res.status(404).json({ error: 'Patient not found' });
    }

    res.status(200).json({ message: 'Patient record updated successfully', patient: updatedPatient });
  } catch (error) {
    console.error('Error updating patient record:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});




// Start the server connection
const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
