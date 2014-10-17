all:
	./bin/compile.sh

release:
	./scripts/build.sh

clean:
	rm -r dist*
