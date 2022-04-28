# mailinabox-scripts
Useful scripts for [Mail in a box](https://mailinabox.email)

# [Private Alias](private_alias.sh)
This script makes use of the  Mail in a Box API to dynamically add
private aliases for users. For instance, assume your company is Example Org, and your users have
email addresses "john.doe@example.org". If your company uses the services of different companies,
say, "Acme Corp", "Sloth Inc", etc., this script helps you generate aliases for your users so they
can sign up on acme.corp with an email address "john.doe.acme.corp.<hash>@relay.example.org", and
with "john.doe.sloth.inc.<hash>@relay.example.org" instead of giving away "john.doe@example.org".

## Why
- This helps fight the companies that sell/share email addresses
- This protects your users from credential re-use attacks as each service uses a separate email
- The random hash prevents fake emails to john.doe.fakedomain@example.org
- The hash is random per user, per company, so email guessing is not possible

### Company Alias
The company alias can be forwarded to a catch-all address for all third party service providers. You can
maintain one mailbox for all emails from your service providers:
- acme.corp.<hash1>@relay.example.org -> emails-from-companies@example.org
- sloth.corp.<hash2>@relay.example.org -> emails-from-companies@example.org

### User Alias
The user alias simply appends the user's name to the email address; while this is not essential, it
allows one to instantly identify who this alias belongs to. The hash is different per user, per company
so multiple users don't have the same hash.
- john.doe.acme.corp.<hash3>@relay.example.org -> john.doe@example.org
- john.doe.sloth.corp.<hash4>@relay.example.org -> john.doe@example.org
- steve.doe.acme.corp.<hash5>@relay.example.org -> steve.doe@example.org
- steve.doe.sloth.corp.<hash6>@relay.example.org -> steve.doe@example.org

### Shorter email addresses
To use shorter email addresses, remove the usernames prepended to the email address.
The hashes are unique by themselves so no more action is needed.
