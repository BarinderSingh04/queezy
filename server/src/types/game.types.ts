
import { z } from "zod";
import { CreateGameValidation, GetScoresValidation } from "../common/validation";

export type CreateGameType = z.infer<typeof CreateGameValidation>['body'];
export type GetScoresType = z.infer<typeof GetScoresValidation>['params'];