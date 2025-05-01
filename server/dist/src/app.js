"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const morgan_1 = __importDefault(require("morgan"));
const router_1 = __importDefault(require("./routes/router"));
const http_1 = require("http");
const socket_io_1 = require("socket.io");
const socketHandlers_1 = require("./socketHandlers");
const port = 3000;
const app = (0, express_1.default)();
const httpServer = (0, http_1.createServer)(app);
const io = new socket_io_1.Server(httpServer, {
    cors: {
        origin: "*", // Adjust for production
        methods: ["GET", "POST"]
    }
});
app.use(express_1.default.json());
app.use(express_1.default.urlencoded());
app.use((0, morgan_1.default)("dev"));
app.use("/api", router_1.default);
app.get('/', (req, res) => {
    res.send('Hello World!');
});
(0, socketHandlers_1.setupSockets)(io);
app.listen(port, () => {
    return console.log(`Express is listening at http://localhost:${port}`);
});
//# sourceMappingURL=app.js.map