default:
	coffee -b -o gReader/js -c src/greader.coffee
	coffee -b -o gReader/js -c src/background.coffee
	coffee -b -o gReader/js -c src/content.coffee
zip:
	rm -f gReader.zip
	cd gReader && zip -r ../gReader.zip *  && cd ..
