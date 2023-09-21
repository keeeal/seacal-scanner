#pragma once

namespace Scanning
{

namespace
{
long top_limit;    // Steps
long bottom_limit; // Steps
} // namespace

void onEnter();
void run();
void onExit();
void setTopLimit(long position);
void setBottomLimit(long position);

} // namespace Scanning
