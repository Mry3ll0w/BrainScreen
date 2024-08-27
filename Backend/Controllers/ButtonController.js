/* eslint-disable max-len */
const {collection, getDocs, updateDoc, doc} = require('firebase/firestore');
const { initializeApp } =require ("firebase/app");
const { getDatabase,ref,get,onValue,child } = require("firebase/database");

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
    static async getButtonValue(projectName, buttonLabel){

        //Fetch database 

        //Search for btn

        // if exists return value else return null
        const resValue = {value: null};

        const dbRef = ref(this.database);
        get(child(dbRef, `/lienzo/${projectName}/buttons`)).then((snapshot) => {
            if (snapshot.exists()) {
                for (const key in snapshot.val()) {
                    console.log(snapshot.val()[key])
                    if (snapshot.val()[key].labelText === buttonLabel) {
                        console.log('Boton encontrado')
                        var button = snapshot.val()[key];
                        if(button.type == '1'){
                            resValue.value = button.value;
                        }else{
                            resValue.value = 'elevated';//Si es elevated no sirve para obtener el valor
                        }
                    }
                }
                
            } else {
                return resValue;
            }
        }).catch((error) => {
            console.error(error);
            return resValue;
    });

    }


}
module.exports = ButtonController;
