"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const axios_1 = __importDefault(require("axios"));
class TriviaService {
    constructor() {
        this.baseUrl = 'https://opentdb.com/api.php';
    }
    getQuestions(categoryId_1) {
        return __awaiter(this, arguments, void 0, function* (categoryId, type = 'multiple', amount = 10) {
            try {
                const params = {
                    amount,
                    category: categoryId,
                    type: type,
                    encode: 'url3986',
                };
                const response = yield axios_1.default.get(this.baseUrl, { params });
                if (response.data.response_code !== 0) {
                    throw new Error('Failed to fetch questions from Trivia API');
                }
                return response.data.results.map(q => (Object.assign(Object.assign({}, q), { question: decodeURIComponent(q.question), correct_answer: decodeURIComponent(q.correct_answer), incorrect_answers: q.incorrect_answers.map(a => decodeURIComponent(a)) })));
            }
            catch (error) {
                console.error('Error fetching trivia questions:', error);
                throw error;
            }
        });
    }
    formatQuestions(triviaQuestions) {
        return triviaQuestions.map(q => ({
            questionText: q.question,
            correctAnswer: q.correct_answer,
            options: [...q.incorrect_answers, q.correct_answer].sort(() => Math.random() - 0.5), // Shuffle options
            difficulty: this.mapDifficulty(q.difficulty),
        }));
    }
    mapDifficulty(difficulty) {
        switch (difficulty.toLowerCase()) {
            case 'easy': return 1;
            case 'medium': return 3;
            case 'hard': return 5;
            default: return 2;
        }
    }
}
exports.default = new TriviaService();
//# sourceMappingURL=trivia.service.js.map