import express from 'express';
import morgan from "morgan";
import router from './routes/router';
import { createServer } from 'http';
import { Server } from 'socket.io';
import { setupSockets } from './socketHandlers';
import dotenv from 'dotenv';
import path from 'path';

const port = 3001;

dotenv.config();

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer);
app.use(express.json()); 
app.use(express.urlencoded());
app.use(morgan("dev"));

app.use("/api", router);
app.use('/public', express.static(path.join(__dirname, '..', 'public')));

setupSockets(io);

httpServer.listen(port, () => {
  return console.log(`Express is listening at http://localhost:${port}`);
});