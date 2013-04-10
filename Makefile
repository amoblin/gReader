default:
	coffee -b -o gReader/js -c src

zip:
	rm -f gReader.zip
	cd gReader && zip -r ../gReader.zip *  && cd ..

crx:
	@../crxmake/bin/crxmake --pack-extension=gReader --extension-output=~/Downloads/gReader.crx --pack-extension-key=~/proj/amoblin/marboo-js.pem
