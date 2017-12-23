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

<hr />

## Alfred Usage ##

All of the Alfred launcher commands can be executed from the Alfred prompt. Toggle Alfred, or use your custom shortcode to show Alfred, and enter the commands below to execute the associated bash script.

**Toggle Alfred**<br />
<img src="/assets/img/docs/usage/toggle-alfred.png" title="Toggle Alfred Example" width="200" />

**Alred Launcher**
[![Toggle Alfred Example](/assets/img/docs/usage/create-site-demo-alfred-launcher.png)](/assets/img/docs/usage/create-site-demo-alfred-launcher.png)

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
