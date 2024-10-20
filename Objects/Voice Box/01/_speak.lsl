// Voice Box by Dedric Mauriac

// This script attempts to similate voice with just under 60 sound clips.
// It was made as a gift to second life residents in cellebration of
// Second Life's Third Annual Anniversary

list translations = [
    "Happy Birthday, Second Life!",
    "All your prims, are belong to us",
    "I blame it all on Philip Linden",
    "Show me the Lindens!"
];
list codes = [
    "hh1 aa pp pp ey pa bb1 er2 th th dd2 ay pa ss eh kk1 ow nn1 dd1 pa ll ay ff",
    "aw ll pa yy1 or pa pp rr1 eh mm ss pa pa ar pa bb1 ey ll ow ng pa tt1 ow pa uh ss ss",
    "ay pa bb1 ll eh mm pa eh tt1 pa aw ll pa ow nn1 pa ff eh ll ih pp pa ll ih nn1 dd1 eh nn1",
    "sh ow pa mm ey pa th uh pa ll ih nn1 dd1 eh nn1 ss"
];

Speak(string message)
{
    list allophones = llParseString2List(message, [" "], []);

    integer n = llGetListLength(allophones);
    integer i;
    string allophone = "";
    for(i = 0; i < n; ++i)
    {
        allophone = llList2String(allophones, i);
        if(allophone == "pa") llSleep(.3);
        else llPlaySound(allophone, 1);
    }
}

integer index;

default
{
    state_entry()
    {
        llSetSoundQueueing(FALSE);
    }
    touch_start(integer total_number)
    {
        ++index;
        index %= llGetListLength(codes);
        llSay(0, llList2String(translations, index));
        Speak(llList2String(codes, index));
    }
}