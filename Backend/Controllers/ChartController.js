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
    static async getChartData(url) {
        let resValue = null;
    
        try {
            const database = getDatabase();
            
        
            const snapshot = await get(ref(database, url));
            
            return snapshot.val();
            // if (snapshot.exists()) {
            //     for (const key in snapshot.val()) {
            //         if (snapshot.val()[key].labelText.toLowerCase() === buttonLabel.toLowerCase()) {
            //             var chart = snapshot.val()[key];
            //             return chart.data;
                        
            //         }
            //     }
            // }
        } catch (error) {
            console.error(error);
        }

        return resValue;
    }


    static async updateChartValue(projectName, index, xValues, yValues) {
    let resValue = null;
    //const chpoints = await this.getChartData(urlPath);
    try {
        const database = getDatabase();
        const urlPath = '/lienzo/' + projectName + '/charts/' + index + '/data';
        const {x,y} = await this.getChartData(urlPath);
        
        
        const newData = {
            x: (x || []).concat(xValues),
            y: (y || []).concat(yValues)
        };
        console.log(newData, {valoresX: xValues, valoresY: yValues})
        
        // Write the new data
        const updates = {
            [`${urlPath}/x`]: newData.x,
            [`${urlPath}/y`]: newData.y,
        };
        await update(ref(database), updates);

    } catch (error) {
        console.error(error);
    }

    return resValue;
}




}
module.exports = ChartController;
