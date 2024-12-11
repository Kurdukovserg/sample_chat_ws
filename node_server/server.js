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
const { random } = require("random");

const port = process.env.PORT || 3000;
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

    const uid = 1231;

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

    res.json({ token });

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

const io = new Server(httpServer);

httpServer.listen(port, () => {
  console.log(`application is running at: http://localhost:${port}`);
});