tag = `git describe --tag`

default:
	coffee -b -o gReader/js -c src

zip:
	rm -f gReader.zip
	cd gReader && zip -r ../gReader.zip *  && cd ..

crx:
	@../crxmake/bin/crxmake --pack-extension=gReader --extension-output=~/Downloads/gReader_${tag}.crx --pack-extension-key=~/proj/amoblin/greader.pem

clean:
	find . -name .DS_Store|xargs rm -f

web:
	rm -rf ~/.marboo/source/WebSites/reader.marboo.biz/*
	cp -r gReader/* ~/.marboo/source/WebSites/reader.marboo.biz
