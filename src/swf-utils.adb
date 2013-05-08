With
Interfaces.C.Extensions,
Ada.Text_IO,		-- DEBUGGING
Unchecked_Conversion,
SWF.Types;

Use
SWF.Types;


Package Body SWF.Utils is

    Type	Real_32_Rec;
    SubType	Real_32_Exponent is Integer_8;
    Type	Real_32_Mantissa is mod 2**23 with Size => 23;

    Type Real_32_Rec is record
	Sign		: Boolean;
	Exponent	: Real_32_Exponent;
	Mantissa	: Real_32_Mantissa;
    end record
    with Pack, Size => 32;

    For Real_32_Rec use record
	Sign		at 0 range 0..0;
	Exponent	at 0 range 1..8;
	Mantissa	at 0 range 9..31;
    end record;

    Function Convert is new Unchecked_Conversion
      ( Source => Real_32,	Target => Unsigned_32 );

    Function Convert is new Unchecked_Conversion
      ( Source => Real_32,	Target => Real_32_Rec );

    Function Convert is new Unchecked_Conversion
      ( Source => Real_32_Rec,	Target => Real_32 );

    Function Get_Exp ( Input : IEEE_Float_32 ) Return Integer_8 is
    begin
	Return Convert( Input ).Exponent;
    end Get_Exp;


    Function Get_Mantissa ( Input : IEEE_Float_32 ) Return Natural is
       Working : Real_32_Mantissa Renames Convert( Input ).Mantissa;
    begin
    Ada.Text_IO.Put_Line( "Value:" & Input'Img & "   Mantissa:" & Working'Img );
	Return Natural( Working );
    End Get_Mantissa;


Function to_half(Input : IEEE_Float_32 ) Return Unsigned_16 is
    Use Type Unsigned_32;
    F	: Constant Unsigned_32 := Convert(Input);
    F_1	: Constant Unsigned_32 := (F and 16#7f800000#) - 16#38000000#;

    Function Lo(Input : Unsigned_32) Return Unsigned_16 with inline;
    Function Lo(Input : Unsigned_32) Return Unsigned_16 is
	Type R is record
	    Hi, Lo : Unsigned_16;
	End record;

	Temp : R with Import, convention => Ada, Address => Input'Address;
    begin
	Return Temp.Lo;
    end Lo;

begin
    Return Result : Unsigned_16  :=
      Lo(Shift_Left(Value  => F,	Amount => 16)	and 16#8000#)	or
      Lo(Shift_Left(Value  => F_1,	Amount => 13)	and 16#7C00#)	or
      Lo(Shift_Left(Value  => F,	Amount => 13)	and 16#03FF#);
end to_half;


Procedure Stub is begin null; end stub;
End SWF.Utils;
