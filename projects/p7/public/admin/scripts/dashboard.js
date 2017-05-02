// global variables
var host = window.location.host
var myTerminal;
var helpPage = [
  "This is the help page for the warden's groovy terminal.",
  "Type:",
  "   `help` ... to print this help page",
  "   `exit` ... to leave this groovy terminal",
  "   `<cmd line>` ... to execute <cmd line> on the server.",
  " ",
  "Watch out you don't get into any trouble with all this completely",
  "unnecessary power."
];

$(document).ready(function() {
  var term = new Terminal({
    termDiv: 'terminal',
    closeOnESC: false,
    handler: termHandler
  });
  term.open()
});

function termHandler() {
  var terminal = this

  terminal.newLine();
  var line = terminal.lineBuffer;

  if (line.toLowerCase() == "exit") {
    terminal.close()
    return
  } else if (line == "help") {
    terminal.write(helpPage)
  } else if (line == "clear") {
    terminal.clear()
  } else if (line != "") {
    $.ajax({
      type: 'POST',
      dataType: 'text',
      async: false,
      url: "/api/terminal",
      data: { command: line },
      success: function(data) {
        terminal.write(data)
      },
      error: function(data) {
        terminal.write("could not execute command `" + line + "`")
      }
    });
  }

  terminal.prompt();
}
