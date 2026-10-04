# Urjaas2

Technically, Urjaas 2 is a landing page builder and a blog post writing platform.

Fundamentally, it is an enabling platform for YouTubers, speakers, writers, podcasters, and reel creators to build their own piece of online home. 

## Features

**Version 1.0**
1.  WYSIWYG blog editor
2.  Drag and drop page builder

**Version 1.1**
1. Landing pages with image upload support.
2. More editing options in blog editor.
3. Landing page section templates.

## Production admin bootstrap and two-factor authentication

### Local development encryption setup

Active Record encrypts the administrator's authenticator secret. Generate a development key set with `bin/rails db:encryption:init`, then place the three generated values in the ignored `.env.development.local` file using the variable names below. Keep the same values for this development database; changing them makes previously encrypted values unreadable. Restart the development server after adding them.

```dotenv
ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=...generated value...
ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=...generated value...
ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=...generated value...
```

The `.env.development.local` file is excluded from Git. Never use development keys in production.

Configure these secrets in Hatchbox before deploying:

- `ADMIN_EMAIL`: the single allowed administrator email.
- `ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY`, `ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY`, and `ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT`: generate these once with `bin/rails db:encryption:init` and store the resulting values in Hatchbox secrets. Do not regenerate them after OTP secrets have been stored.
- `ADMIN_PASSWORD`: a unique password of at least 16 characters, needed only if the production users table is empty and the initial admin must be seeded. After that first successful seed, remove this variable from Hatchbox.

The Hatchbox post-build hook runs `db:seed` only when the users table is empty. The seed refuses to create another account if any user already exists, and it never changes an existing password. It does not print the password or OTP secret.

At first sign-in, the admin is redirected to the two-factor setup page. Add the displayed secret to an authenticator app and verify a current code. Admin/dashboard access remains blocked until verification enables TOTP. Keep the authenticator account backed up securely; there are no self-service backup codes or password-reset flows configured yet.

**Credential history warning:** credentials committed in the past must be treated as compromised even if later removed from the latest file. Change the admin password to a new, unique secret before enabling this release. If the repository was accessible to others, removing a credential from Git history may also be appropriate, but history rewriting does not replace rotating the credential.
