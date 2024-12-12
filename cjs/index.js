const express = require("express");
const { createServer } = require("node:http");
const { join } = require("node:path");
const passport = require("passport");
const passportJwt = require("passport-jwt");
const JwtStrategy = passportJwt.Strategy;
const ExtractJwt = passportJwt.ExtractJwt;
const bodyParser = require("body-parser");
const { Server } = require("socket.io");
const jwt = require("jsonwebtoken");

const port = process.env.PORT || 3030;
const jwtSecret = "Mys3cr3t";

const app = express();
const httpServer = createServer(app);

app.use(bodyParser.json());

app.get("/", (req, res) => {
  res.sendFile(join(__dirname, "index.html"));
});

app.get(
  "/self",
  passport.authenticate("jwt", { session: false }),
  (req, res) => {
    if (req.user) {
      res.send(req.user);
    } else {
      res.status(401).end();
    }
  },
);

app.post("/login", (req, res) => {

    const randomInt = Math.floor(Math.random() * 1000000);
    const uid = req.body.username + randomInt;

    user = {
      id: uid,
      username: req.body.username,
    };

    const token = jwt.sign(
      {
        data: user,
      },
      jwtSecret,
      {
        issuer: "accounts.examplechatapp.com",
        audience: "examplechat.net",
        expiresIn: "1h",
      },
    );

    res.json({ "token":token, "uid":uid });

});

const jwtDecodeOptions = {
  jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
  secretOrKey: jwtSecret,
  issuer: "accounts.examplechatapp.com",
  audience: "examplechat.net",
};

passport.use(
  new JwtStrategy(jwtDecodeOptions, (payload, done) => {
    return done(null, payload.data);
  }),
);

const io = new Server(httpServer, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
    allowedHeaders: ["Authorization"],
  },
});

io.engine.use((req, res, next) => {
  const isHandshake = req._query.sid === undefined;
  if (isHandshake) {
    passport.authenticate("jwt", { session: false }, (err, user, info) => {
        if (err) {
        console.log("Auth error:", err);
          return next(err);
        }
        if (!user) {
        console.log("Auth user error:", info);
          return next();
        }
        console.log("Auth user:", user);
        req.user = user;
        next();
      })(req, res, next);
  } else {
    next();
  }
});


io.on("connection", (socket) => {
    const id = socket.id;
    console.log("User connecting, id:", id);
    const req = socket.request;
    console.log("User connected:", req.user);
    const helloNotification = { message:`${req.user.username} connected`, date: Date.now() , uid: req.user.id};
    console.log("Hello notification:", helloNotification);
    io.emit("notification", helloNotification);


    socket.on("message", (data) => {
    const message = {message: data.message, date: data.date, user: {uid: req.user.id, userName: req.user.username}}
        io.emit("message", message);
    });

    socket.on("disconnect", () => {
        console.log(`User disconnected: ${req.user.id}`);
    });
    socket.on("whoami", (cb) => {
        cb(req.user.username);
    });
});

httpServer.listen(port, () => {
  console.log(`application is running at: http://localhost:${port}`);
});
