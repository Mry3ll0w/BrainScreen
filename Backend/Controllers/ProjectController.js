/* eslint-disable max-len */
const {collection, getDocs, updateDoc, doc} = require('firebase/firestore');

/**
 * Class Used to interact with Projects that are located on firebase.
 */
class ProjectController {
  /**
   * Contructor que guarda la instancia de base de datos de firebase,
   * para su uso en los metodos de la clase.
   * @param {getFirestore} DB
   */
  constructor(DB) {
    this.firebaseDB = DB;
  }

  /**
* Method to link an amazonUSER to a project.
* @param {string} strProjectName Project's name to link the user to.
* @param {string} strAmazonUID Amazon UID of the user to link to the project.
* @return {boolean} True if the operation was successful, false otherwise.
*/
  async linkAmazonUserToProject(strProjectName, strAmazonUID) {
    // Definimos una variable de control de errores
    let error = false;
    // Comprobamos que no esten vacios los parametros recibidos
    if (strProjectName && strAmazonUID) {
      try {
        // Usamos el objeto DB para agregar a projects el usuario de amazon
        const projectsCol = collection(this.firebaseDB, 'projects');
        const projectSnapShot = await getDocs(projectsCol);
        const projectList = projectSnapShot.docs.map((doc) =>({id: doc.id,
          ...doc.data()}));
        // Buscamos el proyecto con el nombre recibido
        const project = projectList.find((p) => p.name === strProjectName);

        if (project) {
        // Si el proyecto existe, actualizamos el campo alexaUserID con el valor recibido
          const projectDoc = doc(this.firebaseDB, 'projects', project.id);
          await updateDoc(projectDoc, {
            alexaUserID: strAmazonUID,
          });
        } else {
          error = true;
          console.log('Project not found');
        }
      } catch (e) {
        error = true;
        console.log(e);
      }
    }
    return error;// Devolvemos el estado de la operacion
  }


  /**
   * Method to count the number of projects that are linked to an Amazon user.
   * @param {string} strAmazonUID Amazon UID of the user to count the projects.
   * @return {{error: boolean, count: number}} Object containing the error status and the count of linked projects.
   */
  async countProjectsLinkedToAmazonUser(strAmazonUID) {
    let error = false;
    let count = 0;
    if (strAmazonUID) {
      try {
        const projectsCol = collection(this.firebaseDB, 'projects');
        const projectSnapShot = await getDocs(projectsCol);
        const projectList = projectSnapShot.docs.map((doc) => doc.data());
        count = projectList.filter((p) => p.alexaUserID === strAmazonUID).length;
      } catch (e) {
        error = true;
        console.log(e);
      }
    }
    return {error, count};
  }

  /** Method that checks if there is a firebaseUser linked to a given AmazonUID.
    * @param {string} strAmazonUID Amazon UID of the user to check if is linked to a firebase user.
    * @return {{error: boolean, linked: boolean, linkedToUser: string}} Object containing the error status, linked status, and linked user.
  */
  async isLinked(strAmazonUID) {
    let error = false;
    let linked = false;
    let linkedToUser='';
    if (strAmazonUID) {
      try {
        const projectsCol = collection(this.firebaseDB, 'AlexaUsers');
        const projectSnapShot = await getDocs(projectsCol);
        const projectList = projectSnapShot.docs.map((doc) => doc.data());
        projectList.some((p) => {
          if (p.amazonUID === strAmazonUID) {
            linkedToUser = p.firebaseUID;
            linked = true;
          } else {
            linked = false;
          }
        });
      } catch (e) {
        error = true;
        console.log(e);
      }
      // console.table({error, linked, linkedToUser});
      return {error, linked, linkedToUser};
    }
    return {error, linked, linkedToUser};
  }
}
module.exports = ProjectController;
