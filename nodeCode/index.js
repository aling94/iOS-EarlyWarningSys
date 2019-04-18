var firebase = require('firebase-admin');
var request = require('request');

var API_KEY = "AAAAgtzvjM4:APA91bHp-v8JNS_z109V4DygzhfTqN7Td9EihehTQMQgyp0lTDtR3JvO61zuWVVWBl0f4O9GyKr3M3kaFGPZ_dwtMhAfsOZh-pzJxyt-pDQ03vl3owSb8OrcRNm84zWitxzQbLAQd51E";

var serviceAccount = require("./meta.json");

firebase.initializeApp({
	credential: firebase.credential.cert(serviceAccount),
	databaseURL: "https://ews-ios-b18.firebaseio.com/"
});
ref = firebase.database().ref();

function listenForNotificationRequests() {
  var requests = ref.child('notificationRequests');
  requests.on('child_added', function(requestSnapshot) {
    var request = requestSnapshot.val();
      sendNotificationToUser(
      request.receiverId, 
      request.message,
      request.senderId,
      function() {
        requestSnapshot.ref.remove();
      }
    );
  }, function(error) {
    console.error(error);
  });
};

function sendNotificationToUser(receiverId, message, senderId, onSuccess) {
  request({
    url: 'https://fcm.googleapis.com/fcm/send',
    method: 'POST',
    headers: {
      'Content-Type' :' application/json',
      'Authorization': 'key='+API_KEY
    },
    body: JSON.stringify({
      notification: {
        title: "New Message",
		text: message,
		sender: senderId
      },
      to : "/topics/"+receiverId
      //data: {rideInfo: rideinfo}
    })
  }, function(error, response, body) {
    if (error) { console.error(error); }
    else if (response.statusCode >= 400) { 
      console.error('HTTP Error: '+response.statusCode+' - '+response.statusMessage); 
    }
    else {
      onSuccess();
    }
  });
}

// start listening
listenForNotificationRequests();
