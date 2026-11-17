# Glide Ridge

**Shell** · **v0.1.0**

_Disk usage report: largest files, directory breakdown, duplicate detection_

---

## Features

- Top-N largest files and top-level directory size breakdown
- Finds duplicate files by MD5 content hash
- Summary with total file count and total size

## Installation

```bash
git clone https://github.com/DevCode01/glide-ridge.git
cd glide-ridge
```

## Usage

```bash
bash glide-ridge.sh /path/to/dir
```

## How it works

Uses `find -printf` to rank the largest files, `du -sh` for a top-level directory breakdown, and `md5sum` over every file to group duplicates by identical content hash (independent of filename), printing each duplicate group and a final summary.

## Options

- `<dir>` - directory to scan (default `.`)
- `<top_n>` - how many largest files/dirs to list (default 10)

## Example

```bash
$ bash glide-ridge.sh /path/to/dir 5
=== Disk Report: /path/to/dir ===

--- Top 5 largest files ---
      50.0 KB  /path/to/dir/sub2/big.bin
       0.0 KB  /path/to/dir/sub1/dup.txt
       0.0 KB  /path/to/dir/a.txt

--- Directory size breakdown (top-level) ---
52K	/path/to/dir/sub2/
4.0K	/path/to/dir/sub1/

--- Duplicate files (by content hash) ---
Hash 9e08097211313f1728e5c0551442f244:
  /path/to/dir/a.txt
  /path/to/dir/sub1/dup.txt

Found 1 duplicate group(s).

--- Summary ---
Total files: 3
Total size:  60K
```

## Testing

```bash
bash tests/run.sh
```

Includes a functional check against real captured output, plus the build/syntax check.

## License

MIT
