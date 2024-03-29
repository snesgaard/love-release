title=unnamed

linux_binary=build/$(title)_linux.zip
windows_zip=build/$(title)_win64.zip
windows_binary=build/$(title)_win64.exe

love_linux_app=build/love-11.3-x86_64.AppImage
love_win64_zip=build/love-11.3-win64.zip
love_win64=build/love-11.3-win64

love_file=$(abspath build/game.zip)

src_dir=src

all: $(love_file) download $(linux_binary) $(windows_binary) $(windows_zip)

debug:
	echo $(love_file)

love: $(love_file)

download: $(love_linux_app) $(love_win64_zip)

clean:
	rm -rf build
	make -C $(src_dir)/art clean

play:
	make -C $(src_dir) play

release:
	rm -f $(title).love
	rm -rf $(title)
	rm -f $(title).zip

	cp -r release_scripts $(title)
	mv $(title).love $(title)
	zip -9 -r $(title).zip $(title)

$(linux_binary): $(love_file) $(love_linux_app)
	@mkdir -p build/linux/$(title)
	cp $(love_file) build/linux/$(title)
	cp release_scripts/* build/linux/$(title)
	cp $(love_linux_app) build/linux/$(title)
	cd build/linux/; zip -9 -r tmp.zip $(title)
	mv build/linux/tmp.zip $@

$(love_linux_app):
	@mkdir -p $(dir $@)
	wget https://github.com/love2d/love/releases/download/11.3/love-11.3-x86_64.AppImage -O $@
	chmod +x $@

$(windows_binary): $(love_win64) $(love_file)
	cat $</love.exe $(love_file) > $@

$(windows_zip): $(love_win64) $(windows_binary)
	mkdir -p build/win64
	cp -r $(love_win64) build/win64/$(title)
	cp $(windows_binary) build/win64/$(title)
	rm build/win64/$(title)/love.exe build/win64/$(title)/lovec.exe
	cd build/win64/; zip -9 -r tmp.zip $(title)
	mv build/win64/tmp.zip $@

$(love_win64_zip):
	@mkdir -p $(dir $@)
	wget https://github.com/love2d/love/releases/download/11.3/love-11.3-win64.zip -O $@

$(love_win64): $(love_win64_zip)
	cd build; unzip love-11.3-win64.zip

$(love_file):
	@mkdir -p $(dir $@)
	make -C $(src_dir)/art
	cd $(src_dir); zip -9 -r $@ .
