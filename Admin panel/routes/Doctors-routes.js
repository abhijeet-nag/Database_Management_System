const express = require('express');
const {addDoctor, getAllDoctor, getDoctor, updateDoctor, deleteDoctor, signup, login, logout} = require('../controllers/doctorController');
const router = express.Router();

router.post('/doctor', addDoctor);
router.get('/doctors',getAllDoctor);
router.get('/doctor/:id', getDoctor);
router.put('/doctor/:id',updateDoctor);
router.delete('/doctor/:id',deleteDoctor);
router.post('/signup', signup);
router.post('/login', login);
router.get('/logout', logout);

module.exports = {
    routes: router
}