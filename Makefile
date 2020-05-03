BREW_TAPS=git-chglog/git-chglog
BREW_DEPS=pre-commit semtag git-chglog

.PHONY: setup changelog changelog-major changelog-minor changelog-patch release-major release-minor release-patch
.SILENT: setup changelog changelog-major changelog-minor changelog-patch release-major release-minor release-patch

# Install the global dependencies for the repo
setup:
	for tap in ${BREW_TAPS}; do if !(brew tap | grep "$$tap" >/dev/null); then brew tap $$tap; fi done
	for dep in ${BREW_DEPS}; do if !(brew list $$dep >/dev/null); then brew install $$dep; fi done
	pre-commit install
	pre-commit install --hook-type commit-msg
	npm install

# Generate the changelog for the upcoming release
changelog:
	git-chglog -o CHANGELOG.md

changelog-major:
	git-chglog -o CHANGELOG.md --next-tag `semtag final -s major -o`

changelog-minor:
	git-chglog -o CHANGELOG.md --next-tag `semtag final -s minor -o`

changelog-patch:
	git-chglog -o CHANGELOG.md --next-tag `semtag final -s patch -o`

release-major:
	semtag final -s major

release-minor:
	semtag final -s minor

release-patch:
	semtag final -s patch
