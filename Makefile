default: run


run:
	hugo server -D

logs:
	tail -f server.log

post:
	hugo new blog/${POST}.md
