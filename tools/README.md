# tools

### Usage

- `sync_from_afl.sh`: copy test case generated by afl.
    - `./sync_files.sh server_name@server_ip server_path local_path`
    - `local_path` : `path/to/samples/fuzzers_sync`

- `sync_to_afl.sh`: copy samples to afl queue
    - `./sync_to_afl.sh <local_directory> <remote_user@remote_host:remote_directory>`

### AFL Patch :

> if you use `sync_to_afl.sh`, please use this patch to afl.

For speed up synchronizing.

```diff
// afl-fuzz.c
// speed up sync!

+ srand(time(NULL));
- if (!stop_soon && sync_id && !skipped_fuzz) {
+ if (!stop_soon && sync_id && (!skipped_fuzz || rand() % 5 == 0)) {
  if (!(sync_interval_cnt++ % SYNC_INTERVAL))
	sync_fuzzers(use_argv);
}
```