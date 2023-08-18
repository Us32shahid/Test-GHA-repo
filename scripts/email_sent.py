import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Email configuration
sender_email = "us323619@gmail.com"
receiver_email = "usamashahid3365@gmail.com"
subject = "Static Website HTML"

# Read HTML content from index.html
with open("index.html", "r") as html_file:
    html_content = html_file.read()

# Additional text
additional_text = """
Hello bahi, I am using python file to add HTMl code in the body of the email. I tried with many workflow formatts from the
github none of them worked with the HTML i was not able to add it in the email body.  so i found a way to do it through the python code.
then i learned how to make my .py file work with the yaml file. 
and now i have the HTML code of the site below as text.

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