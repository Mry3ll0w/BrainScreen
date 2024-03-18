/**
 * Backend para la integreacion de Alexa con la plataforma BrainScreen
 */
 
 //Required Libs
const Alexa = require('ask-sdk-core');
const Axios = require('axios');
//Functions

const LaunchRequestHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'LaunchRequest';
    },
    async handle(handlerInput) {
        const userID = handlerInput.requestEnvelope.context.System.user.userId;
        
        const speakOutput = `Bienvenido al panel de control de BrainScreen, en que puedo ayudarte?`;
        const data = await BrainScreenSetUp(userID, 'ara');
        
        
        return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt(speakOutput)
            .getResponse();
    }
};

const HelloWorldIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && Alexa.getIntentName(handlerInput.requestEnvelope) === 'HelloWorldIntent';
    },
    handle(handlerInput) {
        const speakOutput = 'Hello World!';

        return handlerInput.responseBuilder
            .speak(speakOutput)
            //.reprompt('add a reprompt if you want to keep the session open for the user to respond')
            .getResponse();
    }
};

const HelpIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.HelpIntent';
    },
    handle(handlerInput) {
        const speakOutput = 'You can say hello to me! How can I help?';

        return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt(speakOutput)
            .getResponse();
    }
};

const CancelAndStopIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && (Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.CancelIntent'
                || Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.StopIntent');
    },
    handle(handlerInput) {
        const speakOutput = 'Hasta luego !!';

        return handlerInput.responseBuilder
            .speak(speakOutput)
            .getResponse();
    }
};
/* *
 * FallbackIntent triggers when a customer says something that doesn’t map to any intents in your skill
 * It must also be defined in the language model (if the locale supports it)
 * This handler can be safely added but will be ingnored in locales that do not support it yet 
 * */
const FallbackIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.FallbackIntent';
    },
    handle(handlerInput) {
        const speakOutput = 'Sorry, I don\'t know about that. Please try again.';

        return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt(speakOutput)
            .getResponse();
    }
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
    }
};

const mainBrainScreenHandler = {
    canHandle(handlerInput) {
       return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
        &&
        Alexa.getIntentName(handlerInput.requestEnvelope) === 'BrainScreenMainIntent';
    },
    handle(handlerInput) {
        const speakOutput = 'Alabado sea el dios maquina';

        return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt(speakOutput)
            .getResponse();
    }
}

//Project Session ConnectionHandler, prepara los datos necesarios para guardarlos en las variables de sesion y usarlas en las interacciones con el 
//Backend de la aplicacion.
//Devuelve un Diccionario con el estado de la peticion (atributo state que marca si todo ha ido bien, y linkedUser que marca si existe un usuario vinculado)
async function BrainScreenSetUp(strAmazonUserId,strProjectName){
    //Diccionario para el control del acceso al servidor
    var dictSetUpCompleted = {
        state: true,
        linkedUser:true
    }
    
    if(strAmazonUserId === null || strProjectName === null || strProjectName === '' || strProjectName === 'null'){
        dictSetUpCompleted.state = false;//Error en los parametros
    }
    else{
        //Realizamos la logica de la conexion con la aplicacion
        try{
            const data = await Axios.get('https://dummy.restapiexample.com/api/v1/employees')
            console.log(data);
            if(data !== null){
                dictSetUpCompleted.state = true;
            }
        }catch(e){
            console.log(e);
            dictSetUpCompleted.state = false;
            dictSetUpCompleted.linkedUser = false;
        }
        //En caso de no tener un usuario marcamos como incorrecta la seccion del usuario
    }
    
    return dictSetUpCompleted;
}

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
        const speakOutput = 'Sorry, I had trouble doing what you asked. Please try again.';
        console.log(`~~~~ Error handled: ${JSON.stringify(error)}`);

        return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt(speakOutput)
            .getResponse();
    }
};





/**
 * This handler acts as the entry point for your skill, routing all request and response
 * payloads to the handlers above. Make sure any new handlers or interceptors you've
 * defined are included below. The order matters - they're processed top to bottom 
 * */
exports.handler = Alexa.SkillBuilders.custom()
    .addRequestHandlers(
        mainBrainScreenHandler,//CUSTOM handler
        LaunchRequestHandler,
        HelloWorldIntentHandler,
        HelpIntentHandler,
        CancelAndStopIntentHandler,
        FallbackIntentHandler,
        SessionEndedRequestHandler,
        //IntentReflectorHandler
        )
    .addErrorHandlers(
        ErrorHandler)
    .withCustomUserAgent('sample/hello-world/v1.2')
    .lambda();