With
SWF.Tags,
Interfaces;

Use
SWF.Tags,
Interfaces;


Package body SWF is

    Type TRECT_IN_TWIPS is record
	Height, Width : Twip;
    end record;

    Type SWF_Header is record
	Signature	:	String(1..3);
	Version		:	Interfaces.Unsigned_8;
	Length		:	Interfaces.Unsigned_32;
	Size		:	TRECT_IN_TWIPS;

	FrameRate,
	FrameCount	:	Interfaces.Unsigned_16;
    end record
    with Pack,
	Static_Predicate => valid_signature(SWF_Header),
    	Size => 96+2*Twip'Size;

    Function valid_signature(Header : SWF_Header) return Boolean is
      ( (Header.Signature = "CWS" and Header.Version >= 6) or
	 Header.Signature = "FWS");


    For SWF_Header Use record
	Signature	at  0 range 0..3*8-1;
	Version		at  3 range 0..7;
	Length		at  4 range 0..31;
	Size		at  8 range 0..15;
	FrameRate	at 10 range 0..15;
	FrameCount	at 12 range 0..15;
    end record;

    Type SWF_short_tag_length is new Natural Range 0..62 with size => 6;
    --Type SWF_Tag_Code is new Natural Range 0..2*10-1 with Size => 10;

    Type SWF_Tag( Is_Long : Boolean := False ) is record
	code		: Tag_Code_Type; --SWF_Tag_Code;
	short_length	: SWF_short_tag_length;
	case Is_Long is
	when false => null;
	when True  => Extended_Length : Interfaces.Integer_32;
	end case;
    end record;


End SWF;
