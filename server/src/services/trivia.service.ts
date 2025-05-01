import axios from 'axios';
import { CreateGameType } from '../types/game.types';

interface TriviaQuestion {
    category: string;
    type: string;
    difficulty: string;
    question: string;
    correct_answer: string;
    incorrect_answers: string[];
}

interface TriviaApiResponse {
    response_code: number;
    results: TriviaQuestion[];
}

type TriviaParams = {
    type?: "boolean" | "multiple";
    roomCode?: string;
    difficulty?: "easy" | "medium" | "hard";
    categoryId?: number;
}

class TriviaService {
    private readonly baseUrl = 'https://opentdb.com/api.php';

    async getQuestions(query: TriviaParams): Promise<TriviaQuestion[]> {
        try {
            const params = {
                amount: 10,
                category: query.categoryId,
                difficulty: query.difficulty || 'easy',
                type: query.type || 'multiple',
                encode: 'url3986',
            };

            const response = await axios.get<TriviaApiResponse>(this.baseUrl, { params });

            if (response.data.response_code !== 0) {
                throw new Error('Failed to fetch questions from Trivia API');
            }

            return response.data.results.map(q => ({
                ...q,
                question: decodeURIComponent(q.question),
                correct_answer: decodeURIComponent(q.correct_answer),
                incorrect_answers: q.incorrect_answers.map(a => decodeURIComponent(a)),
            }));
        } catch (error) {
            console.error('Error fetching trivia questions:', error);
            throw error;
        }
    }

    formatQuestions(triviaQuestions: TriviaQuestion[]) {
        return triviaQuestions.map(q => ({
            questionText: q.question,
            correctAnswer: q.correct_answer,
            options: [...q.incorrect_answers, q.correct_answer].sort(() => Math.random() - 0.5), // Shuffle options
            difficulty: this.mapDifficulty(q.difficulty),
        }));
    }

    private mapDifficulty(difficulty: string): number {
        switch (difficulty.toLowerCase()) {
            case 'easy': return 1;
            case 'medium': return 3;
            case 'hard': return 5;
            default: return 2;
        }
    }
}

export default new TriviaService();