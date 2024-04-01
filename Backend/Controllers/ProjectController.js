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
          console.log('Se ha vinculado: '+error);
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

  /**
   * Metodo para comprobar si la peticion recibida es de un usuario que tiene acceso al servidor,
   * puede ser mediante un token de Amazon o un token de Firebase.
   * @param {string} strAmazonUID
   * @param {string} firebaseUID
   */
  async userAllowedForServerRequests(strAmazonUID, firebaseUID) {
    let bAccess = false;

    // En caso de que no se reciba ningun parametro, devolvemos false
    if (strAmazonUID === undefined && firebaseUID === undefined) {
      bAccess = false;
    }
    // Si se recibe un UID de Amazon, comprobamos si esta enlazado a un usuario de firebase
    if (strAmazonUID) {
      const response = await this.isLinked(strAmazonUID);
      bAccess = response.linked;
      if (response.linked) {
        return bAccess;
      }
    }


    // Si solo recibimos un UID de firebase, comprobamos que existe un usuario con ese UID
    // Ya que el usuario solo funciona si :
    // 1. Existe en la base de datos de AlexaUsers, implica que se ha vinculado con Amazon
    // 2. Existe en la base de datos de Alguno de los proyectos, implica que se ha vinculado con un proyecto
    // Solo necesitamos uno de los dos para que la peticion sea valida, ya que siempre que se hagan peticiones
    // se comprobara que el usuario tiene acceso a ese proyecto.
    if (firebaseUID) {
      const projectsCol = collection(this.firebaseDB, 'AlexaUsers');
      const projectSnapShot = await getDocs(projectsCol);
      const projectList = projectSnapShot.docs.map((doc) => doc.data());
      // Comprobamos si el usuario esta en la base de datos de AlexaUsers
      const alexaUser = projectList.find((p) => p.firebaseUID === firebaseUID);

      if (alexaUser) {
        bAccess = true;
      } else {
        // Si no esta en la base de datos de AlexaUsers, comprobamos si esta en algun proyecto
        const projectsCol = collection(this.firebaseDB, 'projects');
        const projectSnapShot = await getDocs(projectsCol);
        const projectList = projectSnapShot.docs.map((doc) => doc.data());
        // Comprobamos si es owner o esta en la lista de miembros de algun proyecto
        const project = projectList.find((p) => p.owner === firebaseUID || p.members.includes(firebaseUID));
        if (project) {
          bAccess = true;
        } else {
          bAccess = false;
        }
      }
    }
    return bAccess;
  }
}
module.exports = ProjectController;
