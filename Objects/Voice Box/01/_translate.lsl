// really crummy translation ... but hey, it's entertaining.

// just send text to channel 77.  It will print out a list of
// allophones to help you get started.
integer SOUND_PREPARE = 10006;

list TranslateWord(string word)
{
    if(word == "") return [];
    word = llToLower(word);
    string allophones;
    integer i;
    integer n = llStringLength(word);
    string allophone;
    for(i = 0; i < n; ++i)
        if(i + 1 < n)
        {
            allophone = TranslatePair(llGetSubString(word, i, i+1));
            if(allophone != "") 
            {
                ++i;
                allophones += " " + allophone;
            }
            else
                allophones += " " + TranslateSingle(llGetSubString(word, i, i));
        }
        else
            allophones += " " + TranslateSingle(llGetSubString(word, i, i));
            
    return llParseString2List(llGetSubString(allophones, 1, -1), [" "], []);
}

string TranslatePair(string p)
{
    if(p == "aa") return "aa";
    if(p == "ae") return "ae";
    if(p == "ao") return "ao";
    if(p == "ar") return "ar";
    if(p == "aw") return "aw";
    if(p == "ax") return "ax";
    if(p == "ch") return "ch";
    if(p == "dh") return "dh1";
    if(p == "eh") return "eh";
    if(p == "el") return "el";
    if(p == "er") return "er1";
    if(p == "ey") return "ey";
    if(p == "ff") return "ff";
    if(p == "ih") return "ih";
    if(p == "iy") return "iy";
    if(p == "jh") return "jh";
    if(p == "ir") return "er1";
    if(p == "ng") return "ng";
    if(p == "or") return "or";
    if(p == "ow") return "ow";
    if(p == "oy") return "oy";
    if(p == "sh") return "sh";
    if(p == "th") return "th";
    if(p == "uh") return "uh";
    if(p == "uw") return "uw1";
    if(p == "wh") return "wh";
    if(p == "xr") return "xr";
    if(p == "yr") return "yr";
    if(p == "zh") return "zh";
    return "";
}
string TranslateSingle(string s)
{
    if(s == "a") return "aa";
    if(s == "b") return "bb1";
    if(s == "c") return "kk1";
    if(s == "d") return "dd1";
    if(s == "e") return "eh";
    if(s == "f") return "ff";
    if(s == "g") return "gg1";
    if(s == "h") return "hh1";
    if(s == "i") return "ay";
    if(s == "j") return "jh";
    if(s == "k") return "kk1";
    if(s == "l") return "ll";
    if(s == "m") return "mm";
    if(s == "n") return "nn1";
    if(s == "o") return "ow";
    if(s == "p") return "pp";
    if(s == "q") return "kk1 wh";
    if(s == "r") return "rr1";
    if(s == "s") return "ss";
    if(s == "t") return "tt1";
    if(s == "u") return "uh";
    if(s == "v") return "vv";
    if(s == "w") return "wh";
    if(s == "x") return "kk1 ss";
    if(s == "y") return "yy1";
    if(s == "z") return "zz";
    if(s == ".") return "pa5";
    if(s == "-") return "dh1 aa sh";
    if(s == "0") return "zz yr ow";
    if(s == "1") return "ww ss ax nn1";
    if(s == "2") return "tt2 uw2";
    if(s == "3") return "th rr1 iy";
    if(s == "4") return "ff ff or";
    if(s == "5") return "ff ff ay vv";
    if(s == "6") return "ss ss ih ih kk2 kk2";
    if(s == "7") return "ss eh vv eh nn1";
    if(s == "8") return "eh ae tt1";
    if(s == "9") return "nn1 ay nn1";
    
    return "pa";
}
SpeakTranslation(list allophones)
{
    llMessageLinked(LINK_THIS, SOUND_PREPARE, llDumpList2String(allophones, " "), NULL_KEY);
    
//    integer n = llGetListLength(allophones);
//    integer i;
//    string allophone = "";
//    for(i = 0; i < n; ++i)
//    {
//        allophone = llList2String(allophones, i);
//        if(allophone == "pa") llSleep(.3);
//        else llPlaySound(allophone, 1);
//    }
}
SpeakWord(string word)
{
    SpeakTranslation(TranslateWord(word));
}
integer listener;
init()
{
    if(listener) llListenRemove(listener);
    listener = llListen(77, "", llGetOwner(), "");
}
default
{
    state_entry()
    {
        init();
    }
    on_rez(integer start_parameter)
    {
        init();
    }
    listen(integer channel, string name, key id, string message)
    {
        list all = TranslateWord(message);
        llOwnerSay(llDumpList2String(all, " "));
        
        llWhisper(PUBLIC_CHANNEL, message);
        list words = llParseString2List(message, [" ", ".", ","], []);
        integer i;
        integer n = llGetListLength(words);
        for(i = 0; i < n; ++i)
            SpeakWord(llList2String(words, i));
    }
}
