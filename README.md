# ableton-template
A git repository template for managing Ableton Live projects

### Prerequisites
- [zcat](https://linux.die.net/man/1/zcat) for managing Ableton Live Set files
    - This should come pre-installed on MacOS
- [git lfs](https://git-lfs.com/) for storing audio/binary files
    - `brew install git-lfs`
- [xmlstarlet](https://xmlstar.sourceforge.net/download.php) for generating version and plugin `dependencies.md` (optional)
    - `brew install xmlstarlet`

### Setup
- Run `git/setup.command` before using this repository for an Ableton Live project
- Create/copy your Ableton Live project folder into this directory

### Committing
- Always use [Collect All and Save](https://help.ableton.com/hc/en-us/articles/209775645-Collect-All-and-Save)

---

## Notes

### Ableton Live Sets
An Ableton Live Set `.als` file is actually xml compressed with gzip. Ableton Live can open an uncompressed als file, and will just compress it again on save. We can use gitattributes filters and a hook to uncompress on checkout and pre-commit, ensuring that only the (non-binary) xml is committed. This makes diffs and conflict merging (i.e. concurrent production) possible. However, because an als file stores some plugin data in binary, note that merging is limited (if multiple musicians change a plugin, one will ultimately lose their work). Running `git/setup.command` will initialize git lfs, configure .als files in the working tree to uncompress as xml on checkout, and install the pre-commit hook.\*

_\* Inspired by [Mark Henry's experiment](https://medium.com/@mark_henry/ableton-live-git-a-match-made-in-someplace-or-the-great-ableton-git-experiment-5a20dfe2734c) and [danielbayley's Ableton Live Tools](https://github.com/danielbayley/Ableton-Live-tools)_

### Ableton version and plugin dependencies
In addition to uncompressing as xml before commit, the pre-commit hook will attempt to automatically generate `dependencies.md` with `git/dependencies.command`. This parses the xml to retrieve the required Ableton Live version and any third-party plugins used in the Live Set.

### Repo and file size limits
There are hard limits for file and repository sizes on GitHub. As of 2023, GitHub suggests that repositories remain less than 1 GB, and strongly recommends less than 5 GB.

Individual files larger than 100 MB are blocked by GitHub (for reference, that's a little over 1.5 hours of stereo audio at 44.1kHz, 16-bit). We use [git lfs](https://git-lfs.com/) ("Git Large File Storage") to track files beyond this limit by storing pointer references to audio files in the repo, but not the actual files themselves. Personal GitHub accounts can store individual files up to 2 GB with git lfs ([see details](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-git-large-file-storage)).

Every account using git lfs receives 1 GB of free storage and 1 GB a month of free bandwidth, both of which can be expanded. When you commit and push a change to an audio file tracked with git lfs, a new version of the entire file is pushed and the total file size is counted against your storage limit. When you download a file tracked with git lfs, the total file size is counted against your bandwidth limit.  Uploads do not count against the bandwidth limit. [See details here](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-storage-and-bandwidth-usage).