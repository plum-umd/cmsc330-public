var host = window.location.host
var menus = []
var glob_menu_id;
var glob_name;
var tables = []
var menu_names_to_id = {}
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
    $(":input[name='price']").val("")
    $("#descriptionText").val("")
  });

  // cancel creating/editing via the modal
  $("#cancelButton").click(function() {
    $("#modalContainer").addClass("hidden").removeClass("shown")

    // clear all the input fields in the modal upon closing
    $(":input[name='name']").val("")
    $(":input[name='price']").val("")
    $("#descriptionText").val("")
  });

  // submit changes from the modal
  $("[type='submit']").click(function() {
    // close modal
    $("#modalContainer").addClass("hidden").removeClass("shown")

    // get input from modal fields
    var name = $(":input[name='name']").val()
    var price = $(":input[name='price']").val()
    var description = $("#descriptionText").val()

    // clear the input fields no matter what
    $(":input[name='name']").val("")
    $(":input[name='price']").val("")
    $("#descriptionText").val("")

    if (mode == "create") {
      menu_id = $("table").attr("id")

      // build the object
      new_menu_item = {
	menu: glob_menu_id,
        name: name,
        price: price,
        description: description
      }

      // *PUT* it to the back end
      var id;
      $.ajax({
        type: "PUT",
        dataType: "json",
        data: new_menu_item,
        async: false,
        url: "/api/item",
        success: function(data) {
          $.get("/api/item", { menu: glob_menu_id }, function(data) {
            build_table(glob_menu_id, glob_name, data.item);
          });
        },
        error: function(data) {
          console.log("error\nreceived back:")
          console.log(data)
          return
        }
      });

      // add the new menu item to the local menu item array
//      menu_items_all.push(new_menu_item);

      // and add the corresponding new row to the table
      /*
      curr_table.row.add({
          "name": name,
          "price": price,
          "description": description
      }).draw(false);
      */

      // rebind the events (since the table was redrawn)
    } else if (mode == "edit") {
      // change the appropriate JSON menu data by ...
      // ... figuring out which row was clicked and which menu it's in ...
      var data = curr_table.row(curr_td).data()
      var item_id = data.id
      var menu_id = $("table").attr("id")
      var menu_idx = menu_id[menu_id.length - 1]

      console.log("data = ")
      console.log(data)
      console.log("item_id = " + item_id)
      console.log("menu_id = " + menu_id)
      console.log("menu_idx = " + menu_idx)

      // ... finding the local (javascript) menu item with id = data.id, in
      // menu at index menu_id ...
      var menu = menus[menu_idx]
      var idx;
      for (i in menu_items_all) {
        item = menu_items_all[i]
        if (item.id == item_id) {
          idx = i;
          break;
        }
      }

      // ... create a proposed, altered menu item ...
      proposed_menu_item = {
        id: menu_items_all[idx].id,
        menu: glob_menu_id,
        name: name,
        price: price,
        description: description
      }

      // *POST* the changed menu to the back end
      $.ajax({
        type: "POST",
        dataType: "json",
        data: proposed_menu_item,
        async: false,
        url: "/api/item",
        success: function(data) {
          // update the local copy
          menu_items_all[idx].name = name
          menu_items_all[idx].price = price
          menu_items_all[idx].description = description

          // update the corresponding row in the table
          curr_table.row(curr_td).data(menu_items_all[idx]).draw(false);
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

  // load the menus from the rest api
  $.ajax({
    type: "GET",
    dataType: "json",
    async: false,
    url: "/api/menu",
    success: function(data) {
      build_dropdown(data)
    },
    error: function(data) {
      menus = data
      console.log("error\nreceived back:")
      console.log(data)
    }
  });
});

var delete_button =
      "<span class='ui-icon ui-icon-closethick'></span>"

var edit_button =
      "<span class='ui-icon ui-icon-pencil'></span>"

var select_example =
      "<optgroup label='Scripts'>\n"
      " <option value='jquery'>jQuery.js</option>\n"
      " <option value='jqueryui'>ui.jQuery.js</option>\n"
      "</optgroup>"

var table_template =
      "<table id='menusTable_menu_id_' class='display' cellspacing='0' width='100%'>\n" +
      " <thead>\n" +
      "   <tr>\n" +
      "     <th>Delete</th>\n" +
      "     <th>Edit</th>\n" +
      "     <th>Item</th>\n" +
      "     <th>Price</th>\n" +
      "     <th>Description</th>\n" +
      "   </tr>\n" +
      " </thead>\n" +
      " <tfoot>\n" +
      "   <tr>\n" +
      "     <th>Delete</th>\n" +
      "     <th>Edit</th>\n" +
      "     <th>Item</th>\n" +
      "     <th>Price</th>\n" +
      "     <th>Description</th>\n" +
      "   </tr>\n" +
      " </tfoot>\n" +
      "</table>\n"

function build_dropdown(data) {
  // save the data to global
  menus = data.menu;

  // populate the select menu
  $("#selectMenus").append("<optgroup label='Menus' id='optgroupMenus'></optgroup>")
  for (i in menus) {
    menu = menus[i]
    if (menu) {
      $("#optgroupMenus").append("<option value='" + menu.id + "'>" +
                                    menu.name +
                                  "</option>")
    }
  }

  // build the dropdown
  $("#selectMenus").selectmenu({
    change: function(event, data) {
      // data.item.value = index of menu in menus array
      // data.item.label = name of menu
      var id = data.item.value;
      glob_menu_id = id;
      var name = data.item.innerText;
      glob_name = name;
           $.get("/api/item", { menu: id }, function(data) {
	      build_table(id, name, data.item);
           });
    }
  });
}

function build_table(id, name, data) {
menu_items_all = data;
  $("#menusDiv").html(table_template.replace(/_menu_id_/g, id.toString()).
                                     replace(/_menu_name_/g, menu.name))

  // add a table for it
  curr_table = $("#menusTable" + id.toString()).DataTable({
    data: data,
    dom: 'Bfrtip',
    buttons: [
      {
        text: 'New Menu Item',
        action: function () {
          mode = "create"
          draw_modal()
        }
      }
    ],
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
      {"data": "price"},
      {"data": "description"},
    ]
  });

  bind_delete()
  bind_edit()
}

function bind_delete() {
  // first unbind all click events to avoid unintentional deletes
  $(".ui-icon-closethick").unbind("click")

  // rebind click events
  $(".ui-icon-closethick").click(function() {
    var td = $(this).parent()
    var data = curr_table.row(td).data()
    var item_id = data.id
    menu_id = $("table").attr("id")
    menu_idx = menu_id[menu_id.length - 1]

    // find the local (javascript) menu item with id = data.id, in
    // menu at index menu_id
    var menu = menus[menu_idx]
    var idx;
    for (i in menu_items_all) {
      item = menu_items_all[i]
      if (item.id == item_id) {
        idx = i;
        break;
      }
    }

    // remove the row from the remote database
    $.ajax({
      type: "DELETE",
      dataType: "json",
      data: { id: menu_items_all[idx].id },
      async: false,
      url: "/api/item",
      success: function(data) {
        // remove the local copy
        var deleted_item = menu_items_all.splice(idx, idx + 1)

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
  // umbind the click event first
  $(".ui-icon-pencil").unbind("click")

  // rebind the click event
  $(".ui-icon-pencil").click(function() {
    curr_td = $(this).parent()
    data = curr_table.row(curr_td).data()

    // populate modal with data from row
    $(":input[name='name']").val(data.name)
    $(":input[name='price']").val(data.price)
    $("#descriptionText").val(data.description)

    // open modal
    mode = "edit"
    draw_modal()
  });
}

function draw_modal() {
  $("#modalContainer").addClass("shown").removeClass("hidden")
}
