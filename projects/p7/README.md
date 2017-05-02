# Project 7: Introduction to Cybersecurity
CMSC 330, Spring 2017 (Due May 11, 2017)

Ground Rules
------------
This **is** a pair project. If you like, each partner might take a role. One as the adversary, attacking the website and trying to identify and exploit its vulnerabilities. The other might function as the developer, fixing the vulnerabilities the pen tester alerts them to.

You may work with one other person, but make sure you both make your own submissions, as you will still be graded independently. Discussing any vulnerability with anyone other than your partner is an academic integrity violation.

Overview
------------
In this project we provide an exploitable web server implementation for a restaurant's online menu and administration pages. This is a complete dynamic web application with three components:

  - The web browser *front-end*, acting as a *client*, which runs code written in HTML, CSS, and JavaScript. This code is served by the back-end when the browser requests it with a URL via the Hypertext Transfer Protocol (HTTP).
  - A *back-end*, or *server*, usually written in Ruby, NodeJS, Go, Java EE, C#, C++, or even Erlang! The server processes client HTTP requests, which may involve interactions with a database. 
    * In addition, the back-end may sometimes host a [REST API](https://en.wikipedia.org/wiki/Representational_state_transfer). This project uses such an API; you'll read more about how this works in the API Documentation section.
  - A *database* (SQLite, MySQL, PostgreSQL, MongoDB, Cassandra), often colocated with the server, stores important data and is accessed by the server in response to client requests. The server interacts with the database through some kind of query language, often SQL. 

This project's back-end (written in Ruby in the file `controller.rb`) is buggy, and is vulnerable to exploitation. Your job is to identify and fix as many of the vulnerabilities as possible. You should do this by **first** understanding the security invariants we describe below (these are the things the web app *should* and *shouldn't* let you do) and **then** poking around at the website to see if the web app actually abides by those rules. Then you can modify the code that violates the rules; the **only** code you will need to change is in `controller.rb`.

Running the Project
-------------------
To install the dependencies, run `bundle install` in the project root directory. 

To run the web server, run `ruby main.rb`. Direct your browser to `http://localhost:3300/`.

Files
-----------------
The project may at first seem complex. However, you needn't feel overwhelmed: there is only **one** source code file that you will ever need to look at, fathom, and make changes to: `controller.rb`. This file contains the core back-end logic, and it is also where the web app's vulnerabilities may be found and fixed. You will also be required to modify the database which is in `data.db`.

<!-- MWH: Feels like a bait and switch: You keep saying only modify controller.rb, but then you bring up data.rb. Then, confusingly, this file is not present in the list below. What's going on? -->

That said, here is a quick outline of the files we have provided, that make up the site:

- Ruby file (you should edit)
  - **controller.rb**: All your modifications should be made to this file.
- Provided files (no need to edit, changes will be overwritten!)
  - **public/**: This directory contains all the resources the front-end needs to run (fonts, images, scripts (in JavaScript), styling (in CSS)).
  - **views/**: This directory contains all the HTML files.
  - **main.rb**: This is the driver file that runs the web server.
  - **data.db**: The database is housed in this file.
  - **Gemfile**: This file contains a list of project dependencies (the server, the database, etc.). These all happen to be Ruby "gems," and bundling them into a "Gemfile" allows us to install them all at once by simply running the command `bundle install` in the same directory.
- Submission Scripts and Other Files
  - **submit.rb**: Execute this script to submit your project to the submit server.
  - **submit.jar** and **.submit**: Don't worry about these files, but make sure you have them.
  - **pack_submission.sh**: Execute this script to zip your project for web submission.
  
Website Structure
-----------------
The website serves a set of public-facing pages and a set of private pages. To view the private pages, you must first login (or at any rate, this is the intended behavior, unless this part of the server is buggy!). Once a user has logged in, he or she has either employee or admin privileges, depending on his or her account settings. Then she may be able to see private pages.

The public pages, available from `<website root>` (which, if you're running the server on your own machine, should be `http://localhost:3300`), are:

- `<website root>/index`: the restaurant's main page.
- `<website root>/menu`: displays the restaurant's menu.
- `<website root>/about`: tells the restaurant's dramatic story.
- `<website root>/login`: allows employees and admins to log in.

The private pages, available from `<website root>/admin` (which, if you're running the server on your own machine, should be `http://localhost:3300/admin`), are:

- `<website root>/admin/dashboard`: presents **admins only** with a shell for executing commands on the server (not available to employees).
- `<website root>/admin/menu`: presents **admins and employees** with an interface for viewing and modifying the menu.
- `<website root>/admin/users`: presents **admins** with an interface for viewing and modifying user profiles generally and **employees** with an interface for viewing and modifying **their own profile only**.

REST API 
-----------------
The website's URL structure also supports a kind of API, called a REST API. This API is simply a mapping from HTTP request types and URLs:

  - GET <resource URL>
  - POST <resource URL>
  - PUT <resource URL>
  - DELETE <resource URL>

onto operations on resources:

  - Read
  - Update
  - Create
  - Delete

This enables a client (web page), running in a browser, to call methods on the back-end (server) simply by sending HTTP messages to the server.

As an example, to view all the menu items from the menu with an ID of 1, we could type the URL `http://localhost:3300/api/item?id=1` in the browser window. Doing this sends a `GET` request to `localhost:3300` for  URL `/api/item` with parameter `id=1`.

A more typical way to use a REST API is to use the command-line program cURL. cURL is a utility for transferring data over networks using various protocols. In particular, we're interested in the HTTP protocol, because that's how we communicate with our application's REST interface.

To send an HTTP message using cURL, the basic command format is:

  - `curl -X <method> <URL> [-F <parameter> [-F <another-parameter>] [etc.]]]`
  
The HTTP `<method>`s we can use are `GET`, `POST`, `PUT`, and `DELETE`. The `<URL>`s for our REST interface are listed below, along with the parameters they take, and the resources they expose.

So, for the example above, to view all the menu items from the menu with an ID of 1, we would send a `GET` request to the URL `http://localhost:3300/api/item` with parameter `id=1`. To do this, we could use the cURL command `curl -i -X GET "http://localhost:3300/api/item" -F "id=1"`. Each of the parameters is effectively added to the URL

To get all of the menus, we could use the cURL command `curl -i -X GET "http://localhost:3300/api/menu"`.

To update menu item 1 with a new name, or price, or description, we could use the cURL command `curl -i -X POST "http://localhost:3300/api/item" -F "id=1" -F "menu=0" -F "name=some_name" -F "price=some_price" -F "description=some_description"`

- `GET /api/item`
  - **Parameters**: `menu`
  - **Description**: Returns menu items for menu of id `menu`.
- `POST /api/item`
  - **Parameters**: `id`, `menu`, `name`, `price`, `description`
  - **Description**: Updates item with given `id`, from menu with id `menu`.
- `PUT /api/item`
  - **Parameters**: `menu`, `price`, `description`
  - **Description**: Creates new menu item.
- `DELETE /api/item`
  - **Parameters**: `id`
  - **Description**: Deletes item with given id.
- `GET /api/menu`
  - **Parameters**: None
  - **Description**: Returns list of all menus.
- `POST /api/menu`
  - **Parameters**: `id`, `name`
  - **Description**: Updates menu with given id.
- `PUT /api/menu`
  - **Parameters**: `name`
  - **Description**: Creates new menu.
- `DELETE /api/menu`
  - **Parameters**: `id`
  - **Description**: Deletes menu with given id.
- `GET /api/collate_menus`
  - **Parameters**: None
  - **Description**: Returns all menus and their items.
- `GET /api/user`
  - **Parameters**: None
  - **Description**: Returns list of all users.
- `POST /api/user`
  - **Parameters**: `id`, `name`, `password`, `admin`, `salary`
  - **Description**: Updates user with given id.
- `PUT /api/user`
  - **Parameters**: `name`, `password`, `admin`, `salary`
  - **Description**: Creates new user. Note that admin is expected to be 1 or 0.
- `DELETE /api/user`
  - **Parameters**: `id`
  - **Description**: Deletes user with given id.
- `GET /api/authenticate`
  - **Parameters**: `name`, `password`
  - **Description**: Verify credentials and sets cookie to appropriate session token.
- `GET /api/terminal`
  - **Parameters**: `command`
  - **Description**: Executes command on server.

Controller Class
----------------
The Controller class consists of a series of modules, each defining methods invoked by interactions with the server. The web server basically receives via the URLs described above, and arranges to invoke the relevant methods in these modules; you do not need to worry about these details. 

Below is the functionality of each module. **If a user is not permitted to perform an action the method should do no action and return false.**

- Menu
  - `create_menu(name)` creates a new menu with the given name.
  - `read_menu()` returns an array containing all menus.
  - `update_menu(id, name)` changes the name of the menu with given ID.
  - `delete_menu(id)` deletes menu with given ID.
- Item
  - `create_item(menu, name, price, description)` creates a menu item.
  - `read_item()` returns an array containing all menu items.
  - `update_item(id, menu, name, price, description)` updates item with given ID.
  - `delete_item(id)` deletes item with given ID.
- User
  - `create_user(name, password, admin, salary)` creates a new user.
  - `read_user()` returns an array containing all users.
  - `update_user(id, name, password, admin, salary)` updates user with given ID.
  - `delete_user(id)` deletes user with given ID.
- Access
  - `create_session()` creates a new session and returns session ID.
  - `authenticate(name, password)` if credentials match, returns session ID with escalated privileges. Otherwise, returns `-1`.
  - `escalate(user_id, session_id)` associates a user with a session ID.
  - `authorize(session_id)` returns the user associated with session ID. Otherwise, return `-1`.
  - `delete_session(id)` deletes a session.
  - `guard(session_id)` if true, the driver allows access to administrator pages. Otherwise, it redirects to login page.
- Terminal
  - `shell(command)` return result of running command.

The Controller class contains several instance variables you will find relevant:

- `@db` is initialized to the SQLite database object
- `@session_id` stores the requester's session ID
- `@shell_pwd` stores the shell's current working directory path
- `@controller_pwd` stores the project directory path

Database
----------------

If you'd like to take a look at which users exist in the database and what privileges they have, you can run `sqlite3 data.db` in the project root directory and then type `SELECT * FROM Users;`. You should see a list like this:

```
rubyray|rubyray|0|10000
ocamlollie|ocamlollie|0|50000
prologpete|prologpete|0|30000
lambdalou|lambdalou|1|100000
sqlsam|sqlsam|1|80000
```

Each row is a *record* corresponding to a single user. The columns correspond to: username, password, admin privilege (`0` or a `1` should be understood as a boolean indicating whether or not a given user has admin privilege), and salary.

The web application server will  interact with this database, and use it to determine which pages are OK to serve, based on who is logged in.

Part 1: Security Invariants
-------------------
The rest of this writeup is structured around security invariants, which are certain things that **must** hold true about the behavior of the web app **in order for it to be considered secure**. The following sections will walk you through each invariant one by one. Read them very carefully—they describe things that you *shouldn't* be allowed to do, but that the current implementation *might possibly* allow you to.

Each of the sub-sections below are independent of one another. We recommend you work through each requirement slowly and determine if the invariant holds or not. If you get stuck on a section you may want to move on.

### URL and API Authorization

There are two levels of privilege in our web application: administrator, employee.

Any **employee** action is restricted to only logged-in employees. Employee actions include:

- any operation that *modifies* the menu
  - modifying menus and items
  - creating menus and items
  - deleting menus and items
- some operations on your user profile
  - viewing your user profile
  - changing your username
  - changing your password
- viewing some company pages: `/admin/menu`, `/admin/users`

Any **administrative** action is restricted to only logged-in administrators. Administrative actions include:

- any employee action above
- any operation on any user profiles
  - viewing user profiles
  - modifying user profiles
  - creating user profiles
  - deleting user profiles
- running the shell
- viewing all company pages: `/admin/dashboard`, `/admin/menu`, `/admin/users`

These actions are subject to the following restrictions:

- Employees may not view the dashboard or use the shell.
- Employees may not view or modify other users.
- Employees may not make themselves administrator or give themselves a raise.
- No one, employee nor administrator, may delete their own account.
- All session tokens are revoked when an account is deleted.

The portions of the REST API that allow modification of the database or viewing and editing of user profile information should be strictly inaccessible except to someone logged-in with an account of the appropriate privilege. For information on how to call the REST API, see the above section entitled API Documentation.

### Shell Restriction

The administrator shell must be restricted to the project directory and its contents. Accessing files and directories outside of this directory is forbidden. One should not be allowed to delete `data.db`, `controller.rb`, or `main.rb`. This keeps admins from shooting themselves in the foot or unintentionally destroying the web app. There are a number of methods in Ruby's [Dir](https://ruby-doc.org/core-2.2.0/Dir.html) and [File](https://ruby-doc.org/core-2.2.0/File.html) classes that may come in handy.

**The web shell really has access to your filesystem**, so don't type anything into it that you wouldn't type into your normal terminal. We recommend you commit often with `git`.

### Database Access

Database access and storage must be strictly limited to the API's intended functionality. That is, the REST API exposes only certain operations on certain data—even to admins. Specifically, it only allows access to the menu and the user profiles.

It does *not* allow access, for instance, session data, which is also stored in the database. The database should therefore not be allowed to respond to queries for data that the REST API was not designed to provide access to.

### Code Storage

Employees nor administrators should not be able to store live (unescaped) code (i.e. HTML or JavaScript) in the database. In particular, in the Users, Menu, or Items tables as these are directly displayed by the front end.

Part 2: Password Hashing
------------------------
Keeping passwords safe is critical for any application. Let's check how our restaurant stores its passwords.

In the project directory run `sqlite3 data.db`. This brings up the SQLite top-level where you can query the database. Entering the command `.tables` will list all the tables. We can inspect the schema of the Users table with `.schema Users`. We see the first column is the name (`Name VARCHAR(255)`) and the second is the password (`Password VARCHAR(255)`). We can query the actual database to see the records with `SELECT Name, Password FROM Users;` (note the `;` after the command line -- you'll need this after any SQL command that doesn't begin with a period). You'll see a list that looks like:

```
rubyray|rubyray|0|10000
ocamlollie|ocamlollie|0|50000
prologpete|prologpete|0|30000
lambdalou|lambdalou|1|100000
sqlsam|sqlsam|1|80000
```

Each line represents a user record. Within each line, the item to the left of the pipe is the username and the item to the right of the pipe is the password. Yikes! The passwords are being stored in plain-text.

Storing passwords as plain-text is dangerous. If an attacker ever gets access to the database, by SQL injection or other means, they can steal the passwords of all the users. For people who reuse passwords, this could be catastrophic to their online identity. We're going to solve this using the standard technique of hashing and salting. This section will explain what hashing and salting are, and why we use them; and will then provide you with the guidance you need to implement them in `controller.rb`.

A **hash function** is a mathematical function that maps some piece of data of arbitrary size to a corresponding piece of data (a bit string) of fixed size. The key idea here is *collision resistance*—one should not be able to find two pieces of data that the hash function maps to the same bit string.

A **cryptographic hash function** is a hash function used to encrypt things (like passwords); as such, it has the additional property of being a *one-way function*—a function that is difficult (i.e. intractable) to invert. Given a good hash, it should be relatively easy to hash a password. However, if someone gives me a password that they just hashed, it should be very hard for me to figure out what the password originally was. Lastly, the input to a cryptographic hash function is usually called the *message*, and the (hashed) output is usually called the *digest*.

How is this used in practice? Rather than storing a user's actual password, we immediately hash it and store the hashed value. Then, whenever a user tries to log in, we hash the password the user gives, and check that the hashed value matches what is stored in the database.

You **must** use Ruby's implementation of the SHA-2 cryptographic hash function—specifically, the 256-bit digest `Digest::SHA256.hexdigest`. You can find documentation [here](https://ruby-doc.org/stdlib-2.1.0/libdoc/digest/rdoc/Digest.html).

SHA-2 is moderately secure (although there are more secure cryptographic hashing functions). Specifically, given a digest size of *L*, a brute-force attack could take up to *2^L* attempts to find the original, unhashed password. Our digest size will be 256 bits, and 2^256 is about 1 with 77 zeros after it.

However, before you go hashing users' passwords and imagining that this is secure, ask yourself—do you really trust users to come up with good passwords? Have you ever thought how often a user simply uses "password" as their password? Cryptographic hashing aside, imagine the following: an attacker somehow gets ahold of a web app's Users table, replete with usernames and hashed passwords. To recover the original passwords, he downloads a dictionary (called a rainbow table) with millions or more common password hashes until he finds a match from the web app's database. If the hashes match, that plain-text password is likely the user's password. To prevent this, we will **salt** the users' passwords.

This means that, whenever a user creates an account or changes his or her password, we generate a new random salt (i.e., some bit string) that we store in the same table where the password is kept. Rather than hash their password, we hash the concatenation: `password + salt`. This is essentially a way of strengthening a user's password and rendering it harder (though certainly not impossible) to discover using a dictionary attack. If your salt is only 16 bits long, then there are only 65,536 possible salts — so the attacker need only hash 65,536 `password + salt` combinations per password in his or her lookup table. Given a relatively fast hashing function (like SHA-2), this won't take very long on a modern GPU.

To make the attacker's job too difficult to be worth it, we use a long salt; a rule of thumb would have us pick a salt that's the same length as the hashing function's output — in this case, 256 bits (or 32 bytes). To do this, we use a cryptographically secure pseudo-random number generator (CSPRNG) that someone else has designed—**never try to make up your own functions for cryptographic hashing or salt-generation!** This is not the same as a normal, run-of-the-mill random number generator; CSPRNGs are required to be proven to pass certain tests of statistical randomness (e.g., the next-bit test) and are typically written by professional mathematicians. The same goes for cryptographic hashing functions—do **not** try and write your own.

The Ruby standard library provides us with a module called `SecureRandom`, which implements such a CSPRNG. We link to the documentation [here](http://www.rubydoc.info/stdlib/securerandom/1.9.3/SecureRandom). We recommend you use `SecureRandom.hex` for your salt.

In order to store each user's salt, you'll have to add a column to the Users table in the database. 

Here are some SQL commands that will be helpful:

- SELECT * FROM table;
  - **Description**: Queries ALL columns
  - **Example**: SELECT * FROM Users;
  
- ALTER TABLE table ADD COLUMN column type options;
  - **Description**: Insert column into table
  - **Example**: ALTER TABLE Students ADD COLUMN Hometown varchar(20);
  
- UPDATE table SET column1=value1, column2=value2, ... columnk=valuek [WHERE condition(s)];
  - **Description**: Update data in a table
  - **Example**: UPDATE Students SET LastName='Jones' WHERE StudentID=987654321;

The above commands are the only ones you need, but if you are interested in learning more, see this [SQL cheat-sheet](http://cse.unl.edu/~sscott/ShowFiles/SQL/CheatSheet/SQLCheatSheet.html) for a list of common SQL commands.

You'll want to generate a salt for each new user that is created which means you'll need to alter your `create_user()` function appropriately. You'll also need to generate a new salt for each user who changes their password, so you'll probably want to alter `update_user()` appropriately as well.

Also note that once you've added a `salt` column to your Users table, you'll need to go through each pre-existing user one by one and generate a salt for each; and then you'll want to use each user's salt to hash their plain-text password. Once you've hashed a pre-existing user's password, overwrite the plain-text version with the new, hashed version. There are many ways of updating a database, but since there are so few users, the easiest and most straightforward way to do it will be by hand, cell by cell, from the `sqlite` top-level. It's quite common to have to migrate a database in this fashion (see [this article](https://en.wikipedia.org/wiki/Schema_migration) if you're interested).

Academic Integrity
------------------
Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.
