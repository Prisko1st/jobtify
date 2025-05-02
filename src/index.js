const express = require("express");
const dotenv = require("dotenv");
const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();
const app = express();

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
    res.send("CONTOH API PROJECT X, start with /api,   /products, /jobs");
});

app.get("/api", (req, res) => {
    res.send("VECTOR KEREN BANGET DONG");
});
app.get("/id", (req, res) => {
  res.send("INI WEBSITE BERBAHASA INDONESIA");
});
app.get("/en", (req, res) => {
  res.send("this is website in english");
});
/* kalau mau bikin database baru trus dimasukkan ke sini, model database harus ditambahkan di schema.prisma dulu
    bisa buat manual dari schema.prisma atau kalau sudah data database nya bisa langsung di pull saja dari database postgresql
    dengan "npx prisma db pull", baru di generate dengan "npx prisma generate"

*/

//dibawah, get /products
app.get("/products", async (req, res) => {
    res.sendFile(path.join(__dirname, "products.html")); //menampilkan frontend + backend hanya dengan /products (no .html)

    /* untuk menampilkan isi database saja
    const products = await prisma.product.findMany();
    res.send(products);
    */
});
//dibawah, metohd post , agar bisa mem-post(input) ke database products
app.post("/products", async (req, res) => {
    const { name, price, description, image } = req.body;
  
    try {
      const newProduct = await prisma.product.create({
        data: {
          name,
          price: parseFloat(price), // convert string to number
          description,
          image,
        },
      });
      res.status(201).json(newProduct);
    } catch (error) {
      console.error("Error adding product:", error);
      res.status(500).json({ error: "Failed to add product" });
    }
  });
  
  

  // Example Express route to support `?q=...`
  app.get("/products/filter", async (req, res) => {
    const { q } = req.query;
  
    const filters = q
      ? {
          OR: [
            { name: { contains: q, mode: "insensitive" } },
            { description: { contains: q, mode: "insensitive" } },
            {
              price: {
                equals: isNaN(parseFloat(q)) ? undefined : parseFloat(q),
              },
            },
          ],
        }
      : {};
  
    try {
      const products = await prisma.product.findMany({
        where: filters,
      });
      res.json(products);
    } catch (error) {
      console.error("Error filtering products:", error);
      res.status(500).json({ error: "Failed to filter products" });
    }
  });
  
  

app.get("/jobs", async (req, res) => {
  res.sendFile(path.join(__dirname, "jobs.html")); //untuk membuka jobs.html hanya dengan /jobs
  /*
    const jobs = await prisma.nation_job.findMany();
    res.send(jobs);
  */
});


app.get("/jobs/filter", async (req, res) => {
  const { q } = req.query;

  try {
    const where = q
      ? {
          OR: [
            { title: { contains: q, mode: "insensitive" } },
            { company: { contains: q, mode: "insensitive" } },
            { company_location: { contains: q, mode: "insensitive" } },
            { company_city: { contains: q, mode: "insensitive" } },
            { company_country: { contains: q, mode: "insensitive" } },
            { job_date: { contains: q, mode: "insensitive" } }
          ]
        }
      : {};

    const filteredJobs = await prisma.nation_job.findMany({ where });

    res.json(filteredJobs);
  } catch (error) {
    console.error("Error fetching filtered jobs:", error);
    res.status(500).json({ error: "Error fetching filtered jobs" });
  }
});



// cara menjalankan server yaitu ketik = "node ." / "nodemon ."
app.listen(PORT, () => {
    console.log("EXPRESS API RUNNING IN PORT: " + PORT);
}); 