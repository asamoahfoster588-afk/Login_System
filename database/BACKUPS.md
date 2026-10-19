# Automated PostgreSQL backups

`backup-to-s3.php` creates a PostgreSQL custom-format dump using the database
settings in `config/database.php`, then uploads it with server-side AES-256
encryption to `s3://secure---login/database-backups/secure_login_db/`.
Temporary dump files are removed after the upload attempt.

## One-time setup

1. Revoke and replace any AWS access key that has been shared in chat, source
   control, or another untrusted location. Do not put AWS keys in this project.
2. Install AWS CLI and PostgreSQL client tools. Ensure `aws` and `pg_dump` are
   on the Windows user's `PATH`.
3. Configure an AWS CLI profile named `secure-login-backup` for the Windows
   account that will run the scheduled task:

   ```powershell
   aws configure --profile secure-login-backup
   ```

   Use credentials with only the permissions needed to upload objects under
   `database-backups/secure_login_db/` in the `secure---login` bucket. Configure
   the bucket's AWS region in this profile.
4. From PowerShell, install the daily 02:00 task:

   ```powershell
   Set-ExecutionPolicy -Scope Process Bypass
   & 'C:\xampp\htdocs\secure_login\database\install-backup-task.ps1'
   ```

   The task runs as the current Windows account only while that account is
   logged on. To choose another time, pass `-DailyAt 'HH:mm'`; to use a
   non-default PHP path, pass `-PhpPath`.

## Manual run and troubleshooting

Run a backup immediately with:

```powershell
& 'C:\xampp\php\php.exe' 'C:\xampp\htdocs\secure_login\database\backup-to-s3.php'
```

The script reports failures to standard error and exits with a nonzero status.
The Task Scheduler history and Last Run Result can be used to diagnose
scheduled runs. `AWS_PROFILE`, `AWS_CLI`, and `PG_DUMP` may be set in the
scheduled user's environment when custom profile names or executable paths
are needed.
