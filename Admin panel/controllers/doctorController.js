'use strict';

const firebase = require('../db');
const Student = require('../models/doctor');
const firestore = firebase.firestore();
const auth = firebase.auth();



const addDoctor = async (req, res, next) => {
    try {
        const data = req.body;
        const doctorName = req.body.name;
        const hospitalName = req.body.hospital;
        delete data['name'];
        delete data['hospital'];
        await firestore.collection('doctor').doc(hospitalName).collection('Name').doc(doctorName).set(data);
        res.send('Record Svae Successful');
    }
    catch (error) {
        res.status(400).send(error.message);
    }
}

const getAllDoctor = async(req, res, next) => {
    try {
        const students = await firestore.collection('doctor');
        const data = await students.get();
        const studentsArray = [];
        if (data.empty) {
            res.status(404).send('No status record found');
        }
        else{
            data.forEach(doc => {
                const student = new Student(
                    doc.id,
                    doc.data().firstName,
                    doc.data().lastName,
                    doc.data().fatherName,
                    doc.data().class,
                    doc.data().age,
                    doc.data().phoneNumber,
                    doc.data().subject,
                    doc.data().year,
                    doc.data().semester,
                    doc.data().status,
                );
                studentsArray.push(student);
            });
            res.send(studentsArray);
        }
    } catch(error){
        res.status(400).send(error.message);
    }
}

const getDoctor = async (req, res, next) => {
    try {
        const id = req.params.id;
        const student = await firestore.collection('student').doc(id);
        const data = await student.get();
        if(!data.exists) {
            res.status(404).send('Student with the given ID not found');
        } else{
            res.send(data.data());
        }
    } catch(error) {
        res.status(400).send(error.message);
    }
}

const updateDoctor = async (req, res, next) => {
    try {
        const id = req.params.id;
        const data = req.body;
        const student = await firestore.collection('doctor').doc(id);
        await student.update(data);
        res.send('Student record updated successfully');
    } catch (err) {
        res.status(400).send(err.message);
    }
}

const deleteDoctor = async(req, res, next) => {
    try {
        const id = req.params.id;
        await firestore.collection('doctor').doc(id).delete();
        res.send('Student deleted successfully');
    } catch (err) {
        res.status(400).send(err.message);
    }
}

const signup = async (req, res, next)=> {
    try{
        const email = req.body.email;
        const password = req.body.password;

        auth.createUserWithEmailAndPassword(email, password)
        .then((userCredential) => {
        var user = userCredential.user;
        res.redirect('/dashboard');
        })
        .catch((error) => {
        var errorCode = error.code;
        var errorMessage = error.message;
        res.redirect('/');
        });
    } catch (error) {
        res.status(400).send(error.message);
    }
}


const login = async (req, res, next)=> {
    try{
        const email = req.body.email;
        const password = req.body.password;

        firebase.auth().signInWithEmailAndPassword(email, password)
        .then((userCredential) => {
        // Signed in
        var user = userCredential.user;
        // res.send('User Login Success');
        res.redirect('/dashboard');
        })
        .catch((error) => {
        var errorCode = error.code;
        var errorMessage = error.message;
        res.redirect('/');
        });

    } catch (error) {
        res.status(400).send(error.message);
    }
}

const logout = async (req, res, next)=> {
    try{
        firebase.auth().signOut().then(() => {
            res.redirect('/');
          }).catch((error) => {
            res.status(400).send(error.message);
          });
    } catch (error) {
        res.status(400).send(error.message);
    }
}


module.exports = {
    addDoctor,
    getAllDoctor,
    getDoctor,
    updateDoctor,
    deleteDoctor,
    signup,
    login,
    logout
}