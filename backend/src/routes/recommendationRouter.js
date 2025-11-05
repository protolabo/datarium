import { Router } from 'express';
import { getRecommendations } from '../controllers/recommendationController.js';

const router = Router();

// tous les routes dans ce fichier sont préfixés par /recommendations
// GET /recommendations
router.get('/', getRecommendations);

export default router;
