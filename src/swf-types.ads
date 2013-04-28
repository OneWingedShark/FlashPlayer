With Interfaces;

Package SWF.Types is

    -----------------------
    --  SIGNED INTEGERS  --
    -----------------------

    --  SI8: Signed 8-bit integer value
    SubType SI_8 is Interfaces.Integer_8;

    --  SI16: Signed 16-bit integer value
    SubType SI_16 is Interfaces.Integer_16;

    --  SI32: Signed 32-bit integer value
    SubType SI_32 is Interfaces.Integer_32;

    --  SI64: Signed 64-bit integer value [NOT IN DOCUMENT]
    SubType SI_64 is Interfaces.Integer_64;

    -------------------------
    --  UNSIGNED INTEGERS  --
    -------------------------

    --  UI8: Unsigned 8-bit integer value
    SubType UI_8 is Interfaces.Unsigned_8;

    --  UI16: Unsigned 16-bit integer value
    SubType UI_16 is Interfaces.Unsigned_16;

    --  UI32: Unsigned 32-bit integer value
    SubType UI_32 is Interfaces.Unsigned_32;

    --  UI64: Unsigned 64-bit integer value
    SubType UI_64 is Interfaces.Unsigned_64;

    -----------------------------
    --  SIGNED INTEGER ARRAYS  --
    -----------------------------

    Generic
	Type Element is (<>);
    Package Array_Type_Pkg is
	Type Array_Type is Array(Positive Range <>) of Element
	with Pack;

	Type Record_Type( Length : Natural ) is record
	    Data : Array_Type(1..Length);
	End record
	with Pack;
    End Array_Type_Pkg;

    Package ASI_8  is New Array_Type_Pkg( SI_8 );
    Package ASI_16 is New Array_Type_Pkg( SI_16 );
    Package ASI_32 is New Array_Type_Pkg( SI_32 );
    Package ASI_64 is New Array_Type_Pkg( SI_64 );
    Package AUI_8 is New Array_Type_Pkg( UI_8 );
    Package AUI_16 is New Array_Type_Pkg( UI_16 );
    Package AUI_32 is New Array_Type_Pkg( UI_32 );
    Package AUI_64 is New Array_Type_Pkg( UI_64 );

    -------------------
    --  FIXED POINT  --
    -------------------

    Type Fixed_8 is delta 0.00390625 range -Float(16#80#) .. Float(16#79#)
    with Size => 16, Small => 0.00390625; --0.125;
      --1.0**(-16#10000#);

    Type Fixed is delta 1.0**(-16#1000#) range 0.0 .. Float(16#10000#)
    with Size => 32, Small => 1.0**(-16#1000#);

    ----------------------
    --  FLOATING POINT  --
    ----------------------

    Type Half;--	is private;
    SubType Real_32	is Interfaces.IEEE_Float_32;
    SubType Real_64	is Interfaces.IEEE_Float_64;


    Function Convert( Input : Half ) Return Real_32;
    Function Convert( Input : Real_32 ) Return Half;
--      Function Convert( Input : Half ) Return Real_64;
--      Function Convert( Input : Real_64 ) Return Half;


    Package IEEE_754_Constants is
	F64_Positive_Infinity : constant Real_64;
	F64_Positive_Zero     : constant Real_64;
	F64_Negative_Infinity : constant Real_64;
	F64_Negative_Zero     : constant Real_64;
	F64_Not_a_Number      : constant Real_64;

	F32_Positive_Infinity : constant Real_32;
	F32_Positive_Zero     : constant Real_32;
	F32_Negative_Infinity : constant Real_32;
	F32_Negative_Zero     : constant Real_32;
	F32_Not_a_Number      : constant Real_32;

    Private
	Use Type Real_32, Real_64;

	-- Values from http://rosettacode.org/wiki/Extreme_floating_point_values
	Function Zero  Return Real_32 is ( 0.0 );
	Function PInf  Return Real_32 is (1.0 / Zero);
	Function NInf  Return Real_32 is (-PInf);
	Function PZero Return Real_32 is (1.0 / PInf);
	Function NZero Return Real_32 is (1.0 / NInf);
	Function NaN   Return Real_32 is (0.0 / Zero);

	Function Zero  Return Real_64 is ( 0.0 );
	Function PInf  Return Real_64 is (1.0 / Zero);
	Function NInf  Return Real_64 is (-PInf);
	Function PZero Return Real_64 is (1.0 / PInf);
	Function NZero Return Real_64 is (1.0 / NInf);
	Function NaN   Return Real_64 is (0.0 / Zero);


	F64_Positive_Infinity : constant Real_64:= PInf;
	F64_Positive_Zero     : constant Real_64:= PZero;
	F64_Negative_Infinity : constant Real_64:= NInf;
	F64_Negative_Zero     : constant Real_64:= NZero;
	F64_Not_a_Number      : constant Real_64:= NaN;

	F32_Positive_Infinity : constant Real_32:= PInf;
	F32_Positive_Zero     : constant Real_32:= PZero;
	F32_Negative_Infinity : constant Real_32:= NInf;
	F32_Negative_Zero     : constant Real_32:= NZero;
	F32_Not_a_Number      : constant Real_32:= NaN;
    End IEEE_754_Constants;



--      Type Fixed is;

--Private
    Type Exponent_Type is mod 2**5 with Size => 5;
    Type Mantissa_Type is range  0..2**10-1 with Size => 10;
      -- -2**9..2**9-1 with Size => 10;

    type Half is record
	Sign	: Boolean;
	Exp	: Exponent_Type;
	Mantissa: Mantissa_Type;
    end record
    with Pack, Size => 16;
PRIVATE
    Use IEEE_754_Constants;
    Use Type Real_32, Real_64;

    -- TODO:	Need to implement Float/Half conversion.
    -- Conversion Refrences:
    --	http://galfar.vevb.net/wp/2011/16bit-half-float-in-pascaldelphi/
    --	https://en.wikipedia.org/wiki/Half-precision_floating-point_format
    Function Convert( Input : Half ) Return Real_32 is
      (case Input.Exp is
       when 2#00000# =>			-- Denormalized Values
	 (if Input.Mantissa /= 0 then
		 (if Input.Sign then -1.0 else 1.0)
	       * 2.0**Integer(-14)
	       * Real_32(Real_32(Input.Mantissa) / 1024.0)
		-- Result := Power(-1, Sign) * Power(2, -14) * (Mantissa / 1024)
	  elsif Input.Sign then
		F32_Negative_Zero
	  else
		F32_Positive_Zero
	  ),
       when 2#11111# =>			-- Infinities & NaN
	 (if Input.Mantissa /= 0 then F32_Not_a_Number
	  elsif Input.Sign then F32_Negative_Infinity else F32_Positive_Infinity
	 ),
       when 2#00001# .. 2#11110# =>	-- Normalized value
	 (if Input.Sign then -1.0 else 1.0)
       * 2.0**Natural(Input.Exp-15)
       * Real_32(1.0+(Real_32(Input.Mantissa) / 1024.0))
	 -- Result := Power(-1, Sign) * Power(2, Exp-15) * (1 + Mantissa / 1024)
      );

     Function Get_Exp( Input : Real_32 ) Return Exponent_Type is
	( if (Input > 65504.0) then 2#11111#
       else 2#01010#
       );

    Function Convert( Input : Real_32 ) Return Half is
      (if	Input = F32_Positive_Infinity then (False, 2#11111#, 16#000#)
	elsif	Input = F32_Negative_Infinity then (True , 2#11111#, 16#000#)
	elsif	Input = F32_Positive_Zero     then (False, 2#00000#, 16#000#)
	elsif	Input = F32_Negative_Zero     then (True,  2#00000#, 16#000#)
	elsif	Input = F32_Not_a_Number      then (True,  2#11111#, 16#3FF#)
       else ( Input < 0.0, Get_Exp(Input) - 127 + 15, 123)
      );


End SWF.Types;
