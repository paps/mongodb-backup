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
    chmod og-rwx config.sh
    vim config.sh

Do not forget to remove read rights on `config.sh` because this file contains passwords.

MongoDB must have an oplog (`master = true` in `/etc/mongodb.conf`).

Usage
-----

`./backup-launcher.sh /absolute/path/to/git/repo`

Crontab
-------

Example for 2 backups per day:

    # m h  dom mon dow   command
     10 13 *   *   *     /home/user/mongodb-backup/backup-launcher.sh /home/user/mongodb-backup > /dev/null 2>&1
     10 21 *   *   *     /home/user/mongodb-backup/backup-launcher.sh /home/user/mongodb-backup > /dev/null 2>&1

Links
-----

`mongodump` documentation: https://docs.mongodb.org/manual/reference/program/mongodump/

MongoDB backup documentation: https://docs.mongodb.org/manual/core/backups/
