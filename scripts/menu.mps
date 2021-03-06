/*********************************************** 
 * Copyright © Luke Salisbury 
 * 
 * This work is release under the GNU GENERAL PUBLIC LICENSE Version 3 
 * For Full Terms visit http://www.gnu.org/licenses/gpl-3.0.html 
 * 
 * --- OR --- 
 * 
 * You are free to share, to copy, distribute and transmit this work 
 * You are free to adapt this work 
 * Under the following conditions: 
 *  You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work). 
 *  You may not use this work for commercial purposes. 
 * Full terms of use: http://creativecommons.org/licenses/by-nc/3.0/ 
 * Changes: 
 *     2012/07/23 [luke]: new file. 
 ***********************************************/ 
 
#define CLUEDETAIL[.id{64}, .entity, .string] 
#define LOCATIONDETAIL[.name{64}, .x, .y]
 
 
forward public Index(); 
forward public Travel(); 
forward public Clues(); 
forward public unlockLocation( location[], gx, gy ); 
 
static menuSelect = 0; 
static clueChoosen = 0; 
static clueCount = -1; 
static clues[256][CLUEDETAIL]; 
static clueDescription{1000}; 
 
 
static menuWait = 0; 
 
main() 
{
 
} 
 
CheckButton() 
{ 
	if ( menuWait <= 0 ) 
	{ 
		if ( InputButton(6) == 1 ) 
			return true;	 
	} 
	else 
	{ 
		menuWait -= GameFrame(); 
	} 
	return false; 
} 
 
AddWait(time) 
{ 
	menuWait = time; 
} 
 
ScanClues( refresh ) 
{ 
	if ( refresh != -1 ) 
		return; 
	clueCount = 0;	 
	clueChoosen = 0; 
 
	new entity{64};
	new entityId; 
	new c = EntitiesList( GLOBAL_MAP ); 
	new q = 0; 
	if ( c ) 
	{ 
		while ( EntitiesNext(entityId, GLOBAL_MAP, entity) ) 
		{ 
			q = StringFind( entity, "item_" ); 
			if ( q == 0 ) 
			{ 
				StringCopy( clues[clueCount].id, entity ); 
				clues[clueCount].string = EntityPublicVariable(entityId, "string_id");
				clues[clueCount].entity = entityId; 
				clueCount++; 
			} 
	 
		} 
	}
 
} 
 
CombineClues() 
{ 
	new c1  = clueChoosen - 1; 
	new c2  = menuSelect - 1; 
	new an = EntityPublicFunction(clues[c2].entity, "checkCombination",  [ARG_STRING, ARG_END], clues[c1].id ); 
 
	if ( an ) 
	{ 
		clueChoosen = 0; 
		clueCount = -1; 
	} 
 
	AddWait(10); 
} 
 
 
 
public Clues() 
{ 
	ScanClues(clueCount); 
 
	if ( CheckButton() ) // Enter pressed 
	{ 
		if ( menuSelect == 0 ) 
			return 2; 
		else if ( clueChoosen && menuSelect != clueChoosen ) 
		{ 
			CombineClues(); 
		} 
		else 
			clueChoosen = menuSelect; 
	} 
 
	GraphicsDraw( "", RECTANGLE, 16,16, 6, 180,64 + (clueCount*20), 0x00000099 ); 
	GraphicsDraw( "Return", TEXT, 24,24, 6, 0,0, menuSelect == 0 ? 0xFF3333FF : 0xFFFFFFFF ); 
 
	if ( clueCount > 0 ) 
	{ 
		for ( new n = 0; n< clueCount; n++ ) 
		{ 
			new offset = EntityPublicFunction( clues[n].entity, "printName", ''nnnn'', 24, 44+(20*n), 6, menuSelect == n+1 ? 0xFF3333FF : 0xFFFFFFFF ); 
			if ( clueChoosen == n + 1) 
			{ 
				GraphicsDraw("combine", TEXT, 24 + offset ,44+(20*n), 6, 0, 0,  0xFFFF00FF); 
			} 
		 
		} 
	} 
 
	if ( menuSelect > 0 ) 
	{ 
		if ( !clueDescription{0} ) 
		{ 
			LanguageString( clues[menuSelect-1].string, clueDescription ) 
		} 
 
		GraphicsDraw("", RECTANGLE, 212, 16, 6, 180,200, 0x00000099); 
		GraphicsDraw(clueDescription, TEXT, 216, 20, 6, 0, 0, 0xFFFFFFFF); 
	} 
 
	/* Check for Up/down input then use the remainder to loop */ 
	if ( InputButton(7) == 1 ) 
	{ 
		StringClear(clueDescription); 
		menuSelect--; 
	} 
	else if ( InputButton(8) == 1 ) 
	{ 
		StringClear(clueDescription); 
		menuSelect++; 
	} 
 
	menuSelect %= clueCount+1; 
	 
 
	return 0; 
} 
 
/* Travel Menu */ 
 
#define LOCATIONS 20 
 
new available_location[LOCATIONS][LOCATIONDETAIL]; 
new locations_count = 0; 
 
public unlockLocation( location[], gx, gy ) 
{ 
	if ( locations_count < LOCATIONS) 
	{
/* 
		StringCopy( available_location[locations_count].name, location); 
		available_location[locations_count].x = gx; 
		available_location[locations_count].y = gy; 
		locations_count++; 
*/
	} 
} 
 
public Travel() 
{ 
	if ( InputButton(6) ==1 ) // Enter pressed 
	{ 
		if ( menuSelect == 0 )
		{ 
			return 2;
		} 
		else if ( menuSelect > 0 ) 
		{
		/* 
			new i = menuSelect - 1; 
			if (i >= 0 ) 
			{ 
				new section_name{64}; 
				new x; 
				SectionGet(section_name, x, x); 
				if ( !StringEqual(section_name, available_location[i].name) ) 
				{ 
					SetEntityTarget( available_location[i].name,  available_location[i].x,  available_location[i].y ); 
					EntityPublicFunction(AGENTENTITY, "newLocation", ''snn'',  available_location[i].name,  available_location[i].x,  available_location[i].y); 
				} 
				 
			} 
			menuSelect = 0;
*/ 
			return 1; 
		} 
 
	} 
 
	GraphicsDraw("", RECTANGLE, 16,16, 6, 180, 44 + (locations_count*20), 0x00000099); 
	GraphicsDraw("Return", TEXT, 24,24, 6, 0,0, menuSelect == 0 ? 0xFF3333FF : 0xFFFFFFFF); 
/* 
	for ( new n = 0; n < locations_count; n++ ) 
	{ 
		if ( available_location[n].name ) 
		{ 
			GraphicsDraw( available_location[n].name, TEXT, 24,44+(20*n), 6, 0,0, menuSelect == n+1 ? 0xFF3333FF : 0xFFFFFFFF); 
		}	 
	} 
*/ 
 
	/* Check for Up/down input then use the remainder to loop */ 
	if ( InputButton(7) == 1 )
	{ 
		menuSelect--;
	} 
	else if ( InputButton(8) == 1 )
	{ 
		menuSelect++;
	} 
 
	menuSelect %= 20; 
 
 
	return 0; 
} 
 
/* Main Menu */ 
 
public Index() 
{ 
	/* Reset counter */ 
	clueCount = -1; 
 
	if ( InputButton(6) ==1 ) // Enter pressed 
	{ 
		if ( menuSelect == 0 )
		{ 
			return 3;
		} 
		else if ( menuSelect == 1 ) 
		{ 
			menuSelect = 0; 
			return 4; 
		}		 
		else
		{ 
			return 1;
		} 
	} 
 
	GraphicsDraw("", RECTANGLE, 16,16, 6, 180,68, 0x00000099); 
	GraphicsDraw("Travel", TEXT, 24,24, 6, 0,0, menuSelect == 0 ? 0xFF3333FF : 0xFFFFFFFF); 
	GraphicsDraw("Clues", TEXT, 24,44, 6, 0,0, menuSelect == 1 ? 0xFF3333FF : 0xFFFFFFFF); 
	GraphicsDraw("Continue", TEXT, 24,64, 6, 0,0, menuSelect == 2 ? 0xFF3333FF : 0xFFFFFFFF); 
	 
 
	/* Check for Up/down input then use the remainder to loop */ 
	if ( InputButton(7) == 1 )
	{ 
		menuSelect--;
	} 
	else if ( InputButton(8) == 1 )
	{ 
		menuSelect++;
	} 
 
	menuSelect %= 3; 
 
 
	return 0; 
} 
