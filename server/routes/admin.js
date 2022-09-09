const router = require('express').Router();
const adminController = require('../controllers/admin');


router.post("/", adminController.postLogin);


router.post("/sign-up", adminController.signUp);

router.post("/add-notify", adminController.addNotify);

router.get("/get-notify", adminController.getNotifiy);

module.exports = router;
