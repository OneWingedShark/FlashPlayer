With SWF.Utils;
with Ada.Text_IO;
with Interfaces;
with Ada.Unchecked_Conversion;
Package Body SWF.Types is

    Use IEEE_754_Constants;
    Use Type Real_32, Real_64, Interfaces.Unsigned_8;

    function Convert is new Ada.Unchecked_Conversion
      (Source => Interfaces.Unsigned_16,	Target => Half);

    Function Get_Exp( Input : Real_32 ) Return Exponent_Type is
	use Type Interfaces.Integer_8;
	Temp : Interfaces.Integer_8:= SWF.Utils.Get_Exp(Input) + 15;
    begin
	Return Result : Exponent_Type:=
	  (if (abs Input > 65504.0) then 2#11111# else Exponent_Type(Temp)) do
	    Ada.Text_IO.Put_Line( "Exp:" & Temp'img );
--	    Exponent_Type(SWF.Utils.Get_Exp(Input)-128 + 15));
	end return;
    End Get_Exp;


    Function Convert_Mantissa( Mantissa : Natural ) Return Mantissa_Type is
	Use Interfaces;
	Temp : Unsigned_32:= Shift_Right( Unsigned_32(Mantissa), 13);
    begin
	return Result : Mantissa_Type:= Mantissa_Type(Temp);
	  --Mantissa_Type(  );
    End Convert_Mantissa;

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


    -- Function Get_Exp( Input : Real_32 ) Return Natural;

--     Function Get_Exp( Input : Real_32 ) Return Exponent_Type is
--  	( if (abs Input > 65504.0) then 2#11111#
--            else Exponent_Type(SWF.Utils.Get_Exp(Input)-128 + 15)
--  	);




    Function Convert( Input : Real_32 ) Return Half is
      (if	Input = F32_Positive_Infinity then (False, 2#11111#, 16#000#)
	elsif	Input = F32_Negative_Infinity then (True , 2#11111#, 16#000#)
	elsif	Input = F32_Positive_Zero     then (False, 2#00000#, 16#000#)
	elsif	Input = F32_Negative_Zero     then (True,  2#00000#, 16#000#)
	elsif	Input = F32_Not_a_Number      then (True,  2#11111#, 16#3FF#)
       else (
	     Sign	=> Input < 0.0,
	     Exp	=> Get_Exp(Input),
	     Mantissa	=> Convert_Mantissa( SWF.Utils.Get_Mantissa(Input) )
	    )
      );




End SWF.Types;
