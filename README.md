# ableton-template
A git repository template for managing Ableton Live projects

## Prerequisites
- [zcat](https://linux.die.net/man/1/zcat) for managing Ableton Live Set files
    - This should come pre-installed on MacOS
- [git lfs](https://git-lfs.com/) for storing audio/binary files
    - `brew install git-lfs`
- [xmlstarlet](https://xmlstar.sourceforge.net/download.php) for generating version and plugin `dependencies.md` (optional)
    - `brew install xmlstarlet`

## Setup
- Run `git/setup.command` before using this repository for an Ableton Live project
- Create/copy your Ableton Live project folder into this directory

## Committing
- Always use [Collect All and Save](https://help.ableton.com/hc/en-us/articles/209775645-Collect-All-and-Save)

---

## Notes

An Ableton Live Set `.als` file is actually xml compressed with gzip. Ableton Live can open an uncompressed als file, and will just compress it again on save. We can use gitattributes filters and a hook to uncompress on checkout and pre-commit, ensuring that only the (non-binary) xml is committed. This makes diffs and conflict merging (i.e. concurrent production) possible. However, because an als file stores some plugin data in binary, note that merging is limited (if multiple musicians change a plugin, one will ultimately lose their work).

Running `git/setup.command` will initialize git lfs, configure .als files in the working tree to uncompress as xml on checkout, and install the pre-commit hook. In addition to uncompressing as xml before commit, this hook will attempt to automatically generate `dependencies.md` with `git/dependencies.command`. This parses the xml to retrieve the required Ableton Live version and any third-party plugins used in the Live Set.

_Inspired by [Mark Henry's experiment](https://medium.com/@mark_henry/ableton-live-git-a-match-made-in-someplace-or-the-great-ableton-git-experiment-5a20dfe2734c) and [danielbayley's Ableton Live Tools](https://github.com/danielbayley/Ableton-Live-tools)_
