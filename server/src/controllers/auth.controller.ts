import bcryptjs from "bcryptjs";
import { sign, verify } from "jsonwebtoken";
import { UserPayload } from "../types/user.types";
import { eq } from "drizzle-orm";
import { Request, Response } from "express";
import { db } from "../db";
import { StringValue } from "ms";
import { users } from "../db/schema";

export class AuthController {
    static register = async (req: Request, res: Response) => {
        const body = req.body;
        try {
            const results = await db.insert(users).values({
                name: body.name,
                email: body.email,
                password: await bcryptjs.hash(body.password, 10),
                avatar: body.avatar
            });
            const createdUser = await db.query.users.findFirst({ where: eq(users.id, results[0].insertId) });
            if (!createdUser) {
                res.status(404).send({
                    "success": 0,
                    "message": "User not found! Please register your account to continue."
                });
                return;
            }
            const { password, ...user } = createdUser;
            res.json({
                "success": 1,
                "token": this.generateJwtToken(createdUser.id, createdUser.email!),
                "refresh_token": this.generateJwtToken(createdUser.id, createdUser.email!, "2d"),
                "data": user,
            });
        }
        catch (error) {
            res.status(400).send(error);
        }
    };

    static login = async (req: Request, res: Response) => {
        const body = req.body;
        try {
            const user = await db.select().from(users).where(eq(users.email, body.email));
            const foundUser = user[0];
            if (!foundUser) {
                res.status(404).send({
                    "success": 0,
                    "message": "User not found! Please register your account to continue."
                });
                return;
            }
            if (!(await bcryptjs.compare(req.body.password, foundUser.password!))) {
                res.status(400).send({
                    "success": 0,
                    "message": "Invalid credentials! Please check your credentials"
                });
                return;
            }
            const { password, ...data } = foundUser;
            res.json({
                "success": 1,
                "token": this.generateJwtToken(foundUser.id, foundUser.email!),
                "refresh_token": this.generateJwtToken(foundUser.id, foundUser.email!, "2D"),
                "data": data,
            });
        } catch (error) {
            res.status(500).send({
                success: 0,
                message: "An unexpected error occurred during login."
            });
        }
    };


    static refreshToken = async (req: Request, res: Response) => {
        const headers = req.headers["authorization"];
        if (!headers) {
            res.status(400).send({
                "success": "0",
                "message": "Refresh token is missing!"
            });
            return;
        }
        const refreshToken = headers && headers.split(" ")[1];
        verify(refreshToken!, "secretKey", async (error: any, decoded: { id: number; email: string; }) => {
            if (error) {
                res.status(402).send({
                    "success": "0",
                    "message": error!.message
                });
                return;
            }
            const payload = decoded as { id: number, email: string }
            const user = await db.query.users.findFirst({ where: eq(users.id, payload.id) });
            res.json({
                "success": 1,
                "token": this.generateJwtToken(user!.id, user!.email!, "1D"),
                "refresh_token": this.generateJwtToken(user!.id, user!.email!, "2D"),
            });
        });
    }

    private static generateJwtToken(id: number, email: string, expiresIn: StringValue = "1D") {
        const payload = {
            id: id,
            email: email,
        };
        const token = sign(payload, "secretKey", { expiresIn: expiresIn });
        return token;
    }
}
