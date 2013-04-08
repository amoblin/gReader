default:
	coffee -b -o gReader/js -c gReader/src/greader.coffee
	coffee -b -o gReader/js -c gReader/src/background.coffee
	coffee -b -o gReader/js -c gReader/src/content.coffee
zip:
	rm -f gReader.zip
	cd gReader && zip -r ../gReader.zip *  && cd ..
