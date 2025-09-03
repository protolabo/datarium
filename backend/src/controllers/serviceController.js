
import { ServiceRepo } from '../models/serviceRepo.js';

export const list = async (_req, res, next) => {
    try {
        res.json(await ServiceRepo.listAll());
    } catch (e) { next(e); }
};

export const get = async (req, res, next) => {
    try {
        const s = await ServiceRepo.getById(req.params.id);
        s ? res.json(s) : res.sendStatus(404);
    } catch (e) { next(e); }
};

export const create = async (req, res, next) => {
    try {
        const { id, name, category, description } = req.body;
        if (!id || !name) return res.status(400).json({ error: 'id & name required' });

        const doc = await ServiceRepo.create({ id, name, category, description });

        res.status(201).json(doc);
    } catch (e) { next(e); }
};

export const update = async (req, res, next) => {
    try {
        await ServiceRepo.update(req.params.id, req.body);
        res.sendStatus(204);
    } catch (e) { next(e); }
};

export const remove = async (req, res, next) => {
    try {
        await ServiceRepo.remove(req.params.id);
        res.sendStatus(204);
    } catch (e) { next(e); }
};
