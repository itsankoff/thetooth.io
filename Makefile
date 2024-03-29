default: run

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
