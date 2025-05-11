const express = require("express");
const dotenv = require("dotenv");
const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();
const app = express();

const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./swagger'); // Adjust path if needed

// Body parser middleware (add this!)
app.use(express.json()); // <-- Handles JSON requests
app.use(express.urlencoded({ extended: true })); // <-- Handles form submissions

// cara menjalankan server yaitu ketik = "node ." / "nodemon ."
// untuk membuka prisma studio ketik = "npx prisma studio"

dotenv.config();

const PORT = process.env.PORT;

const path = require("path");
//above code, What it does: Imports Node.js's built-in path module.
//Why it matters: It helps us build file paths that work on all systems (Windows, Linux, Mac).


// Serve static files (e.g., product.html)
// Menampilkan file yang ingin diambil, contohnya /products.html
app.use(express.static(path.join(__dirname)));

app.get("", async (req, res) => {
    res.send("API PROJECT X");
});

// Swagger endpoint
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
  
/**
 * @swagger
 * /jobs:
 *   get:
 *     summary: menampilkan jobs.html
 *     description: Menampilkan halaman jobs.html
 *     responses:
 *       200:
 *         description: Success
 */
app.get("/jobs", async (req, res) => {
  res.sendFile(path.join(__dirname, "jobs.html")); //untuk membuka jobs.html hanya dengan /jobs
  /*
    const jobs = await prisma.nation_job.findMany();
    res.send(jobs);
  */
});


   // example to fetch all jobs without filter
   // buat pagination
   /**
 * @swagger
 * /jobs/show:
 *   get:
 *     summary: Menampilkan daftar pekerjaan
 *     description: Menampilkan daftar semua perkerjaan, optional engan filter berdasarkan nama pekerjaan atau nama perusahaan
 *     parameters:
 *       - in: query
 *         name: q
 *         schema:
 *           type: string
 *         description: Filter jobs by name or company (case-insensitive) (OPTIONAL)
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *         description: Page number for pagination (default is 1)
 *       - in: query
 *         name: pageSize
 *         schema:
 *           type: integer
 *         description: Number of jobs per page (default is 10) 
 *     responses:
 *       200:
 *         description: Success
 */
   app.get("/jobs/show", async (req, res) => {
    try {
      const { q, page = 1, pageSize = 10 } = req.query; // Default to page 1 and pageSize 10

      const filter = q
        ? {
            OR: [
              { job_name: { contains: q, mode: "insensitive" } },
              { company: { company_name: { contains: q, mode: "insensitive" } } },
            ],
          }
        : {};

      const jobs = await prisma.job.findMany({
        where: filter,
        include: {
          company: {
            select: {
              company_name: true,
            },
          },
          city: {
            select: {
              city_name: true,
            },
          },
          state: {
            select: {
              state_name: true,
            },
          },
          country: {
            select: {
              country_name: true,
            },
          },
        },
        skip: (page - 1) * pageSize, // Calculate the offset
        take: parseInt(pageSize), // Limit the number of records
      });

      // Get the total count of jobs for pagination metadata
      const totalJobs = await prisma.job.count({ where: filter });

      res.json({
        data: jobs,
        meta: {
          total: totalJobs,
          page: parseInt(page),
          pageSize: parseInt(pageSize),
          totalPages: Math.ceil(totalJobs / pageSize),
        },
      });
    } catch (error) {
      console.error("Error fetching jobs with pagination:", error);
      res.status(500).json({ error: "Failed to fetch jobs" });
    }
  });

//to fech only spesific job By id
/**
 * @swagger
 * /jobs/detail:
 *   get:
 *     summary: Menampilkan spesific pekerjaan
 *     description: Menampilkan detail pekerjaan berdasarkan ID
 *     parameters:
 *       - in: query
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID pekerjaan yang ingin ditampilkan
 *     responses:
 *       200:
 *         description: Success
 */
app.get("/jobs/detail", async (req, res) => {
  try {
    const { id } = req.query;

    if (!id) {
      return res.status(400).json({ error: "Job ID is required" });
    }

    const job = await prisma.job.findUnique({
      where: {
        job_id: parseInt(id), // Ensure the ID is parsed as an integer
      }
    });

    if (!job) {
      return res.status(404).json({ error: "Job not found" });
    }

    res.json(job);
  } catch (error) {
    console.error("Error fetching job details:", error);
    res.status(500).json({ error: "Failed to fetch job details" });
  }
});

/**
 * @swagger
 * /jobcategory:
 *   get:
 *     summary: Menampilkan kategori pekerjaan
 *     description: Menampilkan kategori pekerjaan, optional berdasarkan job_category_id
 *     parameters:
 *       - in: query
 *         name: id
 *         schema:
 *           type: integer
 *        
 *         description: job_category_id yang ingin ditampilkan (OPTIONAL)
 *     responses:
 *       200:
 *         description: Success
 */
app.get("/jobcategory", async (req, res) => {
  try {
    const { id } = req.query;
    const filter = id
        ? {
            OR: [
              { job_category_id: parseInt(id) }, // Ensure the ID is parsed as an integer
            ],
          }
        : {};
    

    const jobCategories = await prisma.job_category.findMany({ 
      where: filter
      });

    if (!jobCategories) {
      return res.status(404).json({ error: "Job Category not found" });
    }
    res.json(jobCategories);
  } catch (error) {
    console.error("Error fetching job category:", error);
  }
  
});

/**
 * @swagger
 * /company/show:
 *   get:
 *     summary: Menampilkan daftar perusahaan
 *     description: Menampilkan daftar semua perusahaan, optional engan filter berdasarkan nama perusahaan
 *     parameters:
 *       - in: query
 *         name: q
 *         schema:
 *           type: string
 *         description: Filter companies by name (case-insensitive) (OPTIONAL)
 *     responses:
 *       200:
 *         description: Success
 */
app.get("/company/show", async (req, res) => {
  try {
    const { q } = req.query;

    const where = q
      ? {
          OR: [
            { company_name: { contains: q, mode: "insensitive" } },
           // { company_location: { contains: q, mode: "insensitive" } },
           // { company_city: { contains: q, mode: "insensitive" } },
           // { company_country: { contains: q, mode: "insensitive" } },
          ],
        }
      : {};

    const companies = await prisma.company.findMany({
      where,
    });

    res.json(companies);
  } catch (error) {
    console.error("Error fetching filtered companies:", error);
    res.status(500).json({ error: "Failed to filter companies" });
  }
});

/**
 * @swagger
 * /company/detail:
 *   get:
 *     summary: Menampilkan spesific perusahaan
 *     description: Menampilkan detail perusahaan berdasarkan ID
 *     parameters:
 *       - in: query
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID perusahaan yang ingin ditampilkan
 *     responses:
 *       200:
 *         description: Success
 */
app.get("/company/detail", async (req, res) => {
  try {
    const { id } = req.query;

    if (!id) {
      return res.status(400).json({ error: "Company ID is required" });
    }

    const company = await prisma.company.findUnique({
      where: {
        company_id: parseInt(id), // Ensure the ID is parsed as an integer
      }
    });

    if (!company) {
      return res.status(404).json({ error: "Company not found" });
    }

    res.json(company);
  } catch (error) {
    console.error("Error fetching company details:", error);
    res.status(500).json({ error: "Failed to fetch company details" });
  }
});

// cara menjalankan server yaitu ketik = "node ." / "nodemon ."
app.listen(PORT, () => {
    console.log("EXPRESS API RUNNING IN PORT: " + PORT);
});