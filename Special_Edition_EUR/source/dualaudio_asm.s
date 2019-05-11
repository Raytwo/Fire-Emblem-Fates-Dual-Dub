.text
.align 4

.set malloc, 0x00113CE8
.set ConfigItem_ConfigItem, 0x003BAE9C
.set Mess_Get, 0x003D221C
.set GameUserGlobaData, 0x006DA414

// Hook after the creation of a menu entry to add itself in and then give back control
ProcGameConfigMenu_CreateConfigMenu_hook:
	add r1, r4, #0x4
	ldmia r1, {r1, r2}
	add r3, r1, #0x1
	str r3, [r4, #0x4]
	str r0, [r2, r1, lsl #0x2]
	mov r1, r7
	mov r0, #0x4c
	bl malloc
	cmp r0, #0x0
	nop
	beq VoicePlayOption
	bl ConfigItem_ConfigItem
	ldr r1, =GameConfigMenuDualAudioVTable
	str r1, [r0]
VoicePlayOption:
	add r1, r4, #0x4
	b 0x3bc24c

DualAudio_SetValue:
	stmdb sp!, {r4, lr}
	ldr r3, =0x6DA290
	ldr r2, [r0, #0x0]
	cmp r1, #0x0
	ldr r4, [r3, #0x0]
	ldr r1, [r2, #0x80]
	beq equalZero
	blx r1
	ldr r1, [r4, #0x4]
	orr r0, r0, r1
	str r0, [r4, #0x4]
	mov r0, #0x1
	b branchToToggleAudioDub
equalZero:
	nop
	blx r1
	ldr r1, [r4, #0x4]
	bic r0, r1, r0
	str r0, [r4, #0x4]
	mov r0, #0x0
branchToToggleAudioDub:
	ldmia sp!, {r4, lr}
	b GameUserGlobalData_ToggleAudioDub

GameUserGlobalData_ToggleAudioDub:
	ldr r1, =GameUserGlobaData
	ldr r1, [r1, #0x0]
	cmp r1, #0x0
	beq exit//If equal to 0
	cmp r0, #0x0
	ldr r0, [r1, #0x0]
	orrne r0, r0, #0x10
	biceq r0, r0, #0x10
	str r0, [r1, #0x0]
exit:
	bx lr

// Mask for the bit to work on
DualAudio_GetMask:
	mov R0, #0x100000
	bx lr

DualAudio_GetName:
	adr r0, [DualAudio_Name]
	b Mess_Get

DualAudio_GetValueNames:
	ldr r2, DualAudio_ValueNames
	str lr, [sp, #-4]!
	sub sp, sp, #0xC
	ldmia r2, {r0, r2}
	stmea sp, {r0, r2}
	ldr r0, [sp, r1, lsl#2]
	bl Mess_Get
	add sp, sp, #0xC
	ldr pc, [sp], #0x4

DualAudio_GetValueHelp:
	ldr r2, DualAudio_ValueHelp
	str lr, [sp, #-4]!
	sub sp, sp, #0xC
	ldmia r2, {r0, r2}
	stmea sp, {r0, r2}
	ldr r0, [sp, r1, lsl#2]
	bl Mess_Get
	add sp, sp, #0xC
	ldr pc, [sp], #0x4

// Name of the option
.align 2
DualAudio_Name:
.asciz "MID_CONFIG_DUB"

DualAudio_ValueNames:
.word DualAudio_Names

// Code related to the values of the option
.align 2
DualAudio_Names:
.word DualAudio_Value_EN
.word DualAudio_Value_JP

.align 2
DualAudio_Value_EN:
.asciz "MID_CONFIG_DUB_EN"
DualAudio_Value_JP:
.asciz "MID_CONFIG_DUB_JP"

// Code related to the Help messages for the values
DualAudio_ValueHelp:
.word DualAudio_Help

.align 2
DualAudio_Help:
.word DualAudio_H_Value_EN
.word DualAudio_H_Value_JP

.align 2
DualAudio_H_Value_EN:
.asciz "MID_H_CONFIG_DUB_EN"
DualAudio_H_Value_JP:
.asciz "MID_H_CONFIG_DUB_JP"

// The VTable that contains function poitners to everything the option uses. Most of it comes from the Subtitle option VTable.
.align 2
GameConfigMenuDualAudioVTable:
.word 0x0
.word 0x3BCC04 //No idea
.word 0x1C6D54 //BasicMenuItem::BuildAttribute
.word 0x0
.word 0x3BABD4 //ConfigItem::BuildW
.word 0x3DCCE8 //game::menu::SplitLargeMenuItem::BuildH
.word 0x1C6D4C //BasicMenuItem::BuildBlankH
.word DualAudio_GetName //Subtitle::GetName
.word 0x3BABE4 //ConfigItem::GetHelp
.word 0x3BAD58 //ConfigItem::GetColor
.word 0x1C6E60 //BasicMenuItem::Tick
.word 0x3BA918 //ConfigItem::Draw
.word 0x3BA8C8 //ConfigItem::DrawDirect
.word 0x3BADC8 //ConfigItem::OnSelect
.word 0x3BAC24 //ConfigItem::KeyCall
.word 0x1C6E64 //BasicMenuItem::ACall
.word 0x3BABA8 //ConfigItem::BCall
.word 0x1C6E88 //BasicMenuItem::XCall
.word 0x1C6E90 //BasicMenuItem::YCall
.word 0x1C6E78 //BasicMenuItem::LCall
.word 0x1C6E80 //BasicMenuItem::RCall
.word 0x1C6F70 //BasicMenuItem::StartCall
.word 0x1C6CF4 //BasicMenuItem::CustomCall
.word 0x3DCA64 //game::menu::SplitMenuItem::IsSplitSelecting
.word 0x3BAB80 //ConfigItem::GetSplitWindowType
.word 0x3DCBBC //game::menu::SplitMenuItem::IsSplitWindowTypeDisable
.word 0x3DCBCC //game::menu::SplitMenuItem::IsSplitWindowTypeProvisory
.word 0x3BAC1C //ConfigItem::GetMenu
.word DualAudio_GetValueNames //SpeakerMode::GetValueName
.word DualAudio_GetValueHelp //Subtitle::GetValueHelp
.word 0x3BABDC //ConfigItem::GetNum
.word 0x0
.word DualAudio_GetMask //Subtitle::GetMask
.word 0x3BAD9C //ConfigItem::GetValue
.word DualAudio_SetValue //Subtitle::SetValue
.word 0x3BAB90 //ConfigItem::GetValuePositionOffset
.word 0x0