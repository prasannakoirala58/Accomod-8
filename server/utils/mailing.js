const nodemailer = require('nodemailer');
const fs = require('fs');
const path = require('path');

module.exports = class Email {
  constructor(user, url) {
    this.to = user.email;
    this.firstName = user.profile.first_name;
    this.url = url;
    this.from = `Prasanna Koirala <${process.env.EMAIL_FROM}>`;
  }

  newTransport() {
    // Sendgrid
    return nodemailer.createTransport({
      service: 'SendGrid',
      auth: {
        user: process.env.SENDGRID_USERNAME,
        pass: process.env.SENDGRID_PASSWORD,
      },
    });
  }

  // Send the actual email
  async send(html, subject) {
    // 1) Define the email options
    const mailOptions = {
      from: this.from,
      to: this.to,
      subject,
      html,
      contentType: 'text/html',
    };

    // 2) Create a transport and send email
    await this.newTransport().sendMail(mailOptions);
  }

  async sendPasswordReset() {
    const htmlContent = fs.readFileSync(
      path.join(__dirname, 'email', 'passwordReset.html'),
      'utf-8'
    );
    console.log('Yo url ho hai resetToken ko :', this.url);
    // Replace the placeholder with the actual value
    const replacedContent = htmlContent
      .replace('{{firstName}}', this.firstName)
      .replace('{{url}}', this.url);
    await this.send(replacedContent, 'Your password reset token (valid for only 10 minutes)');
  }
};
