import { Router } from 'express';
import { AuthController } from '../controllers/auth.controller';
import { validateResources } from '../middleware/validate_resources';
import { CreateGameValidation, GetScoresValidation, LoginValidation, RegisterValidation } from '../common/validation';
import gameController from '../controllers/game.controller';
import userController from '../controllers/user.controller';
import { authMiddleware } from '../middleware/auth_middleware';

const router = Router();

router.post("/login", validateResources(LoginValidation), AuthController.login);
router.post("/register", validateResources(RegisterValidation), AuthController.register);
router.post("/refresh", AuthController.refreshToken);
router.post("/create_game", validateResources(CreateGameValidation), gameController.createGame);
router.get("/game_scores/:sessionId", validateResources(GetScoresValidation), gameController.gameScores);
router.get("/leaderboard", gameController.leaderboard);
router.get("/game_played", authMiddleware, gameController.playedGames);
router.get("/avatars", userController.getAvatarList);

export default router;