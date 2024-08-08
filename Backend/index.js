
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
    console.log('peticion desde: ' + req.ip);
    if (projectList.length === 0) {
      res.status(200).send({database: 'error'});
    } else {
      res.status(200).send({database: 'ok'});
    }
  } catch (e) {
    console.log(e);
  }
});

/** Metodo para vincular un usuario de amazon a un proyecto,
    se recibe por parametros el nombre del proyecto y el UID de amazon.
    TODOS TIENEN QUE TENER AL MENOS UN FIREBASEUID O UN AMAZONUID
 */
nodeServer.patch('/bindAmazonUserToProject', async (req, res) => {
  try {
    console.log(req.body);
    const {projectName, amazonUID, firebaseUID} = req.body;
    // Comprobamos requisitos de Seguridad
    if (firebaseUID === undefined || amazonUID === undefined) {
      res.send('No accesible', 403);
    }

    // Con el controlador de proyectos comprobamos si el usuario tiene acceso
    const projectController = new ProjectController(DB);

    const allowed = await projectController.
        userAllowedForServerRequests(amazonUID, firebaseUID);
    if (!allowed) {
      res.status(403).send('No accesible');
    } else {
      const response = await projectController.
          linkAmazonUserToProject(projectName, amazonUID);
      if (response) {
        res.send('Error linking user to project');
      } else {
        res.send('User linked to project');
      }
    }
  } catch (e) {
    console.log(e);
  }
});

/** Metodo para comprobar si el existe esa cuenta de amazon en nuestra
    base de datos.
*/
nodeServer.get('/isLinked/:amazonUID', async (req, res) => {
  // Obtenemos los parametros
  const {amazonUID} = req.params;
  // Si no recibimos el UID de amazon, devolvemos un error para que el cliente
  // sepa que no se ha recibido el parametro
  if (amazonUID === undefined) {
    res.send('Error', 400);
  } else {
    try {
      // Grueso de la funcion, comprobamos si el usuario esta en la DB
      const projectController = new ProjectController(DB);
      const response = await projectController.isLinked(amazonUID);
      console.log(`Recibidos los parametros ${amazonUID}`);
      console.table(response);
      if (response.error) {
        res.send({error: false, linked: false}, 500);
      } else {
        res.send({error: false, linked: response.linked});
      }
    } catch (e) {
      res.send({error: true}, 500);
      console.log(e);
    }
  }
});

// Testing to if auth works with post etc
nodeServer.put('/test', async (req, res) => {
  const {firebaseuid, amazonuid}= req.headers;
  console.table({body: req.body, peticion: 'PUT'});
  try {
    if (firebaseuid === undefined || amazonuid === undefined) {
      res.status(403).send({res: 'test is error due to unauthorized'});
    } else {
      const projectController = new ProjectController(DB);
      // Check if user has access
      const bUserAllowed = await projectController.
          userAllowedForServerRequests(amazonuid, firebaseuid);
      if (!bUserAllowed) {
        res.status(403).send({res: 'test is error, user not allowed'});
      }
      res.status(200).send({res: 'test is ok'});
    }
  } catch (e) {
    console.log(e);
  }
});


// Example to let the users test the post method 
nodeServer.post('/test', async (req, res) => {
  const {firebaseuid, amazonuid}= req.headers;
  console.table({body: req.body, peticion: 'POST'});
  try {
    if (firebaseuid === undefined || amazonuid === undefined) {
      res.status(403).send({res: 'test is error due to unauthorized'});
    } else {
      const projectController = new ProjectController(DB);
      // Check if user has access
      const bUserAllowed = await projectController.
          userAllowedForServerRequests(amazonuid, firebaseuid);
      if (!bUserAllowed) {
        res.status(403).send({res: 'test is error, user not allowed'});
      }
      res.status(200).send({res: 'test is ok'});
    }
  } catch (e) {
    console.log(e);
  }
});

nodeServer.listen(port, () => {
  console.log(`Servidor Backend en el puerto ${port}`);
});
