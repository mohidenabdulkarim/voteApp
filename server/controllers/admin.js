const User = require('../models/model').User;
const NotificationMessage = require('../models/model').NotificationMessage;
const bcrypt = require("bcrypt");
exports.postLogin = (req, res) => {
  const { username, password } = req.body;

  let hashPassword;

  User.findOne({ name: username }, (err, user) => {
    if (!user) {
      res.send("NOT_FOUND");
    }
    hashPassword = user.password;
    bcrypt.compare(password, hashPassword).then((isMatch) => {
      if (!isMatch) {
        console.log("Password not match!!");
      }
      res.send(user);
    });
  });
};

exports.signUp = (req, res) => {
  const { name, password, phoneNumber, userType, matchPassword } = req.body;

  bcrypt.genSalt(5, function (err, salt) {
    bcrypt.hash(password, salt, function (err, hash) {
      const data = {
        name,
        phoneNumber,
        userType,
        password: hash,
      };

      const user = new User(data);

      user.save().then((result) => {
        console.log(result);
        return res.send({ msg: "SUCCESS" })
      }).catch(err => console.log(err))

    });
  });
};

exports.addNotify = (req, res) => {

  const { msg } = req.body;

  const notifyMsg = new NotificationMessage({
    message: msg
  });

  notifyMsg.save().then((result) => {
    console.log(result);
    return res.json({ msg: "Success" })
  }).catch(err => console.log(err))

}

exports.getNotifiy = (req, res) => {
  NotificationMessage.find({}).then(result => {
    console.log(result)
    const all = result.reverse();
    res.json({
      all,
    });
  }).catch(err => console.log(err))
}