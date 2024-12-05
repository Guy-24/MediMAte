const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const app = express();

const database = "Alarm";
// const collection = 'NEW_COLLECTION_NAME';

// The current database to use.
// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());

// MongoDB Connection
mongoose.connect(
  "mongodb+srv://admin:1234@cluster0.lxkwl.mongodb.net/AlarmDB?retryWrites=true&w=majority&appName=Cluster0",
  {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  }
);

const db = mongoose.connection;

db.on("error", console.error.bind(console, "Connection error:"));
db.once("open", () => {
  console.log("Connected to MongoDB");
});

// Alarm Schema
const AlarmSchema = new mongoose.Schema({
  slot: { type: Number, required: true },
  hour: { type: Number, required: true },
  min: { type: Number, required: true },
  name: { type: String, required: true },
  dosagePT: { type: Number, required: false },
  dosageL: { type: Number, required: false },
  info: { type: String, required: false },
});

const Alarm = mongoose.model("Alarm", AlarmSchema);

// Server Port
const PORT = process.env.PORT || 2000;

// Start Server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

///// API ENDPOINTS /////

// POST: Add a new alarm
app.post("/api/add_alarm", async (req, res) => {
  try {
    const alarm = new Alarm(req.body); // Create a new alarm document
    const savedAlarm = await alarm.save(); // Save to MongoDB
    res.status(201).send({
      status_code: 201,
      message: "Alarm added successfully",
      data: savedAlarm,
    });
  } catch (error) {
    res.status(500).send({
      status_code: 500,
      message: "Error adding alarm",
      data: error.message,
    });
  }
});

// GET: Fetch all alarms
app.get("/api/get_all_alarms", async (req, res) => {
  try {
    const alarms = await Alarm.find(); // Fetch all documents from the Alarm collection
    res.status(200).send({
      status_code: 200,
      message: "Alarms retrieved successfully",
      data: alarms,
    });
  } catch (error) {
    res.status(500).send({
      status_code: 500,
      message: "Error fetching alarms",
      data: error.message,
    });
  }
});

// GET: Fetch a specific alarm by ID
app.get("/api/get_alarm/:id", async (req, res) => {
  try {
    const alarm = await Alarm.findById(req.params.id); // Fetch a specific alarm by its ID
    if (!alarm) {
      return res.status(404).send({
        status_code: 404,
        message: "Alarm not found",
      });
    }
    res.status(200).send({
      status_code: 200,
      message: "Alarm retrieved successfully",
      data: alarm,
    });
  } catch (error) {
    res.status(500).send({
      status_code: 500,
      message: "Error fetching alarm",
      data: error.message,
    });
  }
});

// // PUT: Update an alarm by ID
// app.put("/api/update_alarm/:id", async (req, res) => {
//   try {
//     const updatedAlarm = await Alarm.findByIdAndUpdate(
//       req.params.id,
//       req.body,
//       {
//         new: true, // Return the updated document
//         runValidators: true, // Run schema validation on updates
//       }
//     );
//     if (!updatedAlarm) {
//       return res.status(404).send({
//         status_code: 404,
//         message: "Alarm not found",
//       });
//     }
//     res.status(200).send({
//       status_code: 200,
//       message: "Alarm updated successfully",
//       data: updatedAlarm,
//     });
//   } catch (error) {
//     res.status(500).send({
//       status_code: 500,
//       message: "Error updating alarm",
//       data: error.message,
//     });
//   }

// PUT: Update an alarm by slot
app.put("/api/update_alarm/:slot", async (req, res) => {
  try {
    // console.log("Slot parameter:", req.params.slot);
    // console.log("Request parameter:", req.body);

    const updatedAlarm = await Alarm.findOneAndUpdate(
      { slot: req.params.slot },
    //   console.log("Slot finding", req.params.slot),
      req.body,
      {
        new: true, // Return the updated document
        runValidators: true, // Run schema validation on updates
      }
    );
    if (!updatedAlarm) {
      return res.status(404).send({
        status_code: 404,
        message: "Alarm not found",
      });
    }
    res.status(200).send({
      status_code: 200,
      message: "Alarm updated successfully",
      data: updatedAlarm,
    });
  } catch (error) {
    console.log(error);
    res.status(500).send({
      status_code: 500,
      message: "Error updating alarm",
      data: error.message,
    });
  }
});
