With
Ada.Containers.Ordered_Maps,
SWF.Tags;

Package SWF.Dictionary is

    Type Character is tagged private;
    --Function ID( Object : Character ) Return Natural;


    Type Dictionary_Type is limited private tagged  and Ada.Iterator_Interfaces.Forward_Iterator;


Private
    Type Character is tagged null record;


    Package Internal_Dictionary is new Ada.Containers.Ordered_Maps
      ( Key_Type => Positive, Element_Type => Character );

    Type Dictionary_Type Is not null access Internal_Dictionary.Map;


End SWF.Dictionary;
