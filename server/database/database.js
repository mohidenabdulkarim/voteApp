const mongoose = require("mongoose");
mongoose.connect("mongodb+srv://musharax:musharax123@cluster0.ftydb.mongodb.net/musharax?retryWrites=true&w=majority", { useNewUrlParser: true });
const db = mongoose.connection;

module.exports = db;

// mongoose.connect("mongodb://localhost:27017/musharax", { useNewUrlParser: true });