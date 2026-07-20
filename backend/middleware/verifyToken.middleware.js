const jwt = require('jsonwebtoken');

exports.verifyToken = (req, res, next) => {
    try {
        const token = req.headers['authorization'];
        console.log(token); 
        if (!token) return res.status(401).json({ status: 401, message: "Acceso Denegado: No se recibio ningun Token" });

        const tokenClean = token.split(' ')[0];
        const decoded = jwt.verify(tokenClean, process.env.TOKEN_SECRET);

        req.user = decoded;
        next();
    }
    catch (err) {
        res.status(401).json({ status: 401, message: `Token invalido ${err}` });
    }
}