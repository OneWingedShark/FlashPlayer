Limited With SWF.Types;

With
Interfaces;

Use
Interfaces;

Private Package SWF.Utils is


    Function Get_Exp( Input : IEEE_Float_32 ) Return Integer_8;
    Function Get_Mantissa( Input : IEEE_Float_32 ) Return Natural;

    Function to_half(Input : IEEE_Float_32 ) Return Unsigned_16;

    Procedure Stub;
End SWF.Utils;
