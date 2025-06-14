# 🎣 Phishing Simulation Project

> **Web Fundamentals Course Project**  
> **Lecturer:** Shiffman David

---

## 📘 Description

This project is a **Phishing Simulation Tool** built in **Bash**, using **Apache**, **PHP**, and **wget**, designed for educational and awareness purposes. It automates every part of a phishing campaign, from cloning a site or using a built-in template to exposing it via public tunnel and logging submitted credentials.

> ⚠️ **Educational Use Only**
> This tool is built as part of the Web Fundamentals course at John Brycec, Think Cyber and is intended for cybersecurity learning and demonstration.

---

## 🧰 Features

- ✅ Automatic installation of required tools (`wget`, `apache2`, `php`, etc.)
- ✅ Website cloning via `wget` or use of built-in Netflix phishing template
- ✅ Credential harvesting via PHP (email, password, IP, timestamp)
- ✅ Apache server setup and configuration
- ✅ Option to use a **custom domain** with SSL via **Certbot**
- ✅ Option to use **localhost.run** for public access (no domain needed)
- ✅ Generates a shortened public URL using **TinyURL**
- ✅ Safe exit traps, colors, banners, and terminal animations

---

## 📁 Project Structure

Phishing-Project/
├── phishing.sh # Main Bash script (automation tool)
├── index.html # HTML phishing page (Netflix)
├── login.php # PHP script to log credentials
├── netflix-bg.jpg # Background image for the template
├── creds.txt # Stores captured credentials
├── debug.log # Optional debug log (if enabled)


---

## 🧪 How to Use

### ▶️ Step 1: Run the Main Script
```bash
sudo bash phishing.sh

▶️ Step 2: Choose an Option

    Clone a website (via URL)

    Use built-in Netflix template

▶️ Step 3: Hosting

    Use a domain (if available)

    Or use localhost.run for public HTTP tunneling

▶️ Step 4: Share Link

    A public link (shortened with TinyURL) is generated

📄 Example Credential Log

Example content of creds.txt:

[2025-05-03 16:45:12] IP: 192.168.1.5 | Email: test@example.com | Password: hunter2

🌐 Domain Setup

If using a real domain (like from GoDaddy):

    The script will auto-create an Apache config

    Certbot will request an SSL certificate

    Ensure your domain A record points to your public IP

🔒 Legal Disclaimer

This project is created solely for educational and training purposes.
Do NOT use this tool for real phishing or illegal activities.
Misuse may result in criminal charges, academic penalties, or legal consequences.
You are solely responsible for your usage. Always have permission when demonstrating phishing.

👨‍🎓 Credits
  Lecturer: Shiffman David
  Institution: John Bryce College & Think Cyber
  Project: Phishing Simulation | Web Fundamentals (RTX2025)
