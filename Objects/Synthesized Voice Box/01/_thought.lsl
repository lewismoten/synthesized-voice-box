// Voice Box by Dedric Mauriac

// This script attempts to similate voice with just under 60 sound clips.
// It was made as a gift to second life residents in cellebration of
// Second Life's Third Annual Anniversary

// based on the General Instrument SPO-256-AL2 chip
// http://www.howell1964.freeserve.co.uk/parts/sp0256.htm

integer PRELOAD_SOUND = 10001;
integer SOUND_PRELOADED = 10002;
integer SPEAK = 10003;
integer PREPARE_SPEACH = 10004;
integer SPEACH_PREPARED = 10005;
integer SOUND_PREPARE = 10006;

list translations = [
    "Happy Birthday, Second Life!",
    "All your prims, are belong to us",
    "I blame it all on Philip Linden",
    "Show me the Lindens!"
];
list codes = [
    "hh1 hh1 ae pp iy pa4 pa3 bb2 er2 th dd2 eh ey pa4 pa3 pa5 ss ss eh kk3 ax ax uh nn1 dd1 pa4 pa3 ll ll ay ff",
    "ao ll ll pa4 pa3 yy2 uh or rr2 pa4 pa3 pp rr2 ih ih mm zz pa4 pa3 pa5 aa er2 pa4 pa3 bb2 ih ll ax ax nn1 gg3 pa4 pa3 tt2 uw2 pa4 pa3 uh ss",
    "ao ay pa4 pa3 bb1 ll ey dh2 mm pa4 pa3 ih tt2 pa4 pa3 ao ll pa4 pa3 ao nn1 pa4 pa3 ff eh ll ih pp pa4 pa3 ll eh nn1 dd2 eh nn1",
    "sh ow pa4 pa3 mm iy pa4 pa3 dh1 iy pa4 pa3 ll ay nn1 dd2 eh nn1 zz"
];
float Duration(string a)
{
    if(a == "gg2") return .04;
    if(a == "bb2") return .05;
    if(a == "ih" || a == "ax" || a == "dd1" || a == "eh") return .07;
    if(a == "bb1" || a == "gg1") return .08;
    if(a == "ss") return .09;
    if(a == "tt1" || a == "uh" || a == "uw1" || a == "ao" || a == "aa") return .1;
    if(a == "ll") return .11;
    if(a == "hh1" || a == "yy1" || a == "kk3" || a == "rr2" || a == "ae") return .12;    
    if(a == "jh" || a == "tt2" || a == "gg3" || a == "nn1") return .14;
    if(a == "ff") return .15;
    if(a == "er1" || a == "sh" || a == "dd2" || a == "kk1") return .16;
    if(a == "rr1") return .17;
    if(a == "mm" || a == "hh2" || a == "yy2" || a == "th" || a == "ww") return .18;
    if(a == "vv" || a == "kk2" || a == "zh" || a == "ch" || a == "nn2" || a == "el") return .19;
    if(a == "wh") return .2;
    if(a == "pp" || a == "zz") return .21;
    if(a == "ng") return .22;
    if(a == "ow" || a == "dh2") return .24;
    if(a == "iy") return .25;
    if(a == "ay" || a == "uw2") return .26;
    if(a == "ey") return .28;
    if(a == "ar" || a == "dh1") return .29;
    if(a == "er2") return .3;
    if(a == "or") return .33;
    if(a == "yr") return .35;
    if(a == "xr") return .36;
    if(a == "aw") return .37;
    if(a == "oy") return .42;
    
    if(a == "pa1") return .01;
    if(a == "pa2") return .03;
    if(a == "pa3") return .05;
    if(a == "pa4") return .1;
    if(a == "pa5") return .2;
    
    llOwnerSay("unknow allophone " + a);
    return 0;
}
Speak(string message)
{
    list allophones = llParseString2List(message, [" "], []);
    list times;
    integer n = llGetListLength(allophones);
    integer i;
    string allophone = "";
    
    string code1 = "";
    string code2 = "";
    string code3 = "";
    string code4 = "";
    string code5 = "";
    string code6 = "";
    
    float dialation = - 0.1;
    
    float time1 = dialation;
    float time2 = dialation;
    float time3 = dialation;
    float time4 = dialation;
    float time5 = dialation;
    float time6 = dialation;
    float time = 0;
    
    
    for(i = 0; i < n; ++i)
    {
        allophone = llList2String(allophones, i);
        time = Duration(allophone);
        if(llGetSubString(allophone, 0, 1) == "pa") allophone = "pa";
        
        // first node
        if(i % 6 == 0)
        {
            code1 += (string)(time1) + "|" + allophone + "|";
            time1 = dialation;
        }
        else if(i % 6 == 1)
        {
            code2 += (string)(time2) + "|" + allophone + "|";
            time2 = dialation;
        }
        else if(i % 6 == 2)
        {
            code3 += (string)(time3) + "|" + allophone + "|";
            time3 = dialation;
        }
        else if(i % 6 == 3)
        {
            code4 += (string)(time4) + "|" + allophone + "|";
            time4 = dialation;
        }
        else if(i % 6 == 4)
        {
            code5 += (string)(time5) + "|" + allophone + "|";
            time5 = dialation;
        }
        else if(i % 6 == 5)
        {
            code6 += (string)(time6) + "|" + allophone + "|";
            time6 = dialation;
        }
        // add allophone's time to pause with other nodes
        time1 += time;
        time2 += time;
        time3 += time;
        time4 += time;
        time5 += time;
        time6 += time;
        
    }

    preloadCount = 0;
    llMessageLinked(LINK_SET, PREPARE_SPEACH, code1 + ";" + code2 + ";" + code3 + ";" + code4 + ";" + code5 + ";" + code6, NULL_KEY);
}
string Hexes2Allophones(string message)
{
    message = llToLower(message);
    list hexes = llParseString2List(message, [" ", "x", "0x", ","], []);
    string m;
    integer i;
    integer n = llGetListLength(hexes);
    for(i = 0; i < n; i++)
        m += Hex2Allophone(llList2String(hexes, i)) + " ";
    m = llGetSubString(m, 0, -1);
    llOwnerSay(m);
    return m;
}
string Hex2Allophone(string hex)
{
    // SPO256-AL2 opcodes
    if(hex == "00") return "pa1";
    if(hex == "01") return "pa2";
    if(hex == "02") return "pa3";
    if(hex == "03") return "pa4";
    if(hex == "04") return "pa5";
    if(hex == "05") return "oy";
    if(hex == "06") return "ay";
    if(hex == "07") return "eh";
    if(hex == "08") return "kk3";
    if(hex == "09") return "pp";
    if(hex == "0a") return "jh";
    if(hex == "0b") return "nn1";
    if(hex == "0c") return "ih";
    if(hex == "0d") return "tt2";
    if(hex == "0e") return "rr1";
    if(hex == "0f") return "ax";
    
    if(hex == "10") return "mm";
    if(hex == "11") return "tt1";
    if(hex == "12") return "dh1";
    if(hex == "13") return "iy";
    if(hex == "14") return "ey";
    if(hex == "15") return "dd1";
    if(hex == "16") return "uw1";
    if(hex == "17") return "ao";
    if(hex == "18") return "aa";
    if(hex == "19") return "yy2";
    if(hex == "1a") return "ae";
    if(hex == "1b") return "hh1";
    if(hex == "1c") return "bb1";
    if(hex == "1d") return "th";
    if(hex == "1e") return "uh";
    if(hex == "1f") return "uw2";
    
    if(hex == "20") return "aw";
    if(hex == "21") return "dd2";
    if(hex == "22") return "gg3";
    if(hex == "23") return "vv";
    if(hex == "24") return "gg1";
    if(hex == "25") return "sh";
    if(hex == "26") return "zh";
    if(hex == "27") return "rr2";
    if(hex == "28") return "ff";
    if(hex == "29") return "kk2";
    if(hex == "2a") return "kk1";
    if(hex == "2b") return "zz";
    if(hex == "2c") return "ng";
    if(hex == "2d") return "ll";
    if(hex == "2e") return "ww";
    if(hex == "2f") return "xr";

    if(hex == "30") return "wh";
    if(hex == "31") return "yy1";
    if(hex == "32") return "ch";
    if(hex == "33") return "er1";
    if(hex == "34") return "er2";
    if(hex == "35") return "ow";
    if(hex == "36") return "dh2";
    if(hex == "37") return "ss";
    if(hex == "38") return "nn2";
    if(hex == "39") return "hh2";
    if(hex == "3a") return "or";
    if(hex == "3b") return "ar";
    if(hex == "3c") return "yr";
    if(hex == "3d") return "gg2";
    if(hex == "3e") return "el";
    if(hex == "3f") return "bb2";

    llOwnerSay("Unknown hex " + hex);
    
    return "pa3";
}

integer index;
integer listener;
integer listener2;
integer preloadCount;
init()
{
    index = -1;
    llSetSoundQueueing(FALSE);
    if(listener) llListenRemove(listener);
    if(listener2) llListenRemove(listener2);
    listener = llListen(78, "", llGetOwner(), ""); // allophone channel
    listener = llListen(79, "", llGetOwner(), ""); // hex code channel

    preloadCount = 0;
    llMessageLinked(LINK_SET, PRELOAD_SOUND, EOF, NULL_KEY);
}
default
{
    state_entry()
    {
        init();
    }
    on_rez(integer start_param)
    {
        init();
    }
    touch_start(integer total_number)
    {
        ++index;
        index %= llGetListLength(codes);
        llSay(0, llList2String(translations, index));
        Speak(llList2String(codes, index));
    }
    listen(integer channel, string name, key id, string message)
    {
        if(channel == 78) Speak(message);
        else if(channel == 79) Speak(Hexes2Allophones(message));
    }
    link_message(integer sender, integer number, string message, key id)
    {
        if(number == SOUND_PREPARE)
        {
            Speak(message);
        }
        if(number == SOUND_PRELOADED)
        {
            preloadCount++;
            if(preloadCount == 6) Speak("rr1 eh eh pa1 dd2 iy");
        }
        if(number == SPEACH_PREPARED)
        {
            preloadCount++;
            if(preloadCount == 6) 
            {
                float time = llGetTime() + 2;
                llMessageLinked(LINK_SET, SPEAK, (string)time, NULL_KEY);
            }
        }
    }
}