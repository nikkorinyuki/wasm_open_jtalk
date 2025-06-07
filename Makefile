install-emsdk:
	./scripts/install-emsdk.sh

install-open_jtalk:
	./scripts/install-open_jtalk.sh

clean-emsdk:
	rm -rf tools/emsdk/

clean-open_jtalk:
	rm -rf tools/open_jtalk/src/build	

clean:
	make clean-emsdk
	make clean-open_jtalk
