all:
	./bin/compile.sh

release:
	./bin/dist.sh

clean:
	rm -r dist*
