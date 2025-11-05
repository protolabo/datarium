import { supabase } from '../config/supabase.js';

export class ServiceRepo {
    static async create({ id, name, category, description }) {
        const { data, error } = await supabase
            .from('services')
            .insert({ id, name, category, description })
            .select();
        if (error) throw error;
        return data[0];
    }

    static async listAll() {
        const { data, error } = await supabase
            .from('services')
            .select('*');
        if (error) throw error;
        return data || [];
    }

    static async getById(id) {
        const { data, error } = await supabase
            .from('services')
            .select('*')
            .eq('id', id)
            .single();
        if (error && error.code !== 'PGRST116') throw error;
        return data;
    }

    static async update(id, updateData) {
        const { data, error } = await supabase
            .from('services')
            .update(updateData)
            .eq('id', id)
            .select();
        if (error) throw error;
        return data[0];
    }

    static async remove(id) {
        const { error } = await supabase
            .from('services')
            .delete()
            .eq('id', id);
        if (error) throw error;
        return { success: true };
    }

    static async ajoutService({ id, name, category, description = '' }) {
        
        const existingService = await this.getById(id);

        if (!existingService) {
            return this.create({ id, name, category, description });
        }
        // si le service existe déjà, on met à jour la catégorie si elle est fournie et absente
        else if (category && !existingService.category) {
            return this.update(id, { category });
        }
        // Sinon, ne rien faire
        return existingService;
    }
}
