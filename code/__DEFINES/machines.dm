// channel numbers for power
#define EQUIP			1
#define LIGHT			2
#define ENVIRON			3
#define TOTAL			4	//for total power used only
#define STATIC_EQUIP 	5
#define STATIC_LIGHT	6
#define STATIC_ENVIRON	7


//bitflags for door switches.
#define OPEN	1
#define IDSCAN	2
#define BOLTS	4
#define SHOCK	8
#define SAFE	16

//used in design to specify which machine can build it
#define	IMPRINTER	1	//For circuits. Uses glass/chemicals.
#define PROTOLATHE	2	//New stuff. Uses glass/metal/chemicals
#define	AUTOLATHE	4	//Uses glass/metal only.
#define CRAFTLATHE	8	//Uses fuck if I know. For use eventually.
#define MECHFAB		16 //Remember, objects utilising this flag should have construction_time and construction_cost vars.
//Note: More then one of these can be added to a design but imprinter and lathe designs are incompatable.

// computer3 error codes, move lower in the file when it passes dev -Sayu
#define PROG_CRASH          1  // Generic crash.
#define MISSING_PERIPHERAL  2  // Missing hardware.
#define BUSTED_ASS_COMPUTER 4  // Self-perpetuating error.  BAC will continue to crash forever.
#define MISSING_PROGRAM     8  // Some files try to automatically launch a program. This is that failing.
#define FILE_DRM            16 // Some files want to not be copied/moved. This is them complaining that you tried.
#define NETWORK_FAILURE     32