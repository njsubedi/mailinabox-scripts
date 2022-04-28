#!/bin/bash

# Change these values

MAILBOX='mail.example.org'
DOMAIN='example.org'
RELAY_DOMAIN='relay.example.org'
COMPANY_CATCHALL="mailer@$DOMAIN"
SALT='uak5nbpx54pnp8wyg9tvj8wyg9tvj4ek7r'
ADMIN_USER="api-admin@$DOMAIN"

read -s -r -p "Enter password for $ADMIN_USER:" ADMIN_PASS

## Parameters
# $1: alias_address
# $2: forward_to
# $3: keyword to search existing aliases
function add_alias_impl() {
  echo "Fetching existing aliases for $3... "
  curl --user "$ADMIN_USER":"$ADMIN_PASS" -X GET -sL "https://$MAILBOX/admin/mail/aliases" | grep "$3"

  read -r -p "Confirm adding $1 -> $2? [Y/n]" CONFIRM

  if [[ $CONFIRM == "" || $CONFIRM == "Y" || $CONFIRM == "y" ]]; then
    curl --user "$ADMIN_USER":"$ADMIN_PASS" -X POST \
      -d "address=$1" \
      -d "forwards_to=$2" \
      "https://$MAILBOX/admin/mail/aliases/add"
  fi
}

## Parameters
# $1: company domain
function add_user_alias() {
  COMPANY=$1
  USER=""

  while [[ $USER != "done" && $USER != "DONE" ]]; do
    echo "Adding user aliases for $COMPANY"
    echo "Enter <user> to add alias <user>.$COMPANY.<random_hash>@$RELAY_DOMAIN"

    read -r -p "User: (without @$DOMAIN):" USER

    HASH=$(echo "$SALT-$COMPANY-$USER" | md5 | head -c 10)

    ALIAS="$USER.$COMPANY.$HASH"

    read -r -p "Forward $ALIAS@$RELAY_DOMAIN to $USER@$DOMAIN? [Y/n]" CONFIRM

    if [[ $CONFIRM == "" || $CONFIRM == "Y" || $CONFIRM == "y" ]]; then
      add_alias_impl "$ALIAS@$RELAY_DOMAIN" "$USER@$DOMAIN" "$USER.$COMPANY"
    fi
  done
}

## Parameters
# $1: company domain
function add_company_alias() {
  COMPANY=$1

  HASH=$(echo "$SALT-$COMPANY" | md5 | head -c 10)

  add_alias_impl "$COMPANY.$HASH@$RELAY_DOMAIN" "$COMPANY_CATCHALL" "$COMPANY"
}

############## START ###############

if [ $# -ne 1 ]; then
  while
      echo "To add new <example.com.random_hash@$RELAY_DOMAIN> alias enter example.com"

      read -r -p "Enter company domain (example.com): " CHOICE

      COMPANY=$(echo "$CHOICE" | tr -cd "[:alnum:]-.")

    [[ $COMPANY == "" ]]
    do echo "Please valid company domain (example.com): "; done
else
  COMPANY=$(echo "$1" | tr -cd "[:alnum:]-.")
fi

while
  echo "[1] Add $COMPANY.<random_hash>@$RELAY_DOMAIN"
  echo "[2] Add <user>.$COMPANY.<random_hash>@$RELAY_DOMAIN"
  echo "[3] Add both"

  read -r -p "What do you want to add? [1|2|3]: " CHOICE
  [[ $CHOICE != 1 && $CHOICE != 2 && $CHOICE != 3 ]]
do echo "Please enter a valid choice 1 | 2 | 3:"; done

if [[ $CHOICE == 1 || $CHOICE == 3 ]]; then
  add_company_alias "$COMPANY"
fi

if [[ $CHOICE == 2 || $CHOICE == 3 ]]; then
  add_user_alias "$COMPANY"
fi
