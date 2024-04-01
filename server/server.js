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







  const userSchema = new Schema({
    username: { type: String, required: true },
    email: { type: String, required: true },
    password: { type: String, required: true }
  });
  
  const User = mongoose.model('User', userSchema);
  
  app.post('/register', async (req, res) => {
    try {
      const { username, email, password } = req.body;
  
      // Check if username, email, and password are provided
      if (!username || !email || !password) {
        return res.status(400).json({ error: 'Username, email, and password are required' });
      }
  
      // Check if user with the same email already exists
      const existingUser = await User.findOne({ email: email });
      if (existingUser) {
        return res.status(400).json({ error: 'Email already exists' });
      }
  
      // Create a new user document
      const newUser = new User({
        username,
        email,
        password
      });
  
      // Save user record to the database
      await newUser.save();
  
      res.status(201).json({ message: 'User registered successfully' });
    } catch (error) {
      console.error('Error registering user:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });











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
// Define MongoDB Schema for patient test records
const patientTestSchema = new mongoose.Schema({
  patientId: { type: mongoose.Schema.Types.ObjectId, ref: 'Patient' }, // Reference to Patient model
  patientName: String,
  diastolicReadings: Number,
  systolicReadings: Number,
  symptoms: String
});

// Define MongoDB Model for patient test records
const PatientTest = mongoose.model('PatientTest', patientTestSchema);

// Endpoint to add patient test record
app.post('/addPatientTest/:patientId', async (req, res) => {
  try {
    const patientId = req.params.patientId;
    const { testDiastolic, testSystolic, testSymptoms } = req.body;

    // Fetch patient details by ID to get the name
    const patient = await Patient.findById(patientId);

    if (!patient) {
      return res.status(404).json({ error: 'Patient not found' });
    }

    // Create a new patient test document
    const newPatientTest = new PatientTest({
      patientId,
      patientName: patient.name, // Include patient's name
      diastolicReadings: testDiastolic,
      systolicReadings: testSystolic,
      symptoms: testSymptoms
    });

    // Save patient test record to the database
    await newPatientTest.save();

    res.status(201).json({ message: 'Patient test record added successfully' });
  } catch (error) {
    console.error('Error adding patient test record:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});


// Endpoint to get patient test records by patient ID
app.get('/patientTests/:patientId', async (req, res) => {
  try {
    const patientId = req.params.patientId;

    // Fetch all patient test records for a specific patient from the database
    const patientTests = await PatientTest.find({ patientId }).populate('patientId', 'name');

    res.status(200).json(patientTests);
  } catch (error) {
    console.error('Error fetching patient test records:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});




// Start the server connection
const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
