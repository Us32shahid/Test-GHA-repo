import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Email configuration
sender_email = "us323619@gmail.com"
receiver_email = "us323619@gmail.com"
subject = "Static Website HTML"

# Read HTML content from index.html
with open("index.html", "r") as html_file:
    html_content = html_file.read()

# Additional text
additional_text = """
Assalam Alikum Farman Bhai, Please find my webpage code below. 

---

{}

---

Thank you,
Usama
""".format(html_content)

# Create the MIMEText object
msg = MIMEMultipart()
msg["Subject"] = subject
msg["From"] = sender_email
msg["To"] = receiver_email

# Attach additional text to the email body
msg.attach(MIMEText(additional_text, "plain"))

# Connect to the SMTP server and send the email
with smtplib.SMTP("smtp.gmail.com", 587) as server:
    server.starttls()
    server.login(sender_email, "etcwcgmikgbkcwyy")  # Use an app-specific password or OAuth token
    server.sendmail(sender_email, receiver_email, msg.as_string())