# Makefile

.PHONY: help deps run logs post build

default: help

help:
	@echo "Usage: make [TARGET]"
	@echo
	@echo "Available targets:"
	@echo "  deps   - Initialize and update Git submodules"
	@echo "  run    - Start Hugo server with drafts enabled"
	@echo "  logs   - Tail the server.log file"
	@echo "  post   - Create a new blog post (requires POST variable, e.g. make post POST=my-post)"
	@echo "  build  - Build the static site with Hugo"

deps:
	@git submodule update --init --recursive

run:
	@hugo server -D

logs:
	@tail -f server.log

post:
	@hugo new blog/${POST}.md

build:
	@hugo build
