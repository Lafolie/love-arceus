$core = "E:\PTU\Latest Files\Dexes\Pokedex_Playtest105Plus.pdf"
$galar = "E:\PTU\Latest Files\Dexes\GalarDex.pdf"
$alola = "E:\PTU\Latest Files\Dexes\Ultra AlolaDex 1.05.pdf"

$app = "E:\ChromeDownloads\xpdf-tools-win-4.02\xpdf-tools-win-4.02\bin64\pdftotext.exe"

# Start-Process -FilePath $app -ArgumentList "-f 12 -l 12 -raw $core `"E:\Python\love-arceus\rips\core.txt`""

# .$app -f 12 -l 747 -raw $core "E:\Python\love-arceus\rips\core.txt"

# .$app -f 4 -l 117 -raw $alola "E:\Python\love-arceus\rips\alola.txt"

# .$app -f 3 -l 103 -raw $galar "E:\Python\love-arceus\rips\galar.txt"

.$app -f 417 -l 418 -raw $core "E:\Python\love-arceus\rips\darumaka.txt"