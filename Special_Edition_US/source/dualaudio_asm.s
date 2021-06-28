.text
.align 4

.set malloc, 0x00113B6C
.set ConfigItem_ConfigItem, 0x003BA98C
.set Mess_Get, 0x003D1CEC
.set GameUserGlobaData, 0x006DA27C

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
	beq SpeakerModeOption
	bl ConfigItem_ConfigItem
	ldr r1, =GameConfigMenuDualAudioVTable
	str r1, [r0]
SpeakerModeOption:
	add r1, r4, #0x4
	b 0x3BBD3C // The very next instruction after out branch

DualAudio_SetValue:
	stmdb sp!, {r4, lr}
	ldr r3, =0x6DA0F8 // GameConfig
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
.word 0x3BC6F4 //operator_delete_12?
.word 0x1C68C0 //BasicMenuItem::BuildAttribute
.word 0x0
.word 0x3BA6C4 //ConfigItem::BuildW
.word 0x3DC7B8 //game::menu::SplitLargeMenuItem::BuildH
.word 0x1C68B8 //BasicMenuItem::BuildBlankH
.word DualAudio_GetName //Subtitle::GetName
.word 0x3BA6D4 //ConfigItem::GetHelp
.word 0x3BA848 //ConfigItem::GetColor
.word 0x1C69CC //BasicMenuItem::Tick
.word 0x3BA408 //ConfigItem::Draw
.word 0x3BA3B8 //ConfigItem::DrawDirect
.word 0x3BA8B8 //ConfigItem::OnSelect
.word 0x3BA714 //ConfigItem::KeyCall
.word 0x1C69D0 //BasicMenuItem::ACall
.word 0x3BA698 //ConfigItem::BCall
.word 0x1C69F4 //BasicMenuItem::XCall
.word 0x1C69FC //BasicMenuItem::YCall
.word 0x1C69E4 //BasicMenuItem::LCall
.word 0x1C69EC //BasicMenuItem::RCall
.word 0x1C6ADC //BasicMenuItem::StartCall
.word 0x1C6860 //BasicMenuItem::CustomCall
.word 0x3DC534 //game::menu::SplitMenuItem::IsSplitSelecting
.word 0x3BA670 //ConfigItem::GetSplitWindowType
.word 0x3DC68C //game::menu::SplitMenuItem::IsSplitWindowTypeDisable
.word 0x3DC69C //game::menu::SplitMenuItem::IsSplitWindowTypeProvisory
.word 0x3BA70C //ConfigItem::GetMenu
.word DualAudio_GetValueNames //SpeakerMode::GetValueName
.word DualAudio_GetValueHelp //Subtitle::GetValueHelp
.word 0x3BA6CC //ConfigItem::GetNum
.word 0x0
.word DualAudio_GetMask //Subtitle::GetMask
.word 0x3BA88C //ConfigItem::GetValue
.word DualAudio_SetValue //Subtitle::SetValue
.word 0x3BA680 //ConfigItem::GetValuePositionOffset
.word 0x0
.word 0x0
.word 0x63808C