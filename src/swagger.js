// src/swagger.js
const swaggerJSDoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Jobify API',
      version: '1.0.0',
      description: 'API documentation for your Jobify project',
    },
    servers: [
      {
        url: 'https://jobtify-production.up.railway.app/', // or your Railway/Supabase URL
      },
    ],
  },
  apis: ['./src/index.js'], // Path to your API route definitions
};

const swaggerSpec = swaggerJSDoc(options);
module.exports = swaggerSpec;
