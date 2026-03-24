# docker-dir-to-B2

Docker container that performs daily backups from a local directory to b2

# How to Use

Basic usage is as follows:

```
docker run \
  -e "BB_BUCKET=my-container" \
  -e "B2_APPLICATION_KEY_ID=MYACCESSKEYID" \
  -e "B2_APPLICATION_KEY=3jk2kj3lkll+EXAMPLE/k213jl12k3kj213lkj213ll" \
  -e "B2_BACKUP_NAME"=my-file-name
  -v /my_local_dir/:/upload/:ro
  image: ghcr.io/legionofone/docker-dir-to-b2:Master
```

This will start cron in the background which will run an upload script daily.
Any volumes that you mount to the container's `/upload/` directory will be 
compressed into a tar archive using bzip compression. The resulting file is
uploaded to b2 with filename `<timestamp>.tar.gz`.

You can mount a single volume from another container or from your filesystem 
to the root of the `/upload/` directory, or you can also backup multiple volumes
by mounting them as subdirectories on `/upload/dir1/`, `/upload/dir2/`, and so 
on.

You can control the directory inside the container that holds the temporary tar
file by setting the `TMPDIR` environment variable. This might be useful if your
backup will be very large and needs to be stored on a network volume.

# Security Best Practices

You should create a separate user in your BB IAM console to perform the 
backups. This user does not need a password, so they should only have the 
'Programmatic access' Access Type. BB will provide a `B2_APPLICATION_KEY_ID` and
`B2_APPLICATION_KEY` for that user. Assign the Managed Policy that you 
created to this user, and provide no other permissions to it.

In the event that your container or host system is compromised, an attacker will
have a key which can only write output to the container and cannot read the 
backups or perform any other operations on your BB account. They could 
potentially use this to overwrite files, so make sure you enable versioning on
the bucket as well.

It's also good practice to only mount your volumes as read-only (`:ro`), since
this container does not need to write to any volumes.
