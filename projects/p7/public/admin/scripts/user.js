var host = window.location.host
var users = []
var glob_user_id;
var tables = []
var user_names_to_id = {}
var curr_table;
var curr_td;
var curr_e;
var curr_dt;
var curr_node;
var curr_config;
var mode;

$(document).ready(function() {
  // close the modal
  $(".close").click(function(e) {
    $("#modalContainer").addClass("hidden").removeClass("shown")

    // clear all the input fields in the modal upon closing
    $(":input[name='name']").val("")
    $(":input[name='password']").val("")
    $(":input[name='salary']").val("")
    $(":input[name='admin']").prop('checked', false);
  });

  // cancel creating/editing via the modal
  $("#cancelButton").click(function() {
    $("#modalContainer").addClass("hidden").removeClass("shown")

    // clear all the input fields in the modal upon closing
    $(":input[name='name']").val("")
    $(":input[name='password']").val("")
    $(":input[name='salary']").val("")
    $(":input[name='admin']").prop('checked', false);
  });

  // submit changes from the modal
  $("[type='submit']").click(function() {
    // close modal
    $("#modalContainer").addClass("hidden").removeClass("shown")

    // get input from modal fields
    var name = $(":input[name='name']").val()
    var password = $(":input[name='password']").val()
    var admin = bool_to_int($(":input[name='admin']").is(":checked"))
    console.log("admin is checked?")
    console.log($(":input[name='admin']").is(":checked"))
    console.log("admin var =")
    console.log(admin)
    var salary = parseInt($(":input[name='salary']").val())

    // clear the input fields no matter what
    $(":input[name='name']").val("")
    $(":input[name='password']").val("")
    $(":input[name='salary']").val("")
    $(":input[name='admin']").prop('checked', false);

    if (mode == "create") {
      user_id = $("table").attr("id")

      // build the object
      new_user_item = {
        name: name,
        password: password,
        admin: admin,
        salary: salary
      }

      // *PUT* it to the back end
      var id;
      $.ajax({
        type: "PUT",
        dataType: "json",
        data: new_user_item,
        async: false,
        url: "/api/user",
        success: function(_) {
           $.get("/api/user", function(data) {
             build_table(data);
           });
        },
        error: function(data) {
          console.log("error\nreceived back:")
          console.log(data)
          return
        }
      });
    } else if (mode == "edit") {
      // change the appropriate JSON user data by ...
      // ... figuring out which row was clicked and which user it's in ...
      var data = curr_table.row(curr_td).data()
      var item_id = data.id
      var user_id = $("table").attr("id")
      var user_idx = user_id[user_id.length - 1]

      // ... finding the local (javascript) user item with id = data.id, in
      // user at index user_id ...
      var user = users[user_idx]
      var idx;
      for (i in user_items_all) {
        item = user_items_all[i]
        if (item.id == item_id) {
          idx = i;
          break;
        }
      }

      // ... create a proposed, altered user item ...
      proposed_user_item = {
        id: user_items_all[idx].id,
        name: name,
        password: password,
        admin: admin,
        salary: salary
      }

      // *POST* the changed user to the back end
      $.ajax({
        type: "POST",
        dataType: "json",
        data: proposed_user_item,
        async: false,
        url: "/api/user",
        success: function(data) {
          // update the local copy
          user_items_all[idx].name = name
          user_items_all[idx].password = password
          user_items_all[idx].admin = admin
          user_items_all[idx].salary = salary

          // update the corresponding row in the table
          curr_table.row(curr_td).data(user_items_all[idx]).draw(false);
        },
        error: function(data) {
          console.log("error\nreceived back:")
          console.log(data)
          return
        }
      });

      // rebind the events (since the table was redrawn)
      bind_delete()
      bind_edit()
    }

  });

  $.get("/api/user", function(data) {
    build_table(data);
  });


});


var delete_button =
      "<span class='ui-icon ui-icon-closethick'></span>"

var edit_button =
      "<span class='ui-icon ui-icon-pencil'></span>"

var table_template =
      "<table id='usersTable' class='display' cellspacing='0' width='100%'>\n" +
      " <thead>\n" +
      "   <tr>\n" +
      "     <th>Delete</th>\n" +
      "     <th>Edit</th>\n" +
      "     <th>Username</th>\n" +
      "     <th>Admin</th>\n" +
      "     <th>Salary</th>\n" +
      "   </tr>\n" +
      " </thead>\n" +
      " <tfoot>\n" +
      "   <tr>\n" +
      "     <th>Delete</th>\n" +
      "     <th>Edit</th>\n" +
      "     <th>Username</th>\n" +
      "     <th>Admin</th>\n" +
      "     <th>Salary</th>\n" +
      "   </tr>\n" +
      " </tfoot>\n" +
      "</table>\n"

function build_table(data) {
  user_items_all = data;
  $("#menusDiv").html(table_template)

  var btns = []

  if (!$("input[name=admin]").attr("disabled")) {
  btns = [{
        text: 'New User',
        action: function () {
          mode = "create"
          draw_modal()
        }
      }];
  }

  // add a table for it
  curr_table = $("#usersTable").DataTable({
    data: data,
    dom: 'Bfrtip',
    buttons: btns,
    columns: [
      {
        "data": null,
        "defaultContent": delete_button
      },
      {
        "data": null,
        "defaultContent": edit_button
      },
      {"data": "name"},
      {
        "data": "admin",
        "render": function (data, type, full, meta) {
          return (data == 1)
        }
      },
      {"data": "salary"}
    ]
  });

  bind_delete()
  bind_edit()
}

function bool_to_int(b) {
  if (b) {
    return 1
  } else {
    return 0
  }
}

function int_to_bool(i) {
  return (i == 1)
}

function bind_delete() {
  // first unbind all click events to avoid unintentional deletes
  $(".ui-icon-closethick").unbind("click")

  // rebind click events
  $(".ui-icon-closethick").click(function() {
    var td = $(this).parent()
    var data = curr_table.row(td).data()
    var item_id = data.id
    user_id = $("table").attr("id")
    user_idx = user_id[user_id.length - 1]

    // find the local (javascript) user item with id = data.id, in
    // user at index user_id
    var user = users[user_idx]
    var idx;
    for (i in user_items_all) {
      item = user_items_all[i]
      if (item.id == item_id) {
        idx = i;
        break;
      }
    }

    // remove the row from the remote database
    $.ajax({
      type: "DELETE",
      dataType: "json",
      data: { id: user_items_all[idx].id },
      async: false,
      url: "/api/user",
      success: function(data) {
        // remove the local copy
        var deleted_item = user_items_all.splice(idx, idx + 1)

        // remove the row from the table
        curr_table.row(td).remove().draw(false)
      },
      error: function(data) {
        console.log("error\nreceived back:")
        console.log(data)
        return
      }
    });
  });
}

function bind_edit() {
  // unbind the click event first
  $(".ui-icon-pencil").unbind("click")

  // rebind the click event
  $(".ui-icon-pencil").click(function() {
    curr_td = $(this).parent()
    data = curr_table.row(curr_td).data()

    // populate modal with data from row
    $(":input[name='name']").val(data.name)
    // $(":input[name='password']").val(data.password)
    $(":input[name='salary']").val(data.salary)
    $(":input[name='admin']").prop('checked', int_to_bool(data.admin))

    // open modal
    mode = "edit"
    draw_modal()
  });
}

function draw_modal() {
  $("#modalContainer").addClass("shown").removeClass("hidden")
}
