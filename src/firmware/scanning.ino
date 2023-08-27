#include "scanning.h"

void Scanning::on_enter()
{
}

void Scanning::on_exit()
{
}

State *Scanning::update()
{
    arm.run();
    base.run();
    return this;
}
