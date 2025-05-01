import { AnyZodObject, ZodError } from "zod";
import { NextFunction, Request, Response } from "express";

export const validateResources = (schema: AnyZodObject) =>
    (req: Request, res: Response, next: NextFunction) => {
        try {
            schema.parse({
                body: req.body,
                query: req.query,
                params: req.params,
            });
            next();
        } catch (error) {
            if (error instanceof ZodError) {
                res.status(400).json({
                    success: "0",
                    message: "Validation error",
                    errors: error.flatten().fieldErrors,
                });
                return;
            }
            res.status(400).json({
                success: "0",
                message: error instanceof Error ? error.message : "Unknown error",
            });
        }
    };
