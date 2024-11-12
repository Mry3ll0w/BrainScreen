/* eslint-disable max-len */
const {collection, getDocs, updateDoc, doc} = require('firebase/firestore');
const { initializeApp } =require ("firebase/app");
const { getDatabase,ref,get,onValue,child } = require("firebase/database");
const { database } = require('firebase-admin');

const firebaseConfig = {
  // The value of `databaseURL` depends on the location of the database
    databaseURL: "https://brainscreen-d8e47-default-rtdb.europe-west1.firebasedatabase.app/",
};





/**
 * Class Used to interact with Projects that are located on firebase.
 */
class ChartController {
    /**
   * Contructor que guarda la instancia de base de datos de firebase,
   * para su uso en los metodos de la clase.
   * @param {getFirestore} DB
   */

    /**
    Función encargada de obtener el valor de un botón.
     */
    static async getButtonValue(projectName, buttonLabel, DB) {
        let resValue = null;
    
        try {
            const database = getDatabase();
            const urlPath = '/lienzo/' + projectName + '/buttons';
        
            const snapshot = await get(ref(database, urlPath));
        
            if (snapshot.exists()) {
                for (const key in snapshot.val()) {
                    if (snapshot.val()[key].labelText.toLowerCase() === buttonLabel.toLowerCase()) {
                        var button = snapshot.val()[key];
                    
                        if(button.type === '1'){
                            resValue = button.value;
                            break;
                        }else{
                            resValue = 'elevated'; // Si es elevated no sirve para obtener el valor
                        }
                    }
                }
            }
        } catch (error) {
            console.error(error);
        }

        return resValue;
    }


    //Funcion para Agregar Datos al chart
    static async updateChartValue(projectName, index, datamap) {
        let resValue = null;
    
        try {
            const database = getDatabase();
            const urlPath = '/lienzo/' + projectName + '/charts/'+index;
            
            const snapshot = await get(ref(database, urlPath));
            
            if (snapshot.exists()) {
                // Al existir la referencia simplement la actualizamos
                datamap.forEach((x,y) => {
                    
                });
            }
        } catch (error) {
            console.error(error);
        }

        return resValue;
    }


}
module.exports = ChartController;
