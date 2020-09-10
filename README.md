# Wordpress Shellphase
A shell script for diagnosing wordpress applications

Compare the md5sum of your Wordpress files and save it to a release.

# Why is this useful?

Daily WordPress apps receive hacker attacks to distribute malware, spam and also fake bank pages. You can monitor changes in the scripts through a shell script and save the results to storage for comparison in the future.

**Important:** This script does not guarantee the security of your application. Keep the version always up to date and apply security rules recommended for Wordpress.

### How to use this?

1 - Download this script\
2 - Grant permission: chmod +x ./shellphase.sh\
3 - Create a new release: ./shellphase.sh /var/www/wordpress-app\
4 - Check this release on path ./shellphase/release

### Check exists mutations
./shellphase.sh --status /var/www/wordpress-app

### Clean release
./shellphase.sh --clean

### Help!
./shellphase.sh --help
