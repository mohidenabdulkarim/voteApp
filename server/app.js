const express = require("express");
const cors = require("cors");
const db = require("./database/database");
const app = express();
require("dotenv").config();
const Voter = require("./models/model").Voter;

app.use(cors());
app.use(express.json());

db.on("error", console.error.bind(console, "connection error:"));
db.once("open", function () {
  console.log("CONNECTED TO DB");
});

const registerRouter = require("./routes/register");
app.use("/register", registerRouter);

const loginRouter = require("./routes/admin");
app.use("/admin", loginRouter);

app.use("/", (req, res) => {
  Voter.countDocuments()
    .then((registeredPeople) => {
      res.json({
        registeredPeople,
      });
    })
    .catch((err) => console.log(err));
});

app.use((req, res) => {
  res.json({
    message: "404 NOT FOUND THIS PAGE ROUTE!",
  });
});

app.listen(process.env.PORT || 2828, () => {
  console.log("Server running");
});
