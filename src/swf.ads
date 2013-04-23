pragma Optimize( Space );
Package SWF is
pragma pure;
    Type SWF_File is abstract tagged private;


    -- A twip (abbreviating "twentieth of a point") is a typographical measurement,
    -- defined as 1/20 of a typographical point. One twip is 1/1440 inch when
    -- derived from the PostScript point at 72 to the inch, and 1/1445.4 inch
    -- when based on the printer's point at 72.27 to the inch.
    Type Twip is delta 1.0/20.0 range 0.0..12.75
    	with Size => 8, Small => 0.05;


private

    Type SWF_Header;
    Type Header_Handle is not null access SWF_Header with storage_size => 0;


    Type SWF_File is abstract tagged record
	null;
    end record;

--    For SWF_File'Read
End SWF;
