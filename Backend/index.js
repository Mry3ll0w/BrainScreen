
// Firebase Conf
//
// Import the functions you need from the SDKs you need
const {initializeApp} = require('firebase/app');

// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: 'AIzaSyDz56r7_GQbyRzoRcqgx5tVYrZ0vDiYmfM',
  authDomain: 'brainscreen-d8e47.firebaseapp.com',
  databaseURL: 'https://brainscreen-d8e47-default-rtdb.europe-west1.firebasedatabase.app',
  projectId: 'brainscreen-d8e47',
  storageBucket: 'brainscreen-d8e47.appspot.com',
  messagingSenderId: '1015440539097',
  appId: '1:1015440539097:web:abb4600b0adc399dfaadc8',
  measurementId: 'G-0YN07ZCN7C',
};

// Initialize Firebase
const firebaseApp = initializeApp(firebaseConfig);
const {getFirestore, collection, getDocs} = require('firebase/firestore');
const DB = getFirestore(firebaseApp);
const ProjectController = require('./Controllers/ProjectController');

// Express Server initialization
const express = require('express');
const axios = require('axios');

const nodeServer = express();
const port = 3000;


// Configuration
nodeServer.use(express.json());

nodeServer.get('/', async (req, res) => {
  try {
    const projectsCol = collection(DB, 'projects');
    const projectSnapShot = await getDocs(projectsCol);
    const projectList = projectSnapShot.docs.map((doc) => doc.data());
    res.send(projectList);
  } catch (e) {
    console.log(e);
  }
});

nodeServer.patch('/bindAmazonToProject', async (req, res) => {
  try {
    const {projectName, firebaseUID, amazonUID} = req.body;
    const projectController = new ProjectController(DB);
    await projectController.linkAmazonUserToProject(projectName, firebaseUID, amazonUID);
    // '6EGHD6ZJaOerB3Lj2kDw', 'amzn1.ask.account.AMA4DUVCMGVZQ7NUYRKXEFIFU6IISFRK6WLMGROUFI3AVYQF2SPMN4SP3GEHYMUF72T5AD37G7TDL6TR6FH37IYNO5UNH5UM2GF4QGZECCX3DAYJRIOTS7RNM4FUNGSLLH3RBOMQ27ISPA3GDYC6WTOH62SCFRNIS2N4J5QW433ZVUUVFQ4EMWIQGJMARR3EPYKA5DHWZ5E7WLETRUOPULB4YTPPNK7W7BYGLH4GFRSA');
    res.send('User linked to project');
  } catch (e) {
    console.log(e);
  }
});

nodeServer.patch('/prueba', async (req, res) => {
  try {
    console.log(req.body);
    // Obtengo los parametros recibidos
    // const {amazonUID, projectName, firebaseUID} = req.body;

    res.send('hola desde /prueba, se recibe: ');
  } catch (e) {
    console.log(e);
  }
});

nodeServer.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
