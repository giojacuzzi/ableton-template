#! /bin/zsh -f
cd $0:h/..

git lfs install

# Install pre-commit hook
cp git/pre-commit .git/hooks && chmod +x .git/hooks/pre-commit

# Configure .als files in working tree to uncompress as xml on checkout (see .gitattributes)
gzip='zcat -f'
git config filter.gzip.smudge $gzip
git config filter.gzip.clean $gzip
git config filter.gzip.required true
git config diff.gzip.command $gzip

exit
