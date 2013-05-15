tag = `git describe --tag`

default:
	coffee -b -o gReader/js -c src

zip:
	rm -f gReader.zip
	cd gReader && zip -r ../gReader.zip *  && cd ..

crx:
	@~/proj/crxmake/bin/crxmake --pack-extension=gReader --extension-output=~/Downloads/gReader_${tag}.crx --pack-extension-key=~/proj/amoblin/greader.pem

clean:
	find . -name .DS_Store|xargs rm -f

web:
	rm -rf ~/Dropbox/marboo/WebSites/reader.marboo.biz/*
	cp -r gReader/* ~/Dropbox/marboo/WebSites/reader.marboo.biz
