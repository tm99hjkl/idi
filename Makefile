INSTALL_DIR := /usr/bin

all:
	@echo 'Please run `make isntall`.'

install:
	@install -m 0755 -v idi.sh "$(INSTALL_DIR)/idi"

uninstall:
	@rm -vrf "$(INSTALL_DIR)/idi"
