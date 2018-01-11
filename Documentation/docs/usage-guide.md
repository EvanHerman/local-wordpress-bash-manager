# Using the Manager

## Command Line Usage ##

If you have not done so, please read through the [Installation](#Installation) section for install instructions.

### Install Site ###
```bash
$ install-wp.sh example-site
```

### Update Site(s) ###
**Update All Sites:**
The following command will loop through all WordPress installs inside of your localhost directory and update WordPress core, all plugins and all themes. Once the above command is entered you will be asked if you would like to update all sites. Type `y` to continue, or `n` to cancel.
```bash
$ update-wp.sh example-site
```

**Update Single Site:**
```bash
$ update-wp.sh example-site
```

**Update Multiple Sites:**
```bash
$ update-wp.sh example-site,example-site-2,example-site-3
```

### Delete Site ###
```
wp delete example-site
```

### Clone Site ###
The `clone-wp.sh` script accepts two parameters. First, the site you want to clone. Second, the name of the new site where the existing site will be cloned to.
```bash
$ clone-wp.sh example-site example-site-clone
```

### Pull a Remote Site Down into a Local Site ###

> Remote -> Local

Pulling down a remote site into a local instance running on your machine is simple but requires that a `deploy-config.json` be present in the site root on your local machine. Running `pull-wp.sh example-site` for the first time will ask you to create the `deploy-config.json` file and will prompt you for the required fields. The `deploy-config.json` file is created in the site root of your local site.
```bash
$ pull-wp.sh example-site
```

### Deploy a Local Site up to a Remote Server ###

> Local -> Remote

You also have the ability to deploy a local site up to a remote server. This makes developing sites locally and deploying them when you're ready as easy as pie. The deploy command also requires that the `deploy-config.json` be present in the site root of the site you want to deploy. Once setup, you can deploy your site to one of your environments by running `deploy-wp.sh example-site`. *Note:* It is possible to have multiple environments setup in  deploy-config.json file (eg. staging & production). This means you can deploy to a staging site for testing *before* deploying up to your production environment.
```bash
$ deploy-wp.sh example-site
```

<hr />

## Alfred Usage ##

All of the Alfred launcher commands can be executed from the Alfred prompt, with the exception of `deploy-wp.sh` and `pull-wp.sh`. Toggle Alfred, or use your custom shortcode to show Alfred, and enter the commands below to execute the associated bash script.

**Toggle Alfred**
[![Toggle Alfred Example](/assets/img/docs/usage/toggle-alfred.png)](/assets/img/docs/usage/toggle-alfred.png)

**Alred Launcher**
[![Create Site Alfred Example](/assets/img/docs/usage/create-site-demo-alfred-launcher.png)](/assets/img/docs/usage/create-site-demo-alfred-launcher.png)

### Install Site ###
```
wp create test-site
```

### Update Site(s) ###
**Update All Sites:**
```
wp update
```

**Update Single Site:**
```
wp update test-site
```

**Update Multiple Sites:**
```
wp update test-site,test-site-2,test-site-3
```

### Delete Site ###
```
wp delete test-site
```

### Clone Site ###
Step 1:
```
wp clone test-site
```

Step 2:
In step 2, simply enter the new site clone name.
```
test-site-clone
```

### Pull & Deploy ###

The pull & deploy commands must be executed from the command line. Please see the command line usage above for "Pull a Remote Site Down into a Local Site" and "Deploy a Local Site up to a Remote Server".
