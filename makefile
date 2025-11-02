.PHONY: up test nuke fmt

up:
	mkdir -p data backups diagrams
	@echo "Created workspace: data backups diagrams"

test:
	bash tests/validate_permissions.sh
	bash tests/validate_backup.sh

nuke:
	rm -rf data backups *.tar.gz
	@echo "Cleaned workspace"

fmt:
	@command -v shellcheck >/dev/null || pip install --user shellcheck || true
	@echo "Run shellcheck locally if installed"
