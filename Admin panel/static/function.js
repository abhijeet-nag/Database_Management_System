import {auth} from "db.js"

function signin(){
	var email = document.getElementById('email');
	var password = document.getElementById('password');
	window.alert('run');

	firebase.auth().createUserWithEmailAndPassword(email, password)
  .then((userCredential) => {
    // Signed in 
    var user = userCredential.user;
	window.alert('Login Successful');
    // ...
  })
  .catch((error) => {
    var errorCode = error.code;
    var errorMessage = error.message;
	window.alert(errorMessage);
    // ..
  });

}
