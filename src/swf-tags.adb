with Ada.Unchecked_Conversion;

Package Body SWF.Tags is

    Function Internal_Convert is
      new Ada.Unchecked_Conversion(Source => Tag_Code_Type,
				   Target => SWF_Tag_Code);
    Function Internal_Convert is
      new Ada.Unchecked_Conversion(Source => SWF_Tag_Code,
				   Target => Tag_Code_Type);

    Function Convert( Input : Tag_Code_Type ) Return SWF_Tag_Code is
      ( Internal_Convert(Input) );
    Function Convert( Input : SWF_Tag_Code  ) Return Tag_Code_Type is
      ( Internal_Convert(Input) );

End SWF.Tags;
