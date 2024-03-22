/**
 * Backend para la integreacion de Alexa con la plataforma BrainScreen
 */

// Required Libs
const Alexa = require('ask-sdk-core');
const Axios = require('axios');
// Functions

const LaunchRequestHandler = {
  canHandle(handlerInput) {
    return Alexa.getRequestType(handlerInput.requestEnvelope) === 'LaunchRequest';
  },
  async handle(handlerInput) {
    let speakOutput;
    try {
      const userID = handlerInput.requestEnvelope.context.System.user.userId;
      // Comprobamos si el USUARIO esta linked
      const response = await isLinked(userID);
      // speakOutput = `linked: ${response.linked}, error: ${response.error} \n`


      if (response.linked === false) {
        speakOutput += `No tienes un usuario vinculado, ve a tu perfil y copia este codigo en la seccion de vincular con alexa:\n
                ${userID}\n
                `;
      } else {
        speakOutput += `Bienvenido al panel de control de BrainScreen, en que puedo ayudarte?`;
      }
    } catch (e) {
      console.log(e);
    }
    // AGREGAR OPCION DE LA PRIMERA VEZ Y CREAR CAMPOS DE VINCULACION DE USUARIO A CUENTA DE BrainScreen

    return handlerInput.responseBuilder
        .speak(speakOutput)
        .reprompt(speakOutput)
        .getResponse();
  },
};

const ProjectGeneralStateIntentHandler = {
  canHandle(handlerInput) {
    return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest' &&
            Alexa.getIntentName(handlerInput.requestEnvelope) === 'ProjectGeneralState';
  },
  async handle(handlerInput) {
    const sProjectName = Alexa.getSlotValue(handlerInput.requestEnvelope, 'projectName');
    const userID = handlerInput.requestEnvelope.context.System.user.userId;
    let speakOutput = `Valor projectName ${sProjectName} `;


    try {
      const userID = handlerInput.requestEnvelope.context.System.user.userId;
      const sProjectName = Alexa.getSlotValue(handlerInput.requestEnvelope, 'projectName');


      // Realizamos la peticion para vincular el nombre
      const res = await BrainScreenBindUserToProject(userID, sProjectName);
      /* console.log(res);

            if(res.state && res.linkedUser){
                speakOutput+= ` Recibido el nombre ${sProjectName}, con el status de respuesta ${res.responseStatus}`;
            }else{
                speakOutput +=' Se ha producido un error desconocido, intentelo de nuevo mas tarde.'
            }
            */
    } catch (e) {
      speakOutput = 'Se ha producido un error en la vinculación del usuario al proyecto, por favor intentelo de nuevo mas tarde.';
    }
    return handlerInput.responseBuilder
        .speak(speakOutput)
        .reprompt('El panel de control sigue encendido')
        .getResponse();
  },
};

const BindAmazonUserToProjectHandler = {
  canHandle(handlerInput) {
    return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest' &&
            Alexa.getIntentName(handlerInput.requestEnvelope) === 'BindAmazonUserToProject';
  },
  async handle(handlerInput) {
    const sProjectName = Alexa.getSlotValue(handlerInput.requestEnvelope, 'projectName');
    const userID = handlerInput.requestEnvelope.context.System.user.userId;
    let speakOutput = `Valor projectName ${sProjectName} `;


    try {
      const userID = handlerInput.requestEnvelope.context.System.user.userId;
      const sProjectName = Alexa.getSlotValue(handlerInput.requestEnvelope, 'projectName');


      // Realizamos la peticion para vincular el nombre
      const res = await BrainScreenBindUserToProject(userID, sProjectName);

      if (res.state && res.linkedUser) {
        speakOutput+= `Se ha vinculado esta cuenta de Amazon al proyecto: ${sProjectName}. Disfruta de nuestra app!!`;
      } else {
        speakOutput +=' Se ha producido un error desconocido, intentelo de nuevo mas tarde.';
      }
    } catch (e) {
      speakOutput = 'Se ha producido un error en la vinculación del usuario al proyecto, por favor intentelo de nuevo mas tarde.';
    }
    return handlerInput.responseBuilder
        .speak(speakOutput)
        .reprompt('El panel de control sigue encendido')
        .getResponse();
  },
};
const HelpIntentHandler = {
  canHandle(handlerInput) {
    return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest' &&
            Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.HelpIntent';
  },
  handle(handlerInput) {
    const speakOutput = 'You can say hello to me! How can I help?';

    return handlerInput.responseBuilder
        .speak(speakOutput)
        .reprompt(speakOutput)
        .getResponse();
  },
};

const CancelAndStopIntentHandler = {
  canHandle(handlerInput) {
    return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest' &&
            (Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.CancelIntent' ||
                Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.StopIntent');
  },
  handle(handlerInput) {
    const speakOutput = 'Hasta luego !!';

    return handlerInput.responseBuilder
        .speak(speakOutput)
        .getResponse();
  },
};
/* *
 * FallbackIntent triggers when a customer says something that doesn’t map to any intents in your skill
 * It must also be defined in the language model (if the locale supports it)
 * This handler can be safely added but will be ingnored in locales that do not support it yet
 * */
const FallbackIntentHandler = {
  canHandle(handlerInput) {
    return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest' &&
            Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.FallbackIntent';
  },
  handle(handlerInput) {
    const speakOutput = 'Sorry, I don\'t know about that. Please try again.';

    return handlerInput.responseBuilder
        .speak(speakOutput)
        .reprompt(speakOutput)
        .getResponse();
  },
};
/* *
 * SessionEndedRequest notifies that a session was ended. This handler will be triggered when a currently open
 * session is closed for one of the following reasons: 1) The user says "exit" or "quit". 2) The user does not
 * respond or says something that does not match an intent defined in your voice model. 3) An error occurs
 * */
const SessionEndedRequestHandler = {
  canHandle(handlerInput) {
    return Alexa.getRequestType(handlerInput.requestEnvelope) === 'SessionEndedRequest';
  },
  handle(handlerInput) {
    console.log(`~~~~ Session ended: ${JSON.stringify(handlerInput.requestEnvelope)}`);
    // Any cleanup logic goes here.
    return handlerInput.responseBuilder.getResponse(); // notice we send an empty response
  },
};

const mainBrainScreenHandler = {
  canHandle(handlerInput) {
    return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest' &&
        Alexa.getIntentName(handlerInput.requestEnvelope) === 'BrainScreenMainIntent';
  },
  handle(handlerInput) {
    const speakOutput = 'Alabado sea el dios maquina';

    return handlerInput.responseBuilder
        .speak(speakOutput)
        .reprompt(speakOutput)
        .getResponse();
  },
};


/**
 * Generic error handling to capture any syntax or routing errors. If you receive an error
 * stating the request handler chain is not found, you have not implemented a handler for
 * the intent being invoked or included it in the skill builder below
 * */
const ErrorHandler = {
  canHandle() {
    return true;
  },
  handle(handlerInput, error) {
    const speakOutput = 'Error encontrando el endpoint seleccionado';
    console.log(`~~~~ Error handled: ${JSON.stringify(error)}`);

    return handlerInput.responseBuilder
        .speak(speakOutput)
        .reprompt(speakOutput)
        .getResponse();
  },
};


/**
 * This handler acts as the entry point for your skill, routing all request and response
 * payloads to the handlers above. Make sure any new handlers or interceptors you've
 * defined are included below. The order matters - they're processed top to bottom
 * */
exports.handler = Alexa.SkillBuilders.custom()
    .addRequestHandlers(

        LaunchRequestHandler,
        ProjectGeneralStateIntentHandler,
        BindAmazonUserToProjectHandler,
        HelpIntentHandler,
        CancelAndStopIntentHandler,
        FallbackIntentHandler,
        SessionEndedRequestHandler,
        mainBrainScreenHandler, // CUSTOM handler
        // IntentReflectorHandler
    )
    .addErrorHandlers(
        ErrorHandler)
    .withCustomUserAgent('sample/hello-world/v1.2')
    .lambda();


// FUNCIONES BACKEND


// Project Session ConnectionHandler, prepara los datos necesarios para guardarlos en las variables de sesion y usarlas en las interacciones con el
// Backend de la aplicacion.
// Devuelve un Diccionario con el estado de la peticion (atributo state que marca si todo ha ido bien, y linkedUser que marca si existe un usuario vinculado)
async function BrainScreenBindUserToProject(strAmazonUserId, strProjectName) {
  // Diccionario para el control del acceso al servidor
  const dictSetUpCompleted = {
    state: true,
    linkedUser: true,
    response: null,
    responseStatus: null,
  };

  if (strAmazonUserId === undefined || strProjectName === undefined || strProjectName === '' || strProjectName === 'null') {
    dictSetUpCompleted.state = false;// Error en los parametros
  } else {
    // Realizamos la logica de la conexion con la aplicacion
    try {
      await Axios.patch('http://3.210.108.248:3000/bindAmazonUserToProject',
          {
            'amazonUID': strAmazonUserId,
            'projectName': strProjectName,
          }).then((response) =>{
        dictSetUpCompleted.response = response.data;
        dictSetUpCompleted.responseStatus = response.status;
      });
    } catch (e) {
      console.log(e);
      dictSetUpCompleted.state = false;
      dictSetUpCompleted.linkedUser = false;
    }
    // En caso de no tener un usuario marcamos como incorrecta la seccion del usuario
  }

  return dictSetUpCompleted;
}


async function isLinked(sAmazonUID) {
  if (sAmazonUID === undefined) {
    return {linked: false, error: true};
  } else {
    try {
      // Pillamos los datos de nuestro backend.
      const response = await Axios.get(`http://3.210.108.248:3000/isLinked/${sAmazonUID}`);
      return {linked: response.data.linked, error: false};
    } catch (e) {
      console.log(e);
    }
  }
}


