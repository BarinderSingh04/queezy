import { string } from "zod";
import { users } from "../db/schema";
import { z } from "zod";

export const LoginValidation = z.object({
    body: z.object({
        email: string({
            required_error: "Email is required",
        }).email("Invalid email or password"),
        password: string({
            required_error: "Password is required",
        }).min(8, "Invalid password"),
    })
});

export const RegisterValidation = z.object({
    body: z.object({
        name: string({
            required_error: "Name is required",
        }),
        email: string({
            required_error: "Email is required",
        }).email("Invalid email address"),
        avatar: string({
            required_error: "Avatar is required",
        }),
        password: string({
            required_error: "Password is required",
        }).min(8, "Password must be at least 8 characters"),
        confirmPassword: string({
            required_error: "Confirm Password is required",
        }).min(8, "Password must be at least 8 characters"),
    }).refine((data) => data.password === data.confirmPassword, "Passwords do not match")
});

export const CreateGameValidation = z.object({
    body: z.object({
        roomCode: z.string({
            required_error: "Room code is required"
        }).min(4, "Room code must be at least 4 characters"),
        difficulty: z.enum(["easy", "medium", "hard"], {
            invalid_type_error: "Difficulty must be either 'easy', 'medium', or 'hard'"
        }).default("easy"),
        type: z.enum(["multiple", "boolean"], { invalid_type_error: "Type must be either 'multiple' or 'boolean" })
            .default("multiple"),
        categoryId: z.number({ required_error: "Category id is required" }),
    }),
});

export const GetScoresValidation = z.object({
    params: z.object({
        sessionId: z.string({ required_error: "Session id is required" }),
    }),
});