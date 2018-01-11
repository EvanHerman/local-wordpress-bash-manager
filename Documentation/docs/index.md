# Local WordPress <small>Bash Manager</small> #

## Dead Simple Local WordPress Management ##

Using the tools bundled in this repository, you can easily manage local WordPress installs - including installing, deleting, cloning and updating local WordPress instances. The following tools are a set of bash scripts that allow for easy management of your local sites through the command line, or using [Alfred](https://www.alfredapp.com/).

These scripts can be launched from the command line or using [Alfred](https://www.alfredapp.com/) *<small>(with the [powerpack](https://www.alfredapp.com/powerpack/) addon)</small>*.

## Included Scripts ##

* Create New WordPress Sites (`install-wp.sh`)
* Delete Existing WordPress Sites (`uninstall-wp.sh`)
* Clone Existing Local WordPress Sites to a new Local Sites (`clone-wp.sh`)
* Deploy a Local WordPress Sites to a Remote Server (`deploy-wp.sh`)
* Pull Down a Remote WordPress Site to a Local Site (`pull-wp.sh`)
* Update Local Site(s) Core, Plugins & Themes (`update-wp.sh`)

## Requirements ##

* Localhost install ([Laravel Valet](https://laravel.com/docs/master/valet#installation), [MAMP](https://www.mamp.info/en/), [XAMPP](https://www.apachefriends.org/index.html) etc.)
* [WP-CLI](http://wp-cli.org/)
* [Alfred (with Powerpack)](https://www.alfredapp.com/) *(Optional)*

## Quick start ##

1) Clone the local-wordpress-bash-manager repository onto your machine.
```bash
$ git clone https://github.com/EvanHerman/local-wordpress-bash-manager.git
```

2) Copy the `automated-local-wordpress-instal/Scripts` directory into `/Users/$USER/`.
```bash
$ cd local-wordpress-bash-manager
$ cp -R Scripts ~/
```

3) Add the `Scripts` directory to your `PATH` by adding the following to your `.bash_profile`.
```bash
export PATH="/Users/$USER/Scripts:$PATH"
```

4) Update the values inside of `wp-config.sh` with the values for your localhost install.

5) **Optional** Install the Alfred workflow script included in the `/Launchers` directory. Double click `Alfred -  Valet WordPress Commands` to install.
