import { supabase } from '../config/supabase.js';

export class NetworkLogRepo {
    /** Inserts a detailed log entry into the networkLogs table */
    static async insertLot({ networkId, serviceName, hostId,
        bytes, kwh, co2, listenSec, category }) {
        
        const { error } = await supabase
            .from('networkLog')
            .insert({
                networkId,
                timestamp: new Date().toISOString(),
                serviceName,
                hostId,
                bytes, kwh, co2,
                listenSec,
                category
            });

        if (error) {
            console.error('Error inserting network log:', error);
            throw error;
        }
    }

    /** Searches for logs, filterable by SSID, service, period */
    static async search({ networkId, serviceName, fromTs, toTs, limit = 100 }) {
        let query = supabase
            .from('networkLog')
            .select('*')
            .order('timestamp', { ascending: false })
            .limit(limit);

        if (networkId) {
            query = query.eq('networkId', networkId);
        }
        if (serviceName) {
            query = query.eq('serviceName', serviceName);
        }
        if (fromTs) {
            query = query.gte('timestamp', new Date(fromTs).toISOString());
        }
        if (toTs) {
            query = query.lte('timestamp', new Date(toTs).toISOString());
        }

        const { data, error } = await query;

        if (error) {
            console.error('Error searching network logs:', error);
            throw error;
        }

        return data || [];
    }

    /**
     * Returns the N latest logs across all categories/networks.
     * @param {number} limit - number of documents (default: 1)
     * @returns {Array<Object>} array of logs sorted from newest to oldest
     */
    static async fetchLatest(limit = 1) {
        const { data, error } = await supabase
            .from('networkLog')
            .select('*')
            .order('timestamp', { ascending: false })
            .limit(limit);

        if (error) {
            console.error('Error fetching latest logs:', error);
            throw error;
        }

        return data || [];
    }
}
