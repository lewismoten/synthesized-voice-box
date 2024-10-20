integer PRELOAD_SOUND = 10001;
integer SOUND_PRELOADED = 10002;
integer SPEAK = 10003;
integer PREPARE_SPEACH = 10004;
integer SPEACH_PREPARED = 10005;

integer nodeIndex = 1;
integer nodeCount = 6;

list codes;
integer codeCount;

init()
{
    llSetSoundQueueing(FALSE);
    integer i;
    integer n = llGetInventoryNumber(INVENTORY_SOUND);
    for(i = nodeIndex; i < n; i+= nodeCount)
        llPreloadSound(llGetInventoryName(INVENTORY_SOUND, i));
    llMessageLinked(LINK_ROOT, SOUND_PRELOADED, "", NULL_KEY);
}
prepare(string message)
{
    codes = llParseString2List(message, [";"], []);
    codes = llParseString2List(llList2String(codes, nodeIndex), ["|"], []);
    llMessageLinked(LINK_ROOT, SPEACH_PREPARED, "", NULL_KEY);
    codeCount = llGetListLength(codes);
}
speak()
{    
    integer i;
    for(i = 0; i < codeCount; ++i)
    {
        llSleep(llList2Float(codes, i++));
        string allophone = llList2String(codes, i);
        if(llGetSubString(allophone, 0, 1) != "pa")
            llPlaySound(allophone, 1);
    }
}
default
{
    link_message(integer sender, integer number, string message, key id)
    {
        if(number == PRELOAD_SOUND) init();
        else if(number == SPEAK)
        {
            float time = (float)message;
            llSetTimerEvent(time - llGetTime());
        }
        else if(number == PREPARE_SPEACH) prepare(message);
    }
    timer()
    {
        llSetTimerEvent(0);
        speak();
    }
}
