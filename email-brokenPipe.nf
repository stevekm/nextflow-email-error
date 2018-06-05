username = System.getProperty("user.name")
params.email_host = "nyumc.org"
params.email_from = "${username}@${params.email_host}"
params.email_to = "${username}@${params.email_host}"

Channel.fromPath("email/attachments/*").set { email_attachments_channel }

String subject_line = new File("email/subject.txt").text
subject_line = 'brokenPipe: ' + subject_line
def body = new File("email/body.txt").text
def attachments = email_attachments_channel.toList().getVal()

sendMail {
  from "${params.email_to}"
  to "${params.email_from}"
  attach attachments
  subject subject_line
  """
  ${body}
  """.stripIndent()
}
