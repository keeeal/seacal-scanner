#pragma once

namespace Scanning
{

namespace
{
long _top_limit;
long _bottom_limit;
} // namespace

void onEnter();
void run();
void onExit();
void setLimits(long top_limit, long bottom_limit);

} // namespace Scanning
