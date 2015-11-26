mongodb-backup ![project-status](http://stillmaintained.com/paps/mongodb-backup.png)
====================================================================================

Shell script for putting `mongodump` into your crontab.

Useful for small backup scenarios where you only have one MongoDB server.

Installation
------------

You need to have at least `mongodump` installed (`mongodb-clients` Debian package).

It is recommended to add a separate user for backuping purposes, with minimal read access (either the `backup` role (2.4+) or `readAnyDatabase`, `userAdminAnyDatabase` and `clusterAdmin` (2.4 or previous)).

    git clone https://github.com/paps/mongodb-backup.git
    cd mongodb-backup
    cp config.sh.sample config.sh
    vim config.sh

Usage
-----

`./backup-launcher.sh /absolute/path/to/backup/dir`

Crontab
-------

Example for 2 backups per day:

# m h  dom mon dow   command
 00 13 *   *   *     /home/user/mongodb-backup/backup-launcher.sh /home/user/mongodb-backup > /dev/null 2>&1
 00 21 *   *   *     /home/user/mongodb-backup/backup-launcher.sh /home/user/mongodb-backup > /dev/null 2>&1

Links
-----

`mongodump` documentation: https://docs.mongodb.org/manual/reference/program/mongodump/
MongoDB backup documentation: https://docs.mongodb.org/manual/core/backups/
