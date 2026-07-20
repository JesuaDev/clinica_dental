exports.verifyFields = (fields = []) => {
    return (req, res, next) => {
        let missingFields = [];

        for (const field of fields) {
            if(req.body[field] === undefined || req.body[field] === null || req.body[field] === ''){
                missingFields.push(field);
                console.log(field + missingFields);  
            }
        }

        if(missingFields.length > 0) return res.status(400).json({ status: 400, message: "Datos Incompletos" , incomplete: missingFields});

        next(); 
    }
}