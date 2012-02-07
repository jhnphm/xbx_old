/*****************************************************************************
Written and Copyright (C) by Ingo von Maurich
and the Secure Hardware Group of Ruhr-Universitaet Bochum. 
All rights reserved.

Contact ingo.vonmaurich@rub.de for comments & questions.
This program is free software; You may use it or parts of it or
modifiy it under the following terms:

(1) Usage and/or redistribution and/or modification of the software 
or parts of the software is permitted for non-commercial use only.

(2a) If this software or parts are used as part of a new software, you
must license the entire work, as a whole, under this License to anyone
who comes into possession of a copy. This License will therefore
apply, to the whole of the work, and all its parts, regardless of how
they are packaged.

(2b) You may expand this license by your own license. In this case this
license still applies to the software as mentioned in (2a) and must
not be changed. The expansion must be clearly recognizable as such. In
any case of collision between the license and the expansion the
license is superior to the expansion.

(3) If this software or parts are used as part of a new software, you
must provide equivalent access to the source code of the entire work,
as a whole, to anyone who comes into possession of a copy, in the same
way through the same place at no further charge, as for the binary
version.

(4) This program is distributed in the hope that it will be useful,
but   WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
(5) These notices must be retained in any copies of any part of this
documentation and/or software.

(6) If this software is used credit must be given to the
"Secure Hardware Group of Ruhr-Universitaet Bochum, Germany" as
the authors of the parts of the software used. This can be in the form
of a textual message at program startup or at *beginning* of the
documentation (online or textual) provided with the package.

If you are interested in a commercial use 
please contact ingo.vonmaurich@rub.de.
/*****************************************************************************/

.MACRO G a, b, c, d, e, f
	
	ld a_hi,X+
	ld a_mh,X+
	ld a_ml,X+
	ld a_lo,X+
	adiw xl,\a
	ld b_hi,X+
	ld b_mh,X+
	ld b_ml,X+
	ld b_lo,X+
	adiw xl,\b
	ld c_hi,X+
	ld c_mh,X+
	ld c_ml,X+
	ld c_lo,X+
	adiw xl,\c
	ld d_hi,X+
	ld d_mh,X+
	ld d_ml,X+
	ld d_lo,X+

; call Gi here
	rcall gi
; store back to state in SRAM

	st -X,d_lo
	st -X,d_ml
	st -X,d_mh
	st -X,d_hi
	sbiw xl,\d
	st -X,c_lo
	st -X,c_ml
	st -X,c_mh
	st -X,c_hi
	sbiw xl,\e
	st -X,b_lo
	st -X,b_ml
	st -X,b_mh
	st -X,b_hi
	sbiw xl,\f
	st X+,a_hi
	st X+,a_mh
	st X+,a_ml
	st X+,a_lo

.ENDM


