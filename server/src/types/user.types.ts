import { users } from "../db/schema"
import { Socket as SocketIoSocket } from "socket.io";
import { Request } from "express";

type UserType = typeof users.$inferSelect;
export type UserPayload = Omit<UserType, "fullName" | "password">

export interface UserRequestInterface extends Request {
    user?: UserPayload;
}

export interface Socket extends SocketIoSocket {
  user?: UserPayload;
}
