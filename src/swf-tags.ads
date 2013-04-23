Package SWF.Tags is
	Pragma Pure;

    -- Tag_Code_Type defines the baseic/predefined tag values, defined by the
    -- SWF specification; SWF_Tag_Code is the actual 10-bit value of a tag.
    --
    -- Currently, the Tag numbers 0..511 are reserved for future use.
    -- Tag numbers 512..1023 are reserved for use by third party applications.
    Type Tag_Code_Type;
    Type SWF_Tag_Code is new Natural Range 0..2**10-1 with Size => 10;

    Function Convert( Input : Tag_Code_Type ) Return SWF_Tag_Code;
    Function Convert( Input : SWF_Tag_Code  ) Return Tag_Code_Type;

    -- Tag_Code_Type is the enumeration of the predefined tag-ID codes;
    -- it should never exceed a length of 512 possible values.
    --
    -- Currently only 90 are used.		(Numeric Values 0..89)
    Type Tag_Code_Type is (
	TT_End,
	TT_ShowFrame,
	TT_DefineShape,
	TT_PlaceObject,
	TT_RemoveObject,
	TT_DefineBits,
	TT_DefineButton,
	TT_JPEGTables,
	TT_SetBackgroundColor,
	TT_DefineFont,
	TT_DefineText,
	TT_DoAction,
	TT_DefineFontInfo,
	TT_DefineSound,
	TT_StartSound,
	TT_DefineButtonSound,
	TT_SoundStreamHead,
	TT_SoundStreamBlock,
	TT_DefineBitsLossless,
	TT_DefineBitsJPEG2,
	TT_DefineShape2,
	TT_DefineButtonCxform,
	TT_Protect,
	TT_PlaceObject2,
	TT_RemoveObject2,
	TT_DefineShape3,
	TT_DefineText2,
	TT_DefineButton2,
	TT_DefineBitsJPEG3,
	TT_DefineBitsLossless2,
	TT_DefineEditText,
	TT_DefineSprite,
	TT_FrameLabel,
	TT_SoundStreamHead2,
	TT_DefineMorphShape,
	TT_DefineFont2,
	TT_ExportAssets,
	TT_ImportAssets,
	TT_EnableDebugger,
	TT_DoInitAction,
	TT_DefineVideoStream,
	TT_VideoFrame,
	TT_DefineFontInfo2,
	TT_EnableDebugger2,
	TT_ScriptLimits,
	TT_SetTabIndex,
	TT_FileAttributes,
	TT_PlaceObject3,
	TT_ImportAssets2,
	TT_DefineFontAlignZones,
	TT_CSMTextSettings,
	TT_DefineFont3,
	TT_SymbolClass,
	TT_Metadata,
	TT_DefineScalingGrid,
	TT_DoABC,
	TT_DefineShape4,
	TT_DefineMorphShape2,
	TT_DefineSceneAndFrameLabelData,
	TT_DefineBinaryData,
	TT_DefineFontName,
	TT_StartSound2
			  ) with Size => SWF_Tag_Code'Size;

Private

    For Tag_Code_Type Use
      (
	TT_End				=> 0,
	TT_ShowFrame			=> 1,
	TT_DefineShape			=> 2,
	TT_PlaceObject			=> 4,
	TT_RemoveObject			=> 5,
	TT_DefineBits			=> 6,
	TT_DefineButton			=> 7,
	TT_JPEGTables			=> 8,
	TT_SetBackgroundColor		=> 9,
	TT_DefineFont			=> 10,
	TT_DefineText			=> 11,
	TT_DoAction			=> 12,
	TT_DefineFontInfo		=> 13,
	TT_DefineSound			=> 14,
	TT_StartSound			=> 15,
	TT_DefineButtonSound		=> 17,
	TT_SoundStreamHead		=> 18,
	TT_SoundStreamBlock		=> 19,
	TT_DefineBitsLossless		=> 20,
	TT_DefineBitsJPEG2		=> 21,
	TT_DefineShape2			=> 22,
	TT_DefineButtonCxform		=> 23,
	TT_Protect			=> 24,
	TT_PlaceObject2			=> 26,
	TT_RemoveObject2		=> 28,
	TT_DefineShape3			=> 32,
	TT_DefineText2			=> 33,
	TT_DefineButton2		=> 34,
	TT_DefineBitsJPEG3		=> 35,
	TT_DefineBitsLossless2		=> 36,
	TT_DefineEditText		=> 37,
	TT_DefineSprite			=> 39,
	TT_FrameLabel			=> 43,
	TT_SoundStreamHead2		=> 45,
	TT_DefineMorphShape		=> 46,
	TT_DefineFont2			=> 48,
	TT_ExportAssets			=> 56,
	TT_ImportAssets			=> 57,
	TT_EnableDebugger		=> 58,
	TT_DoInitAction			=> 59,
	TT_DefineVideoStream		=> 60,
	TT_VideoFrame			=> 61,
	TT_DefineFontInfo2		=> 62,
	TT_EnableDebugger2		=> 64,
	TT_ScriptLimits			=> 65,
	TT_SetTabIndex			=> 66,
	TT_FileAttributes		=> 69,
	TT_PlaceObject3			=> 70,
	TT_ImportAssets2		=> 71,
	TT_DefineFontAlignZones		=> 73,
	TT_CSMTextSettings		=> 74,
	TT_DefineFont3			=> 75,
	TT_SymbolClass			=> 76,
	TT_Metadata			=> 77,
	TT_DefineScalingGrid		=> 78,
	TT_DoABC			=> 82,
	TT_DefineShape4			=> 83,
	TT_DefineMorphShape2		=> 84,
	TT_DefineSceneAndFrameLabelData	=> 86,
	TT_DefineBinaryData		=> 87,
	TT_DefineFontName		=> 88,
	TT_StartSound2			=> 89
      );

End SWF.Tags;
