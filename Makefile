.PHONY: init clean

init:
	git config --local core.hooksPath ".githooks"

clean:
	rm packer-manifest.json
