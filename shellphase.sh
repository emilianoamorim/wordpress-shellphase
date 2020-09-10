#!/bin/sh

# Author: Emiliano Amorim
# Repository: https://github.com/emilianoamorim/wordpress-shellphase

STORE_DIR="./shellphase"

help()
{
  echo "\n"
  echo " shellphase <path of wordpress> - Create a new release"
  echo " --status   <path of wordpress> - Compare files on release"
  echo " --help     - Here!"
  echo " --clean    - Remove existent release"
  echo "\n"
  exit 0
}

check_wp_version()
{
  FILE="${1}/wp-includes/version.php"
  if test -f "$FILE"; then
      echo "=================================="
      echo "WP Version:"
      cat "${FILE}" | egrep "wp_version" | tail -1 | awk -F\' '{ print $2 }'
      echo "=================================="
  fi
}

clean()
{
  if test -d "$STORE_DIR"; then
    \rm -r $STORE_DIR
    echo "Release successfully removed"
    exit 0
  else
    echo "Release not found"
  fi
}

create_release()
{
  echo "wait..."
  mkdir "${STORE_DIR}" && touch "${STORE_DIR}/release" && touch "${STORE_DIR}/mutations"
  find $1 ! -name '*.jpg' ! -name '*.jpeg' ! -name '*.png' ! -name '*.gif' | sed 's:""$DIR""::' |
  while read -r line
  do
    if test -f "$line"; then
      MD5_SUM=$(md5sum ${line})
      append_release $line $MD5_SUM
    fi
  done
  echo "Release updated!"
}

exists_release()
{
  if test -f "$STORE_DIR/release"; then
    echo "The release already exists. Do you want to update with a new one?"
    read dropRelease
    if [ $dropRelease = 'y' -o $dropRelease = 'Y' ]; then
      clean
      echo "Continue..."
      create_release
      md5sum_listing $1
    elif [ $dropRelease = 'n' -o $dropRelease = 'N' ]; then
      echo "Operation aborted by the user"
      exit 0
    fi
  else
    create_release $1
  fi
}

status()
{
  if ! test -f "${STORE_DIR}/release"; then
    echo "Release not found"
    exit 0
  fi
  if ! test -d $1; then
    echo "Incorrect path"
    exit 0
  else
    find $1 ! -name '*.jpg' ! -name '*.jpeg' ! -name '*.png' ! -name '*.gif' | sed 's:""$DIR""::' |
    while read -r line
    do
      if test -f "$line"; then
        MD5_SUM=$(md5sum ${line} | awk '{ print $1 }')
        RELEASE_MD5SUM=$(cat "${STORE_DIR}/release" | egrep $line | tail -1 | awk -F\' '{ print $2 }')
        if [ $MD5_SUM != $RELEASE_MD5SUM ]; then
          append_mutations $line
        fi
      fi
    done
  fi
}

append_release()
{
  echo "${1} = '${2}'" >> "${STORE_DIR}/release"
}

append_mutations()
{
  echo "Mutation found: ${1}"
  echo "${1}" >> "${STORE_DIR}/mutations"
}

if [ $# -eq 0 ]
then
  echo "\n Enter a valid argument.."
  help
else
  if [ $1 = "--status" ]; then
    status $2
  elif [ $1 = "--help" ]; then
    help
  elif [ $1 = "--clean" ]; then
    clean
  else
    if ! test -d $1; then
      echo "Incorrect path"
      exit 0
    else
      check_wp_version $1
      exists_release $1
    fi
  fi
fi