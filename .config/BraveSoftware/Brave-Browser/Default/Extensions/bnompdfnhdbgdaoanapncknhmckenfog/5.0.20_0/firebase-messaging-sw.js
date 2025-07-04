importScripts('https://www.gstatic.com/firebasejs/7.15.4/firebase-app.js')
importScripts('https://www.gstatic.com/firebasejs/7.15.4/firebase-messaging.js')

firebase.initializeApp({
	apiKey: "AIzaSyARIhIr9hh6My_mHf4lCJQLzSy1doOEjY4",
	authDomain: "email-tracker-7d86e.firebaseapp.com",
	databaseURL: "https://email-tracker-7d86e.firebaseio.com",
	projectId: "email-tracker-7d86e",
	storageBucket: "email-tracker-7d86e.appspot.com",
	messagingSenderId: "171732813728",
	appId: "1:171732813728:web:fc10a488c3ec231e57c6c5"
})

const messaging = firebase.messaging()