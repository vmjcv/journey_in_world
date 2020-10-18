::打包脚本
cd ..
cd game
"../godot/godot.exe" --export "HTML5"  ../export/html/SunSet.html
"../godot/godot.exe" --export "Windows Desktop" ../export/windows/SunSet.exe
"../godot/godot.exe" --export "Android" ../export/android/SunSet.apk
