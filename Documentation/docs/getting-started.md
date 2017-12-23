# Getting Started

## Installation

1) Clone the local-wordpress-bash-manager repository
```bash
$ git clone https://github.com/EvanHerman/local-wordpress-bash-manager.git
```

2) Copy the `automated-local-wordpress-instal/Scripts` directory into `/Users/$USER/`
```bash
$ cd local-wordpress-bash-manager
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
* **SITE_PATH** - The root directory of your WordPress installs.

> For valet, this is the parked directory that your sites are served from. You can check parked directory paths by running the command `$ valet paths`.

#### Database Configuration ####
* **DB_USER** - The database username. *eg: root*
* **DB_PASS** - The database user password. *eg: password*
* **DB_HOST** - The database host. *eg: localhost*

#### Site Data ####
* **ADMIN_USERNAME** - WordPress username
* **ADMIN_PASSWORD** - WordPress user password
* **ADMIN_EMAIL** - WordPress user email address.
* **TLD** - Top level domain. How is the site accessed? *eg: .com, .org, .local, .dev*

5) **Optional** Install the Alfred workflow script included in the `/Launchers` directory. Double click `Alfred -  Valet WordPress Commands` to install.

## Usage

See our <a href="/usage/">Usage Guide</a> for a list of available commands, explanations for each command and demo usage.
