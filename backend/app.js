const express = require('express');
const app = express();
const cors = require('cors');

require('dotenv').config( {path: '.env.local'});
const PORT = process.env.PORT;

//*? Rutas 

//*? Rutas : Users
const userRouter = require('./routes/users/users.router');
const loginRouter = require('./routes/users/login.router');
const calendarRouter = require('./routes/users/calendar.router');
//? Rutas : Patients
const pxRouter = require('./routes/patient/px.router');
const allergysRouter = require('./routes/patient/allergys.router');
const medicationRouter = require('./routes/patient/medications.router'); 
const diseasesRouter = require('./routes/patient/diseases.router'); 
const citasRouter = require('./routes/patient/citas.router'); 

app.use(express.json());
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
}));

//? Use : User 
app.use('/', userRouter);
app.use('/', loginRouter);
app.use('/', calendarRouter);
//? Use : Patient
app.use('/', pxRouter);
app.use('/', allergysRouter);
app.use('/', medicationRouter);  
app.use('/', diseasesRouter); 
app.use('/', citasRouter); 


app.listen(PORT, () => {
  console.log(`http://localhost:${PORT}`);
});


