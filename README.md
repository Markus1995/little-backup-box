# Little Backup Box
A set of Bash scripts that transform a Raspberry Pi into a autonomous and automagical backup device for storage cards and cameras.

## Installation

1. `wget https://raw.githubusercontent.com/dmpop/little-backup-box/master/install-little-backup-box.sh`
2. `sudo chmod +x install-little-backup-box.sh`
3. `./install-little-backup-box.sh`
4. Run the `crontab -e` command and uncomment the desired cron job to enable it.
5. Edit user-defined settings in the enabled script.
6. Reboot the Raspberry Pi.

## Usage

1. Boot the Raspberry Pi.
2. Plug in the backup storage device first.
3. Plug in the card reader or camera and wait till the Raspberry Pi shuts down.

## Author

Dmitri Popov (dmpop@linux.com)

## License

The [GNU General Public License version 3](http://www.gnu.org/licenses/gpl-3.0.en.html)
