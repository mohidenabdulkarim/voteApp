const express = require('express');
const router = express.Router();
const registerController = require('../controllers/register');


router.post("/", registerController.postRegister);

router.get("/all",registerController.getRegisteredAccounts);

router.post("/registeredByUser",registerController.getRegisteredAccountsByUser);




module.exports = router;