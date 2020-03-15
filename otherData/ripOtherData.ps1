$core = "E:\PTU\Latest Files\Pokemon Tabletop United 1.05 Core.pdf"
$galar = "E:\PTU\Latest Files\SwSh References.pdf"
$alola = "E:\PTU\Latest Files\SuMo References.pdf"

$errata_a = "E:\PTU\Latest Files\Errata\PTU May 2015 Playtest Packet.pdf"
$errata_b = "E:\PTU\Latest Files\Errata\PTU September 2015 Playtest Packet.pdf"
$errata_c = "E:\PTU\Latest Files\Errata\February 2016 Playtest Packet.pdf"

$blessed = "E:\PTU\Latest Files\Expansions\Blessed and the Damned.pdf"
$porygon = "E:\PTU\Latest Files\Expansions\Do Porygon Dream of Mareep.pdf"
$throhs = "E:\PTU\Latest Files\Expansions\Game of Throhs.pdf"


$app = "E:\ChromeDownloads\xpdf-tools-win-4.02\xpdf-tools-win-4.02\bin64\pdftotext.exe"

# =============================================================================================================================
# CORE RULES
# =============================================================================================================================
# capabilities
.$app -f 303 -l 309 -raw $core "E:\Python\love-arceus\otherData\core\capabilities\core.txt"
.$app -f 1 -l 1 -raw $alola "E:\Python\love-arceus\otherData\core\capabilities\alola.txt"
.$app -f 1 -l 1 -raw $galar "E:\Python\love-arceus\otherData\core\capabilities\galar.txt"

.$app -f 14 -l 14 -raw $errata_c "E:\Python\love-arceus\otherData\core\capabilities\errata.txt"


# abilities
.$app -f 310 -l 310 -raw $core "E:\Python\love-arceus\otherData\core\abilities\keywords.txt"
.$app -f 311 -l 336 -raw $core "E:\Python\love-arceus\otherData\core\abilities\core.txt"
.$app -f 1 -l 6 -raw $alola "E:\Python\love-arceus\otherData\core\abilities\alola.txt"
.$app -f 1 -l 4 -raw $galar "E:\Python\love-arceus\otherData\core\abilities\galar.txt"

.$app -f 3 -l 11 -raw $errata_c "E:\Python\love-arceus\otherData\core\abilities\altered.txt"
.$app -f 12 -l 13 -raw $errata_c "E:\Python\love-arceus\otherData\core\abilities\new.txt"
.$app -f 9 -l 9 -raw $errata_b "E:\Python\love-arceus\otherData\core\abilities\sep.txt"

# moves
.$app -f 337 -l 338 -raw $core "E:\Python\love-arceus\otherData\core\moves\legend.txt"
.$app -f 339 -l 342 -raw $core "E:\Python\love-arceus\otherData\core\moves\keywords.txt"
.$app -f 288 -l 291 -raw $core "E:\Python\love-arceus\otherData\core\moves\weapons.txt"

.$app -f 346 -l 349 -raw $core "E:\Python\love-arceus\otherData\core\moves\bug.txt"
.$app -f 7 -l 7 -raw $alola "E:\Python\love-arceus\otherData\core\moves\bugAlola.txt"
.$app -f 350 -l 353 -raw $core "E:\Python\love-arceus\otherData\core\moves\dark.txt"
.$app -f 8 -l 8 -raw $alola "E:\Python\love-arceus\otherData\core\moves\darkAlola.txt"
.$app -f 5 -l 5 -raw $galar "E:\Python\love-arceus\otherData\core\moves\darkGalar.txt"
.$app -f 354 -l 355 -raw $core "E:\Python\love-arceus\otherData\core\moves\dragon.txt"
.$app -f 9 -l 9 -raw $alola "E:\Python\love-arceus\otherData\core\moves\dragonAlola.txt"
.$app -f 6 -l 6 -raw $galar "E:\Python\love-arceus\otherData\core\moves\dragonGalar.txt"
.$app -f 356 -l 359 -raw $core "E:\Python\love-arceus\otherData\core\moves\electric.txt"
.$app -f 10 -l 10 -raw $alola "E:\Python\love-arceus\otherData\core\moves\electricAlola.txt"
.$app -f 7 -l 7 -raw $galar "E:\Python\love-arceus\otherData\core\moves\electricGalar.txt"
.$app -f 360 -l 362 -raw $core "E:\Python\love-arceus\otherData\core\moves\fairy.txt"
.$app -f 11 -l 11 -raw $alola "E:\Python\love-arceus\otherData\core\moves\fairyAlola.txt"
.$app -f 8 -l 8 -raw $galar "E:\Python\love-arceus\otherData\core\moves\fairyGalar.txt"
.$app -f 363 -l 368 -raw $core "E:\Python\love-arceus\otherData\core\moves\fighting.txt"
.$app -f 12 -l 12 -raw $alola "E:\Python\love-arceus\otherData\core\moves\fightingAlola.txt"
.$app -f 9 -l 9 -raw $galar "E:\Python\love-arceus\otherData\core\moves\fightingGalar.txt"
.$app -f 369 -l 372 -raw $core "E:\Python\love-arceus\otherData\core\moves\fire.txt"
.$app -f 13 -l 13 -raw $alola "E:\Python\love-arceus\otherData\core\moves\fireAlola.txt"
.$app -f 10 -l 10 -raw $galar "E:\Python\love-arceus\otherData\core\moves\fireGalar.txt"
.$app -f 373 -l 376 -raw $core "E:\Python\love-arceus\otherData\core\moves\flying.txt"
.$app -f 14 -l 14 -raw $alola "E:\Python\love-arceus\otherData\core\moves\flyingAlola.txt"
.$app -f 377 -l 379 -raw $core "E:\Python\love-arceus\otherData\core\moves\ghost.txt"
.$app -f 15 -l 15 -raw $alola "E:\Python\love-arceus\otherData\core\moves\ghostAlola.txt"
.$app -f 380 -l 384 -raw $core "E:\Python\love-arceus\otherData\core\moves\grass.txt"
.$app -f 16 -l 16 -raw $alola "E:\Python\love-arceus\otherData\core\moves\grassAlola.txt"
.$app -f 11 -l 11 -raw $galar "E:\Python\love-arceus\otherData\core\moves\grassGalar.txt"
.$app -f 385 -l 387 -raw $core "E:\Python\love-arceus\otherData\core\moves\ground.txt"
.$app -f 17 -l 17 -raw $alola "E:\Python\love-arceus\otherData\core\moves\groundAlola.txt"
.$app -f 388 -l 390 -raw $core "E:\Python\love-arceus\otherData\core\moves\ice.txt"
.$app -f 18 -l 18 -raw $alola "E:\Python\love-arceus\otherData\core\moves\iceAlola.txt"
.$app -f 391 -l 413 -raw $core "E:\Python\love-arceus\otherData\core\moves\normal.txt"
.$app -f 19 -l 19 -raw $alola "E:\Python\love-arceus\otherData\core\moves\normalAlola.txt"
.$app -f 12 -l 12 -raw $galar "E:\Python\love-arceus\otherData\core\moves\normalGalar.txt"
.$app -f 413 -l 417 -raw $core "E:\Python\love-arceus\otherData\core\moves\poison.txt"
.$app -f 20 -l 20 -raw $alola "E:\Python\love-arceus\otherData\core\moves\poisonAlola.txt"
.$app -f 418 -l 425 -raw $core "E:\Python\love-arceus\otherData\core\moves\psychic.txt"
.$app -f 21 -l 21 -raw $alola "E:\Python\love-arceus\otherData\core\moves\psychicAlola.txt"
.$app -f 13 -l 13 -raw $galar "E:\Python\love-arceus\otherData\core\moves\psychicGalar.txt"
.$app -f 426 -l 428 -raw $core "E:\Python\love-arceus\otherData\core\moves\rock.txt"
.$app -f 22 -l 22 -raw $alola "E:\Python\love-arceus\otherData\core\moves\rockAlola.txt"
.$app -f 14 -l 14 -raw $galar "E:\Python\love-arceus\otherData\core\moves\rockGalar.txt"
.$app -f 429 -l 431 -raw $core "E:\Python\love-arceus\otherData\core\moves\steel.txt"
.$app -f 23 -l 23 -raw $alola "E:\Python\love-arceus\otherData\core\moves\steelAlola.txt"
.$app -f 15 -l 15 -raw $galar "E:\Python\love-arceus\otherData\core\moves\steelGalar.txt"
.$app -f 432 -l 435 -raw $core "E:\Python\love-arceus\otherData\core\moves\water.txt"
.$app -f 24 -l 24 -raw $alola "E:\Python\love-arceus\otherData\core\moves\waterAlola.txt"
.$app -f 16 -l 16 -raw $galar "E:\Python\love-arceus\otherData\core\moves\waterGalar.txt"

# items
.$app -f 271 -l 302 -raw $core "E:\Python\love-arceus\otherData\core\items\core.txt"

# edges
.$app -f 204 -l 205 -raw $core "E:\Python\love-arceus\otherData\core\edges\poke.txt"
.$app -f 35 -l 51 -raw $core "E:\Python\love-arceus\otherData\core\edges\skill-based.txt"
.$app -f 52 -l 56 -raw $core "E:\Python\love-arceus\otherData\core\edges\edges.txt"

# features
.$app -f 59 -l 59 -raw $core "E:\Python\love-arceus\otherData\core\features\general.txt"
.$app -f 60 -l 62 -raw $core "E:\Python\love-arceus\otherData\core\features\training.txt"
.$app -f 63 -l 63 -raw $core "E:\Python\love-arceus\otherData\core\features\combat.txt"
.$app -f 64 -l 64 -raw $core "E:\Python\love-arceus\otherData\core\features\other.txt"

# class features
.$app -f 75 -l 76 -raw $core "E:\Python\love-arceus\otherData\core\features\aceTrainer.txt"
.$app -f 78 -l 79 -raw $core "E:\Python\love-arceus\otherData\core\features\captureSpecialist.txt"
.$app -f 81 -l 81 -raw $core "E:\Python\love-arceus\otherData\core\features\commander.txt"
.$app -f 83 -l 84 -raw $core "E:\Python\love-arceus\otherData\core\features\coordinator.txt"
.$app -f 86 -l 86 -raw $core "E:\Python\love-arceus\otherData\core\features\hobbyist.txt"
.$app -f 88 -l 89 -raw $core "E:\Python\love-arceus\otherData\core\features\mentor.txt"
.$app -f 93 -l 94 -raw $core "E:\Python\love-arceus\otherData\core\features\cheerleader.txt"
.$app -f 96 -l 97 -raw $core "E:\Python\love-arceus\otherData\core\features\duelist.txt"
.$app -f 99 -l 99 -raw $core "E:\Python\love-arceus\otherData\core\features\enduringSoul.txt"
.$app -f 101 -l 101 -raw $core "E:\Python\love-arceus\otherData\core\features\juggler.txt"
.$app -f 103 -l 103 -raw $core "E:\Python\love-arceus\otherData\core\features\rider.txt"
.$app -f 105 -l 106 -raw $core "E:\Python\love-arceus\otherData\core\features\taskmaster.txt"
.$app -f 108 -l 109 -raw $core "E:\Python\love-arceus\otherData\core\features\trickster.txt"
.$app -f 112 -l 113 -raw $core "E:\Python\love-arceus\otherData\core\features\statAce.txt"
.$app -f 115 -l 117 -raw $core "E:\Python\love-arceus\otherData\core\features\styleExpert.txt"
.$app -f 119 -l 128 -raw $core "E:\Python\love-arceus\otherData\core\features\typeAce.txt"
.$app -f 131 -l 132 -raw $core "E:\Python\love-arceus\otherData\core\features\chef.txt"
.$app -f 134 -l 135 -raw $core "E:\Python\love-arceus\otherData\core\features\chronicler.txt"
.$app -f 137 -l 138 -raw $core "E:\Python\love-arceus\otherData\core\features\fashionista.txt"
.$app -f 140 -l 147 -raw $core "E:\Python\love-arceus\otherData\core\features\researcher.txt"
.$app -f 149 -l 151 -raw $core "E:\Python\love-arceus\otherData\core\features\survivalist.txt"
.$app -f 155 -l 155 -raw $core "E:\Python\love-arceus\otherData\core\features\athlete.txt"
.$app -f 157 -l 157 -raw $core "E:\Python\love-arceus\otherData\core\features\dancer.txt"
.$app -f 159 -l 159 -raw $core "E:\Python\love-arceus\otherData\core\features\hunter.txt"
.$app -f 161 -l 162 -raw $core "E:\Python\love-arceus\otherData\core\features\martialArtist.txt"
.$app -f 164 -l 164 -raw $core "E:\Python\love-arceus\otherData\core\features\musician.txt"
.$app -f 166 -l 167 -raw $core "E:\Python\love-arceus\otherData\core\features\provocateur.txt"
.$app -f 169 -l 169 -raw $core "E:\Python\love-arceus\otherData\core\features\rogue.txt"
.$app -f 171 -l 171 -raw $core "E:\Python\love-arceus\otherData\core\features\roughneck.txt"
.$app -f 173 -l 173 -raw $core "E:\Python\love-arceus\otherData\core\features\tumbler.txt"
.$app -f 177 -l 177 -raw $core "E:\Python\love-arceus\otherData\core\features\auraGuardian.txt"
.$app -f 179 -l 180 -raw $core "E:\Python\love-arceus\otherData\core\features\channeler.txt"
.$app -f 182 -l 182 -raw $core "E:\Python\love-arceus\otherData\core\features\hexManiac.txt"
.$app -f 184 -l 184 -raw $core "E:\Python\love-arceus\otherData\core\features\ninja.txt"
.$app -f 186 -l 187 -raw $core "E:\Python\love-arceus\otherData\core\features\oracle.txt"
.$app -f 189 -l 189 -raw $core "E:\Python\love-arceus\otherData\core\features\sage.txt"
.$app -f 191 -l 191 -raw $core "E:\Python\love-arceus\otherData\core\features\telekinetic.txt"
.$app -f 193 -l 193 -raw $core "E:\Python\love-arceus\otherData\core\features\telepath.txt"
.$app -f 195 -l 195 -raw $core "E:\Python\love-arceus\otherData\core\features\warper.txt"

.$app -f 3 -l 4 -raw $errata_a "E:\Python\love-arceus\otherData\core\features\backpacker.txt"
.$app -f 5 -l 7 -raw $errata_a "E:\Python\love-arceus\otherData\core\features\gadgeteer.txt"
.$app -f 3 -l 3 -raw $errata_b "E:\Python\love-arceus\otherData\core\features\cheerleaderErrata.txt"
.$app -f 6 -l 6 -raw $errata_b "E:\Python\love-arceus\otherData\core\features\medic.txt"


# .$app -f 74 -l 89 -raw $core "E:\Python\love-arceus\otherData\core\features\classIntro.txt"
# .$app -f 92 -l 109 -raw $core "E:\Python\love-arceus\otherData\core\features\classBattle.txt"
# .$app -f 112 -l 128 -raw $core "E:\Python\love-arceus\otherData\core\features\classSpecial.txt"
# .$app -f 130 -l 151 -raw $core "E:\Python\love-arceus\otherData\core\features\classPro.txt"
# .$app -f 154 -l 173 -raw $core "E:\Python\love-arceus\otherData\core\features\classFighter.txt"
# .$app -f 176 -l 195 -raw $core "E:\Python\love-arceus\otherData\core\features\classSuper.txt"
# .$app -f 2 -l 10 -raw $core "E:\Python\love-arceus\otherData\core\features\classPlaytest.txt"

# =============================================================================================================================
# BLESSED & THE DAMNED
# =============================================================================================================================
.$app -f 44 -l 52 -raw $blessed "E:\Python\love-arceus\otherData\blessed\features\advancements.txt"
.$app -f 53 -l 54 -raw $blessed "E:\Python\love-arceus\otherData\blessed\features\giftsGeneral.txt"
.$app -f 55 -l 56 -raw $blessed "E:\Python\love-arceus\otherData\blessed\features\blessings.txt"
.$app -f 57 -l 57 -raw $blessed "E:\Python\love-arceus\otherData\blessed\features\patronTags.txt"
.$app -f 58 -l 71 -raw $blessed "E:\Python\love-arceus\otherData\blessed\features\giftsLegendary.txt"

# =============================================================================================================================
# PORYGON
# =============================================================================================================================

# Start-Process -FilePath $app -ArgumentList "-f 12 -l 12 -raw $core `"E:\Python\love-arceus\rips\core.txt`""

# .$app -f 12 -l 747 -raw $core "E:\Python\love-arceus\rips\core.txt"

# .$app -f 4 -l 117 -raw $alola "E:\Python\love-arceus\rips\alola.txt"

# .$app -f 3 -l 103 -raw $galar "E:\Python\love-arceus\rips\galar.txt"

# .$app -f 417 -l 418 -raw $core "E:\Python\love-arceus\rips\darumaka.txt"