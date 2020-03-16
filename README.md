# Love-Arceus
Data-parsing tool for Pokémon Tabletop United literature.

This tool takes plaintext converted output of the official PDF files and converts the data into JSON for use in applications.

It is built specifically for the (in-progress) Arceus PTU web application, but the resultant JSON should be usable by others.

The following data is extracted into `json/` folder in the [Löve save directory]([https://love2d.org/wiki/love.filesystem](https://love2d.org/wiki/love.filesystem)):
- `pokedex.json` - contains the entire PTU Pokédex, including all formes, evolution tables, and movesets
- `moves.json` - contains Pokémon Moves
- `abilities.json`- contains Pokémon Abilities
- `capabilities.json` - contains both 'regular' and 'special' Capabilities
- `edges.json` - contains both Poké Edges and Trainer Edges
- `features.json` - contains all Features (grouped by category/class) NOTE: in-progress
- ~~`items.json` - contains all items~~ NOTE: Not yet implemented

Data from the Alola and Galar supplements are included.
**Expansion content and some errata has not yet been included.**

Eventually, text for some fields such as effects for moves/abilties/feats/etc will be pre-formatted using markdown notation.

The code for this project sucks, but it works. I just want to get it done.

## Running
Love-Arceus is built using the [Löve framework](https://love2d.org/), and targets **version 11.3**.

Currently, there is no .love build, so clone the repo and run from cmdline. 

Love-Arceus has a few cmd args to speed up execution, mainly for development. Run the tool with the `-help` arg for available options.

To parse everything, run the tool with the `-all` arg.

Several log files, intended for development, can also be generated with the `-log` option. (TO-DO)

## Source Text Files
This tool is domain-specific and tightly coupled to the PDF -> text output.

The following tool is used by the included Windows PowerShell scripts:

- https://www.xpdfreader.com/download.html

You can find the latest PTU files (at the time of writing) located [here on my google drive](https://drive.google.com/file/d/1vbaVqzbzbc63CnMOe30r1E1qxc9yf7pJ/view?usp=sharing).

If you want to run the PowerShell scripts, be sure to alter the filepaths first. There are two ps1 scripts:

- `pdf2txt.ps1` - rips Pokedexes
- `otherData/ripOtherData.ps1` - rips everything else

The ripOtherData script requires the full suite of PDFs, including expansions (maybe?) and errata. Text files are included with the repo, however these scripts are included for the sake of completion.

## Exported Data Notes
All JSON files are stored in minimised formats. If you need to browse and familiarise yourself with the data, use an application, such as [https://jsonformatter.org/json-pretty-print](https://jsonformatter.org/json-pretty-print), to view it.

### Pokédex
- Due to the semi-normalised format of the official PTU Pokédex PDF, additional pages for various formes for the following Pokémon are dynamically created:
	* *Hoopa* - bound/unbound
	* *Oricorio* - different Types
	* *Meowstic* - male/female
	* *Pumpkaboo* - four different sizes
	* *Gourgeist*  - four different sizes
	* *Rotom* - appliance formes
	* *Darmanitan* - standard/zen mode
	* *Unfezant* - male/female
	* *Basculin* - red/blue stripe
- Height/Weight are stored using the metric system
- Height Classes are stored as a string (under the *size* attribute), Weight is not stored as it is easily calculated
- Additional information has been added (dex numbers, generation introduced, formes list)
- Gender ratios are stored as the Male percentage only

### Pokédex Move Lists
- Level Up Moves are stored without the Move's Type
- Level Up Moves with a level of `0` are printed as 'Evo' in the PDF
- Level Up Moves for legendary Pokémon may contain the § (favourite) flag
- Egg/Tutor Moves may contain the (N) natural flag
- TM Moves are stored with the TM number. A negative number denotes a HM number
 
### Features
- Features are grouped by category/class. Alongside the category name and feat listings, any additional tables/lists from the class pages are also stored