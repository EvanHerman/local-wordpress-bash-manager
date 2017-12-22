# Automated Localhost Installs #

### Requirements
* Localhost install ( [Laravel Valet](https://laravel.com/docs/master/valet#installation), [MAMP](https://www.mamp.info/en/), [XAMPP](https://www.apachefriends.org/index.html) etc.)
* [WP-CLI](http://wp-cli.org/)
* [Alfred (with Powerpack)](https://www.alfredapp.com/) *(Optional)*

### Installation

1) Clone the automated-local-WordPress-install repository
```bash
$ git clone https://github.com/EvanHerman/automated-local-wordpress-install.git
```

2) Copy the `automated-local-wordpress-instal/Scripts` directory into `/Users/$USER/`
```bash
$ cd automated-local-wordpress-install
$ cp -R Scripts ~/
```

3) Add the `Scripts` directory to your `PATH` by adding the following to your `.bash_profile`.
```bash
export PATH="/Users/$USER/Scripts:$PATH"
```

You can confirm that the path was added properly and the script was found by running the following:
```bash
install-wp.sh
```

Since you have not specified a site/directory name, you should see the following output:

```bash
Error: You forgot to specify a site name. eg: site-name
```

4) Update the values inside of `wp-config.sh` with the values for your localhost install.

#### Path to Local Install Files ####
* SITE_PATH - The root directory of your WordPress installs.

> For valet, this is the parked directory that your sites are served from. You can check parked directory paths by running the command `$ valet paths`.

#### Database Configuration ####
* DB_USER - The database username. eg: root
* DB_PASS - The database user password. eg: password
* DB_HOST - The database host. eg: localhost

#### Site Data ####
* ADMIN_USERNAME - WordPress username
* ADMIN_PASSWORD - WordPress user password
* ADMIN_EMAIL - WordPress user email address.
* TLD - Top level domain. How is the site accessed? eg: .com, .org, .local, .dev

5) **Optional** Install the Alfred workflow script included in the `/Launchers` directory. Double click `Alfred -  Valet WordPress Commands` to install.

6) Test the scripts from the command line.

**Install Test Site:**
```bash
$ install-wp.sh test-site
```

**Clone Test Site:**
```bash
$ clone-wp.sh test-site test-site-clone
```

**Update all Sites:**
```bash
$ update-wp.sh
```

**Uninstall Test Site:**
```bash
$ uninstall-wp.sh test-site
$ uninstall-wp.sh test-site-clone
```

##### Alfred *(from the Alfred launcher)*: #####

**Install:**
```
wp create test-site
```

**Clone:**
Step 1:
```
wp clone test-site
```

Step 2:
In step 2, simply enter the new site clone name.
```
test-site-clone
```

**Update All Sites:**
The following command will loop through all WordPress installs inside of your localhost directory and update WordPress core, all plugins and all themes.
*Future Release:* In future this command will accept a parameter to update a single site on the network.
```
wp update
```

**Uninstall:**
```
wp delete test-site
```
