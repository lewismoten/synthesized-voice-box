// Preload sounds in preparation for export from viewer cache

integer count;
integer number;

preloadSounds() {
    count = llGetInventoryNumber(INVENTORY_ALL);
    if(count <= 1) {
        done();
        return;
    }
    number = 0;
    next();
}

next() {
    if(number > count) {
        done();
        return;
    }
    string name = llGetInventoryName(INVENTORY_ALL, number);
    if(llGetInventoryType(name) == INVENTORY_SOUND) {
        key id = llGetInventoryKey(name);
        llPreloadSound(id);
        if(number % 10 == 0) {
            llOwnerSay("Preloaded " + (string)number);
        }
    }
    number++;
    next();
}
done() {
    llOwnerSay("All sounds preloaded");
}

default
{
    state_entry()
    {
        preloadSounds();
    }
    touch_start(integer total_number)
    {
        llSay(0, "Touched.");
    }
}
