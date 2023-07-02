//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	/* {"⌨", "sb-kbselect", 0, 30}, */
	{"",	     "sb-memory",	        10,                 14},
    {"",	     "sb-wifi",             20,                  4},
	{"",	     "sb-cpu",              10,                 18},
	{"",	     "sc-volume",            0,                 10},
	{"",	     "sb-battery",          30,                  3},
	{"",	     "sb-clock",            60,                  1},
	{"", "cat /tmp/recordingicon 2>/dev/null",	0,	9},
	/* {"",	"sb-music",	0,	11}, */
	{"",	"sb-pacpackages",	0,	8},
	/* {"",	"sb-price xmr Monero 🔒 24",			9000,	24}, */
	/* {"",	"sb-price eth Ethereum 🍸 23",	9000,	23}, */
	/* {"",	"sb-price btc Bitcoin 💰 21",				9000,	21}, */
	{"",	"sb-torrent",	20,	7},
	/* {"",	"sb-memory",	10,	14}, */
	/* {"",	"sb-cpu",		10,	18}, */
	/* {"",	"sb-moonphase",	18000,	17}, */
	{"",	"sb-forecast",	18000,	5},
	{"",	"sb-mailbox",	180,	12},
	/* {"",	"sb-iplocate", 0,	27}, */
	{"",	"sb-help-icon",	0,	15},
};

//Sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char *delim = " ";

// Have dwmblocks automatically recompile and run when you edit this file in
// vim with the following line in your vimrc/init.vim:

// autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }
