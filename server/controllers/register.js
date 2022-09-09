const db = require("../database/database");
const Voter = require("../models/model").Voter;
exports.postRegister = (req, res) => {
  const { name, pNumber, id, area, addBy } = req.body;
  console.log(req.body);
  console.log(addBy);

  const data = {
    name: name.trim(),
    pNumber: pNumber.trim(),
    cardId: id.trim(),
    area: area.trim(),
    addBy: addBy
  };
  const voter = new Voter(data);

  voter.save().then((result => {
    console.log(result);
  })).catch(err => console.log(err))
  // db.collection("registered")
  //   .insertOne(data)
  //   .then((res) => {
  //     console.log("Inserted");
  //   })
  //   .catch((er) => console.log(err));
};

// INFINTE LOOP - YAAP.com 😏
exports.getRegisteredAccounts = (req, res) => {
  Voter
    .find({})
    .then((all) => {
      res.json({
        all,
      });
    })
    .catch((err) => console.log(err));
};


exports.getRegisteredAccountsByUser = (req, res) => {
  const { adminId } = req.body;
  Voter.find({ addBy: adminId }).countDocuments().then((result) => {
    res.json({
      result
    })
  }).catch(err => console.log(err))


}