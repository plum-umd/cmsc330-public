// global vars
var host = window.location.host
var menus = {}
var frufru_menu = true

// on page init, load the the menus from the backend via ajax
$(document).ready(function() {
  setTimeout(fadein, 100)

  $.get("/api/collate_menus", function(data) {
    var src = $(".menu-tmpl").html();
    var tmpl = Handlebars.compile(src);
    $("#menus").append(tmpl(data));
  });


  /*
  $.ajax({
    type: "GET",
    dataType: "json",
    url: "http://" + host + "/rest/menus",
    success: function(data) {
      menus = data

    },
    error: function(data) {
      menus = data
      console.log("received back:")
      console.log(data)
    }
  });
  */
});

function fadein() {
  // $("#contentContainer").removeClass("fadeout");
  $("#contentContainer").addClass("fadein");
}

/* ********************************** */
/*          CONTENT DISPLAY           */
/* ********************************** */

// menu templates
var template_menu_section_start =
                          '<div class="menu-section" id="_menu_id_">' +
                          ' <h2 class="menu-section-title" id="_menu_name_">' +
                          '   _menu_name_' +
                          ' </h2>'
var template_menu_section_end = '</div>'
var template_menu_item =
                '<!-- Item starts -->\n' +
                '<div class="menu-item" id="_item_id_">\n' +
                '\t<div class="menu-item-name">\n' +
                '\t\t_item_name_\n' +
                '\t</div>\n' +
                '\t<div class="menu-item-price">\n' +
                '\t\t_item_price_\n' +
                '\t</div>\n' +
                '\t<div class="menu-item-description">\n' +
                '\t\t_item_description_\n' +
                '\t</div>\n' +
                '</div>\n' +
                '<!-- Item ends -->\n'

// transform a json menu list to an html string
function display_menus(menus) {
  menu_html = ""
  for (i in menus) {
    menu = menus[i]

    if (menu) {
      menu_html += build_menu_section_start(menu.id, menu.name);
      for (j in menu.menu_items) {
        menu_item = menu.menu_items[j]

        if (menu_item) {
          menu_html += build_menu_section_item(menu.name, menu_item);
        }
      }

      menu_html += build_menu_section_end(menu.name);
    }
  }
  $("#menus").append(menu_html)
}

function frufru_price(price) {
  return parseInt(price)
}

// build start of menu section html
function build_menu_section_start(menu_id, menu_name) {
  return template_menu_section_start.replace(/_menu_id_/g, menu_id).
                                     replace(/_menu_name_/g, menu_name);
}

// build menu item html
function build_menu_section_item(menu_name, menu_item) {
  if (frufru_menu) {
    menu_item.price = frufru_price(menu_item.price)
  }

  return template_menu_item.replace(/_item_id_/g, menu_item.id).
                            replace(/_item_name_/g, menu_item.name).
                            replace(/_item_price_/g, menu_item.price).
                            replace(/_item_description_/g, menu_item.description);
}

// build end of menu section html
function build_menu_section_end(menu) {
  return template_menu_section_end
}

/* ********************************** */
/*          EVENT LISTENERS           */
/* ********************************** */

// enable the menu bar transform on scroll:
$(window).scroll(function() {
  var scroll = $(window).scrollTop();

  if (scroll >= 10) {
    $(".larger").removeClass("larger").addClass("smaller");
  } else {
    $(".smaller").removeClass("smaller").addClass("larger");
  }
});

/* ********************************** */
/*         SAMPLE MENU DATA           */
/* ********************************** */

mock_menu = [
  {
    "id": 1,
    "name": "breakfast",
    "menu_items": [
      {
        "id": 2,
        "name": "The Traditional",
        "price": 11.99,
        "description": "Two fresh cage-free eggs any style with your choice of grilled ham steak, thick-sliced bacon, turkey sausage or sausage links. Served with whole grain artisan toast, all-natural preserves and fresh, seasoned potatoes."
      },
      {
        "id": 3,
        "name": "Tri-Fecta",
        "price": 12.99,
        "description": "Two fresh cage-free eggs* any style with either a light and airy Belgian waffle or a multigrain pancake. Plus your choice of bacon, turkey sausage or pork sausage link."
      }
    ]
  },
  {
    "id": 4,
    "name": "lunch",
    "menu_items": [
      {
        "id": 5,
        "name": "Roast Beef and Havarti Sandwich",
        "price": 9.99,
        "description": "Roast beefs Horseradish Havarti, house-roasted onions and tomato with lemon dressed arugula on grilled Parmesan-crusted sourdough, Horseradish sauce on the side."
      },
      {
        "id": 6,
        "name": "2 For You",
        "price": 10.99,
        "description": "Choose two from the following: a half sandwich, half salad, and cup of soup. Sandwich choices include Monterey Club, Ham & Gruyere Melt, Market Veggie, and Roast Beef & Havarti."
      }
    ]
  },
  {
    "id": 7,
    "name": "dinner",
    "menu_items": [
      {
        "id": 8,
        "name": "Croque Madame",
        "price": 13.49,
        "description": "Smoked ham, tomato, Gruyere cheese and Dijonnaise on grilled artisan brioche. Topped with béchamel sauce, two cage-free eggs and fresh herbs."
      },
      {
        "id": 9,
        "name": "Shrimp & Grits",
        "price": 14.99,
        "description": "Sautéed shrimp and Andouille sausage in a Cajun low-country reduction with house-roasted tomatoes, onions, peppers, corn and fresh herbs on Bob’s Red Mill Cheddar Parmesan cheese grits. Served with artisan Ciabatta toast."
      }
    ]
  }
]
