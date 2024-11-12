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


    static async updateChartValue(projectName, index, datamap) {
    let resValue = null;
    
    try {
        const database = getDatabase();
        const urlPath = '/lienzo/' + projectName + '/charts/' + index;
        
        // Sanitize keys in datamap
        const sanitizedData = Object.fromEntries(
            Object.entries(datamap).map(([key, value]) => {
                let sanitizedKey = key.replace(/[^a-zA-Z0-9]/g, '_');
                if (sanitizedKey === '') sanitizedKey = 'value';
                return [sanitizedKey, value];
            })
        );
        
        // Write the new data
        const updates = {
            [`${urlPath}/data`]: datamap
        };

        await update(ref(database), updates);

    } catch (error) {
        console.error(error);
    }

    return resValue;
}




}
module.exports = ChartController;
