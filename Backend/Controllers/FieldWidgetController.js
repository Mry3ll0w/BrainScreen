/* eslint-disable max-len */
const { getDatabase,ref,get,onValue,child,update,push } = require("firebase/database");
const { database } = require('firebase-admin');

const firebaseConfig = {
  // The value of `databaseURL` depends on the location of the database
    databaseURL: "https://brainscreen-d8e47-default-rtdb.europe-west1.firebasedatabase.app/",
};





/**
 * Class Used to interact with Projects that are located on firebase.
 */
class FieldWidgetController {
    /**
   * Contructor que guarda la instancia de base de datos de firebase,
   * para su uso en los metodos de la clase.
   * @param {getFirestore} DB
   */

    /**
    Función encargada de obtener el valor de un botón.
     */
    static async getValue(url) {
        let resValue = null;
    
        try {
            const database = getDatabase();
            
        
            const snapshot = await get(ref(database, url));
            console.log(snapshot.val(), url)
            return snapshot.val();
        } catch (error) {
            console.error(error);
        }

        return resValue;
    }


    static async updateValue(urlPath, newValue) {
    let resValue = true;
    //const chpoints = await this.getChartData(urlPath);
    try {
        const database = getDatabase();
        // Write the new data
        const updates = {
            [`${urlPath}/value`]: newValue,
        };
        await update(ref(database), updates);

    } catch (error) {
        console.error(error);
        return false;
    }

    return resValue;
}




}
module.exports = FieldWidgetController;
