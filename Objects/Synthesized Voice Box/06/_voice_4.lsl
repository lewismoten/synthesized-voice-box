integer PRELOAD_SOUND = 10001;
integer SOUND_PRELOADED = 10002;
integer SPEAK = 10003;
integer PREPARE_SPEACH = 10004;
integer SPEACH_PREPARED = 10005;

integer nodeIndex = 4;
integer nodeCount = 6;

list codes;
integer codeCount;

list assets = [
"zh", "9f74de66-a9da-497f-23d4-9c2f98fb5ac6",
"yy2", "b58056bd-d693-a189-a638-d5e0af6b89cb",
"yy1", "1f5a0caf-9819-4631-7c4a-04ce5d2afd52",
"yr", "ff52d90f-a248-e6eb-7247-d893151cd6d1",
"xr", "d22beeff-6b94-8c9b-2eed-d7ae28af75a2",
"ww", "e8030e24-2a92-6086-45a6-3ea522205aae",
"wh", "d2e5638c-f1d9-f935-0a7b-b345e4e91982",
"vv", "1faf68a8-67a8-4a0c-3b8a-71d8e52ad272",
"uw2", "4c9159be-f76b-5de6-472e-3fdfc4c9bb96",
"uw1", "b8df7908-e81e-a349-7d61-f88910257e87",
"uh", "ab7d2700-f628-4a2c-037b-dfc450ba48b5",
"tt2", "375d67dc-8e2c-0680-65f1-ea8163a6f773",
"tt1", "b4a88e82-ff3f-9200-a990-ce6dddbfc2c5",
"th", "c567d9e3-b09e-864f-85c3-6ee5e6ae589c",
"ss", "d050b6a0-e90e-8185-6a45-e5a1bf421769",
"sh", "37cd9adb-feb9-e540-2caf-96cd38e3ccc1",
"rr2", "1018d3af-5f38-3bde-5b88-7e9ad92e73bc",
"rr1", "a2ada50b-81f6-5fe4-8802-bdc2c30e25bb",
"pp", "68f35212-a966-6318-27d2-1d1b1b73e050",
"oy", "6951a500-73d4-ffa6-6168-a0b9792a5d8a",
"ow", "1580f305-95c7-fd74-fbf5-af2b49ad05a3",
"nn2", "a6ac3f32-9806-fca5-e44e-a2ce754d6340",
"nn1", "a4172aaa-f879-f131-3dfc-0015afc42d8c",
"ng", "bde26cbb-29b8-af14-d7ae-c274b36edf75",
"mm", "842a0cf7-fe1c-8aee-8d11-b442ae2f3264",
"ll", "5ba01875-c10c-5fc1-6bef-1c82be1b620c",
"kk3", "785bc01b-0f55-dc3b-e3f7-4e3879774cf2",
"kk2", "b000d1dc-d580-37e3-c112-8e827943eafb",
"kk1", "f2b2044c-dea5-ec2a-f31d-064fe93380ca",
"jh", "f6e6a98e-eb54-52aa-87e2-720dc1e65e69",
"iy", "799f9b34-7ba8-8b8f-fa71-8dd2b93df3cc",
"ih", "6bfcf908-b4c3-caef-78d2-51e488984f30",
"hh2", "1da3b4b4-3faf-0cea-447d-0003a16886c2",
"hh1", "dec81a8f-eb39-8344-0661-cb17e5ca291d",
"gg3", "9abbb4bf-9355-8041-0ef3-13b1d83dbd1e",
"gg2", "f22a46f2-cffa-499a-0cbf-8a118fb6c35e",
"gg1", "c09ba744-1c07-9035-8eb6-d17138141ebc",
"ff", "f83010a2-4038-7fc1-0cdb-a6d8b8d8ce0e",
"ey", "ad688cc9-7c0a-8ef9-170f-c24d8ce58499",
"er2", "5f309548-80a4-c927-798f-3e95c6bdd400",
"er1", "494feb49-5c5d-4d67-0254-15ddf1d598f3",
"el", "cf25b065-570c-a452-4ff4-56727dc43376",
"eh", "345743ca-901c-1e8e-4f09-a7726b448c7f",
"dh2", "48a3c739-476a-a322-5a9d-2b836c54a0f7",
"dh1", "46c255bb-4bd5-8102-ebf1-e098de9d3e91",
"dd2", "d3ce9bee-7623-1844-b5d4-28ca6439424d",
"dd1", "2bf51bd5-0656-ed0c-a193-ee9e0c6f5fb7",
"ch", "4124f3fe-a9f6-d0d5-2da4-bf2b6be0cf1b",
"bb2", "2518346a-1be9-9453-3d2a-367f3ee7e796",
"bb1", "1b317b8e-694f-0da2-d756-a045dc4f997e",
"ay", "0138387b-a922-cbeb-997f-16966d944ed7",
"ax", "c40716de-2536-9b35-2975-38c2b4aaded0",
"aw", "e2cf8648-ae1e-43c3-41d7-99be925fd2ad",
"ar", "1a3f688b-2970-e4ca-40a0-f8a358583b6b",
"ao", "b2b5818c-da7a-84e5-e8fd-b6edc1dfd1e1",
"ae", "5317ed61-3173-ed31-1ca9-c930a9aae5d8",
"aa", "25c8f4f6-86fc-9d9f-c42d-7ab0d455dbf4",
"zz", "d371dfdf-95c2-c8e1-e188-085aa258689e"
];

key soundKey(string allophone)
{
    integer i = llListFindList(assets, [allophone]);
    if(i == -1) return NULL_KEY;
    return llList2Key(assets, i + 1);
}
init()
{
    llSetSoundQueueing(FALSE);
    integer i;
    integer n = llGetListLength(assets) / 2;
    
    // preload every sixth sound with an offset of the node number
    // allows 6 sounds to be asynchronously be preloaded at a time
    for(i = nodeIndex; i < n; i+= nodeCount)
        llPreloadSound(llList2Key(assets, (i * 2) + 1));
    llMessageLinked(LINK_ROOT, SOUND_PRELOADED, "", NULL_KEY);
}
prepare(string message)
{
    codes = llParseString2List(message, [";"], []);
    codes = llParseString2List(llList2String(codes, nodeIndex), ["|"], []);
    codeCount = llGetListLength(codes);
    llMessageLinked(LINK_ROOT, SPEACH_PREPARED, "", NULL_KEY);
}
speak()
{    
    integer i;
    for(i = 0; i < codeCount; i++)
    {
        llSleep(llList2Float(codes, i));
        i++;
        string allophone = llList2String(codes, i);
        if(llGetSubString(allophone, 0, 1) != "pa")
            llPlaySound(soundKey(allophone), 1);
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