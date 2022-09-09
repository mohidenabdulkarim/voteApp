const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: String,
    phoneNumber: String,
    password: String,
    userType: String

});

const voterSchema = new mongoose.Schema({
    name: {
        type: String
    },
    phoneNumber: {
        type: String,
    },
    idNumber: {
        type: String,
    },
    area: {
        type: String,
    },
    addBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    }
});

const notificationMessageSchema = new mongoose.Schema({
    message: {
        type: String,
        required: true
    },
    created_at: {
        type: Date,
        default: Date.now
    }
})

const user = mongoose.model("User", userSchema);
const voter = mongoose.model("Voter", voterSchema);
const notificationMessage = mongoose.model("NotificationMessage", notificationMessageSchema);

module.exports = {
    Voter: voter,
    User: user,
    NotificationMessage: notificationMessage
}