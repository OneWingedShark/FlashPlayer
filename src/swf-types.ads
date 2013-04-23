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

    Type Half	is private;
    SubType Real_32	is Interfaces.IEEE_Float_32;
    SubType Real_64	is Interfaces.IEEE_Float_64;


    Function Convert( Input : Half ) Return Float;
    Function Convert( Input : Float ) Return Half;



--      Type Fixed is;

Private
    Type Exponent_Type is mod 2**5 with Size => 5;
    Type Mantissa_Type is range -2**9..2**9-1;

    type Half is record
	Sign	: Boolean;
	Exp	: Exponent_Type;
	Mantissa: Mantissa_Type;
    end record
    with Pack, Size => 16;

    -- TODO:	Need to implement Float/Half conversion.
    Function Convert( Input : Half ) Return Float is
      (case Input.Exp is
       when 2#00000# => -- Denormalized
	 (if Input.Exp = 0 and Input.Mantissa = 0 then
		2.1
	  else
		1.2
	  ),
       when 2#11111# => 3.0,
--         	(if Input.Sign then -1.0 else 1.0) * 2.0**Natural(Input.Exp-15) * Float(Input.Mantissa),
       when 2#00001# .. 2#11110# => Standard.Float(3)
      );

    Function Convert( Input : Float ) Return Half is
      ( others => <> );


End SWF.Types;
