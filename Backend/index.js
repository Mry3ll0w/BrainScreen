
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

/** Metodo para vincular un usuario de amazon a un proyecto,
    se recibe por parametros el nombre del proyecto y el UID de amazon.
 */
nodeServer.patch('/bindAmazonUserToProject', async (req, res) => {
  try {
    console.log(req.body);
    const {projectName, amazonUID} = req.body;

    const projectController = new ProjectController(DB);
    const response = await projectController.linkAmazonUserToProject(projectName
        , amazonUID);
    if (!response) {
      res.send('Error linking user to project');
    } else {
      res.send('User linked to project');
    }
  } catch (e) {
    console.log(e);
  }
});


nodeServer.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
