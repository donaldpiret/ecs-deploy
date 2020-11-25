BREW_DEPS=pre-commit

.PHONY: setup
.SILENT: setup

# Install the global dependencies for the repo
setup:
	for dep in ${BREW_DEPS}; do if !(brew list $$dep >/dev/null); then brew install $$dep; fi done
	pre-commit install
	pre-commit install --hook-type commit-msg
	yarn install