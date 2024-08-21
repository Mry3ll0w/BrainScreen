/* eslint-disable max-len */
const {collection, getDocs, updateDoc, doc} = require('firebase/firestore');
const { initializeApp } =require ("firebase/app");
const { getDatabase,ref,onValue } = require("firebase/database");

const firebaseConfig = {
  // The value of `databaseURL` depends on the location of the database
    databaseURL: "https://brainscreen-d8e47-default-rtdb.europe-west1.firebasedatabase.app/",
};





/**
 * Class Used to interact with Projects that are located on firebase.
 */
class ButtonController {
    /**
   * Contructor que guarda la instancia de base de datos de firebase,
   * para su uso en los metodos de la clase.
   * @param {getFirestore} DB
   */
    
    database = getDatabase();

    /**
    Función encargada de obtener el valor de un botón.
     */
    async getButtonValue(projectName, buttonLabel, DB){

        //Fetch database 

        //Search for btn

        // if exists return value else return null
        
        
        const starCountRef = ref(this.database, '/lienzo' + projectName + '/buttons');
        onValue(starCountRef, (snapshot) => {
            const data = snapshot.val();
            console.table(data);
        });

    }


}
module.exports = ButtonController;
