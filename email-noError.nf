username = System.getProperty("user.name")
params.email_host = "nyumc.org"
params.email_from = "${username}@${params.email_host}"
params.email_to = "${username}@${params.email_host}"

Channel.from([file("email/attachments/RunParameters.tsv"),
    file("email/attachments/multiqc_report.html"),
    file("email/attachments/SampleSheet.csv"),
    // file("email/attachments/demultiplexing_report.html"), // <- this one is causing broken pipe error
    file("email/attachments/RTAComplete.txt"),
    file("email/attachments/Demultiplex_Stats.htm")])
    .into { email_attachments_channel; email_attachments_channel2 }

email_attachments_channel2.subscribe { println "[email_attachments_channel2] ${it}" }

String subject_line = new File("email/subject.txt").text
subject_line = 'noError: ' + subject_line
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
