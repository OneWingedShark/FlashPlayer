pragma Restrictions (Simple_Barriers);
pragma Restrictions (No_Abort_Statements);
pragma Restrictions (No_Asynchronous_Control);
pragma Restrictions (No_Calendar);
pragma Restrictions (No_Default_Stream_Attributes);
pragma Restrictions (No_Delay);
pragma Restrictions (No_Dynamic_Attachment);
pragma Restrictions (No_Dynamic_Priorities);
pragma Restrictions (No_Entry_Calls_In_Elaboration_Code);
pragma Restrictions (No_Entry_Queue);
pragma Restrictions (No_Exception_Registration);
pragma Restrictions (No_Implicit_Heap_Allocations);
pragma Restrictions (No_Initialize_Scalars);
pragma Restrictions (No_Local_Timing_Events);
pragma Restrictions (No_Local_Protected_Objects);
pragma Restrictions (No_Nested_Finalization);
pragma Restrictions (No_Protected_Type_Allocators);
pragma Restrictions (No_Protected_Types);
pragma Restrictions (No_Relative_Delay);
pragma Restrictions (No_Requeue_Statements);
pragma Restrictions (No_Select_Statements);
pragma Restrictions (No_Specific_Termination_Handlers);
pragma Restrictions (No_Stream_Optimizations);
pragma Restrictions (No_Streams);
pragma Restrictions (No_Task_Allocators);
pragma Restrictions (No_Task_Attributes_Package);
pragma Restrictions (No_Task_Hierarchy);
pragma Restrictions (No_Task_Termination);
pragma Restrictions (No_Tasking);
pragma Restrictions (No_Terminate_Alternatives);
pragma Restrictions (Static_Priorities);
pragma Restrictions (Static_Storage_Size);
pragma Restrictions (Immediate_Reclamation);
pragma Restrictions (No_Implementation_Aspect_Specifications);
--*pragma Restrictions (No_Implementation_Identifiers);
pragma Restrictions (No_Implementation_Restrictions);
--*pragma Restrictions (No_Implementation_Units);
--pragma Restrictions (No_Wide_Characters);
pragma Restrictions (Max_Protected_Entries => 0);
pragma Restrictions (Max_Select_Alternatives => 0);
pragma Restrictions (Max_Task_Entries => 0);
pragma Restrictions (Max_Tasks => 0);
pragma Restrictions (Max_Asynchronous_Select_Nesting => 0);

--

With
Interfaces,
SWF.Types,
SWF,
Ada.Text_IO;
with System;

Procedure Player is
    F : Float:= SWF.Twip'Delta;

    Type SWF_Fixed_Point is record
	Decimal  : Interfaces.Unsigned_16;
	Integral : Interfaces.Integer_16;
    End Record with Size => SWF.Types.Fixed'Size;--, Bit_Order => System.high_Order_First;

--      For SWF_Fixed_Point Use record
--  	Decimal  at 0 range  0..15;
--  	Integral at 0 range 16..31;
--      end record;


    Y : SWF_Fixed_Point := ( Integral => 16#0007#, Decimal => 16#8000# );
    X : SWF.Types.Fixed with Address => Y'Address, Import, Convention => Ada;
    Type K is Range 0..2**32-1 with size => 32;
    Z : K with Address => Y'Address, Import, Convention => Ada;

    Pragma Assert( Y'Size = X'Size );

    Function Image( Input : SWF_Fixed_Point ) Return String is
	Use Interfaces;
	D : Float := Float(Input.Decimal) / Float(16#10000#);
    begin
	declare
	    D_Img : String:= Integer'Image( Integer(D * 10.0**6) );
	begin
	    Return Integer_16'Image( Input.Integral ) & '.' &
	      D_Img(Positive'Succ(D_Img'First)..D_Img'Last);
	end;
    End Image;

    Function Image( Input : SWF.Types.Fixed_8 ) Return String renames
      SWF.Types.Fixed_8'Image;

    Function Image( Input : SWF.Types.Fixed ) Return String renames
      SWF.Types.Fixed'Image;

    Package MIO is new Ada.Text_IO.Integer_IO( K );

	Test_Half : SWF.Types.Half:= (False, 2#00011#, 2#1111111111#);

    NAN_TEST : SWF.Types.Real_32:= SWF.Types.Real_32'Value("0");

Begin
    Ada.Text_IO.Put_Line( "Twip First:" & SWF.Twip'First'Img );
    Ada.Text_IO.Put_Line( "Twip Last:" & SWF.Twip'Last'Img );
    Ada.Text_IO.Put_Line( "Twip Small:" & SWF.Twip'Small'Img );
    Ada.Text_IO.Put_Line( "Twip Delta:" & F'Img );
    Ada.Text_IO.New_Line;
    Ada.Text_IO.Put_Line( "X:" & Image(X) );
    Ada.Text_IO.Put_Line( "Y:" & Image(Y) );
    Ada.Text_IO.Put( "Z: " );
    declare
	Z_Img : String(1..12);
	Subtype Internals is Positive Range Z_Img'First+3..Z_Img'Last-1;
	Hash : Boolean:= false;
    begin
	MIO.Put(Item  => Z, Base  => 16, To => Z_Img);

	for Index in reverse Internals'Range loop
	    Hash:= Hash or Z_Img(Index) = '#';
	    if Hash then
		Z_Img(Index):= '0';
	    end if;
	end loop;
	Z_Img(1..3):= "16#";

	Ada.Text_IO.Put( Z_Img(Internals) );
    end;
    Ada.Text_IO.New_Line(2);

    X:= 10.5;
    Ada.Text_IO.Put_Line( "X`:" & Image(X) );
    Ada.Text_IO.Put_Line( "Y`:" & Image(Y) );

    Ada.Text_IO.Put_Line( "Conv:" &ASCII.HT&
			   SWF.Types.Convert( SWF.Types.Convert(100.0) )'img );
End Player;
