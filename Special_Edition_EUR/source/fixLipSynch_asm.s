.text
.align 4

LoadJPLipSynch:
  bl 0x20cc6c
  cmp r0,#1
  ldreq r2,=JPLipSynchPath
  ldrne r2,=ENLipSynchPath
  cpy r0, r5
  b 0x001b5724

.align 4

JPLipSynchPath:
.string "rom:/live2d/LipSynch_JP/%s.lsbin"
ENLipSynchPath:
.string "rom:/live2d/LipSynch/%s.lsbin"