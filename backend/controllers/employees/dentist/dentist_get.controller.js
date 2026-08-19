
const pool = require('../../../config/connection_database');


exports.getDentists = async (req, res) => {
    const page = parseInt(req.query.page) || 1;
    //const offset = req.query.offset; 
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;


    const queryDentist = `
            SELECT 
        `




}