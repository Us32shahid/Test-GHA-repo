import smtplib
from email.mime.text import MIMEText
import os

def send_email(subject, body, recipient_emails):
    sender_email = "us323619@gmail.com"
    sender_password = "etcwcgmikgbkcwyy"

    msg = MIMEText(body)
    msg["Subject"] = subject
    msg["From"] = sender_email
    msg["To"] = ", ".join(recipient_emails)  # Concatenate email addresses

    try:
        with smtplib.SMTP("smtp.gmail.com", 587) as server:
            server.starttls()
            server.login(sender_email, sender_password)
            server.sendmail(sender_email, recipient_emails, msg.as_string())
            print("Email sent successfully")
    except Exception as e:
        print("An error occurred:", e)

trigger_count = int(os.environ.get("GITHUB_RUN_NUMBER", 0))
dns_name = os.environ.get("RECORD_NAME", "")
dns_type = os.environ.get("RECORD_TYPE", "")
dns_ip = os.environ.get("RECORD_CONTENT", "")

# Get the result of the DNS record update from the previous step
dns_result = f'''
DNS record updated by workflow. Trigger count: {trigger_count}
DNS Details:
  Name: {dns_name}
  Type: {dns_type}
  IP Address: {dns_ip}
'''
send_email("DNS Record Update Result", dns_result, ["us323619@gmail.com"])
