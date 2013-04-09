default:
	coffee -b -o gReader/js -c src

zip:
	rm -f gReader.zip
	cd gReader && zip -r ../gReader.zip *  && cd ..
