# PHP Version Manager

Quick and Simple bash script allowing to switch easily between installed PHP versions.

Designed for Linux Dieban's based distributions working with apt, php and Apache2

1. Lists currently Installed PHP versions

2. Create & change symbolic links for PHP Cli

3. Uses a2enmod && a2dismod for Apache2

# Usage :

```bash
./pvm.sh
```

# What's next ? :

When i'll have some spare time i plan on adding some extra features like :

1. Allowing install && removal of PHP Versions directly via pvm using apt && ondrej repository

2. Allowing install && removal of PHP-libraries directly for the current version through the pvm

3. Create an auto-setup for pvm in order to access it directly as a system command

4. Rewrite it using another language (not sure tho)

Feel free to contact me at <alexandre.choisy@arengi.fr>

Created by Alexandre Choisy, 2016