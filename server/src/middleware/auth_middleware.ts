import { NextFunction, Response } from "express";
import { verify } from "jsonwebtoken";
import { db } from "../db";
import { eq } from "drizzle-orm";
import { users } from "../db/schema";
import { UserRequestInterface } from "../types/user.types";

export async function authMiddleware(req: UserRequestInterface, res: Response, next: NextFunction) {
    const headers = req.headers["authorization"];
    if (headers == null) {
        res.status(403).send({
            "success": "0",
            "message": "Authorization token is missing!"
        });
        return;
    }
    const token = headers && headers.split(" ")[1];
    try {
        verify(token!, "secretKey", async (error: any, decoded: { id: number; email: string; }) => {
            if (error) {
                res.status(403).send({
                    "success": "0",
                    "message": error!.message
                });
                return;
            }
            const payload = decoded as { id: number, email: string }
            const user = await db.select().from(users).where(eq(users.id, payload.id));
            if (user.length === 0) {
                res.status(403).send({
                    success: "0",
                    message: "User not found!",
                });
                return;
            }
            const { password, ...userPayload } = user[0];
            req.user = userPayload;
            next();
        });
    }
    catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        res.status(403).send({
            "success": "0",
            "message": `Error occurred: ${message}`
        });
    }
};