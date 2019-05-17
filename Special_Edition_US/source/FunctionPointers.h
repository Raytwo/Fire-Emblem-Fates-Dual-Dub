#pragma once

void* (*memalloc)(int) = (void*(*)(int))0x113CE8;

void* (*GameUserData_Get)() = (void*(*)())0x1B3ED4;
// SVCs
void (*svcExitProcess)() = (void(*)())0x1040EC;
void (*svcBreak)(char) = (void(*)(char))0x12A240;