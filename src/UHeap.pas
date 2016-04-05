{*******************************************************************************
 *Author: Justin Swett
 *Email:  jswett@borland.com
 *
 *THeap:
 *An ADT that manages a Heap of Items.
 *Requires that client/user of the heap
 *provide a comparison function, CMP, that returns an
 *integer.  Size will grow dynamically as more items
 *are inserted into the heap...
 *
 *Operations
 *  Insert: Adds an item to heap. Items are responsible
 *          for allocating and freeing their own memory.
 *  Pop:    Returns "Priority Item" from the Heap. This item
 *          will no longer remain in the heap.
 *Properties
 *  Priorirty: Returns a pointer to the "Priority Item" in
 *             the Heap. This item will remain in the heap do not free memory
 *  Count:     Number of items currently in the heap returns -1 if empty
 *  Capacity:  Max size of heap...
 *
 *  DumpPointers:  Used for debugging.  Could be removed.  
 *
 *******************************************************************************}

unit UHeap;

interface

uses
  sysutils, classes;

type

  HeapItem = Pointer;
  HeapArr = array of HeapItem;


  //function to return a comparison result between ItemA and ItemB
  //returns 0 if equal, 1 if ItemA > ItemB, -1 if ItemA < ItemB
  CMP_FUNC = function( ItemA, ItemB: HeapItem ): Integer;

  EHeapException = Exception;
  ENoCMPFunc = EHeapException;

  THeapType = ( hMax, hMin );

  THeap = class(TObject)
  private
    fDim: Cardinal;
    fNextIndex: Cardinal;
    fBuckets: HeapArr;
    fCompare: CMP_FUNC;
    fHeapType: THeapType;
    procedure BucketResize( newDim: Cardinal );
    procedure SetDim( aDim: Cardinal );
    procedure SwapItems(  A, B: Cardinal );
    procedure SetHeapType( aType: THeapType );
    procedure FixHeapUp;   //Called after inserts
    procedure FixHeapDown; //Called after pops...
    function GetPriority: HeapItem;
    function GetCount: Cardinal;
  public
    constructor Create;
    destructor Destroy; override;
    procedure DunmpPointers( AList: TStrings ); //used for debuging purposes only...
    procedure Insert( AItem : HeapItem );
    function Pop: HeapItem;
    property Compare: CMP_FUNC read fCompare write fCompare;
    property HeapType: THeapType read fHeapType write SetHeapType;
    property Priority: HeapItem read GetPriority;
    property Count: Cardinal read GetCount;
  end;

const
  RootIndex = 0;
  NO_CMP_FUNC = 'Compare function required for this operation';


implementation

{ THeap }

procedure THeap.BucketResize(newDim: Cardinal);
var
  itor: Cardinal;
  tempBuckets: HeapArr;
begin
  //Make temporary array and init to NIL
  SetLength( tempBuckets, newDim );
  for itor := 0 to newDim - 1 do
    tempBuckets[itor] := nil;
  //if existing buckets the copy over old pointers...
  if fDim > 0 then
    for itor := 0 to fDim - 1 do
      tempBuckets[itor] := fBuckets[itor];
  fBuckets := nil;
  fBuckets := tempBuckets;
end;

constructor THeap.Create;
begin
  fDim := 0;
  fNextIndex := 0;
  fHeapType := hMax;
end;

//Assures that the new parent is the proper parent may need to swap down
destructor THeap.Destroy;
begin
  fBuckets := nil;
  inherited;
end;

procedure THeap.DunmpPointers(AList: TStrings);
var
  i:integer;
begin
  for i := 1 to fNextIndex - 1 do
    AList.Add(Format('%2d : %3d : $%4s', [i, i div 2, IntToHex(Integer(fBuckets[i]),3)] ));
end;

procedure THeap.FixHeapDown;
var
  parentIndex, childIndex: Cardinal;
  child, parent: HeapItem;
begin
  parentIndex := 1;
  if fHeapType = hMax then
  begin
    while (parentIndex <= fNextIndex) do
    begin
      if 2*parentIndex < fNextIndex then
      begin
        parent := fBuckets[parentIndex];
        //determine which one is the child and set it...
        if (2*parentIndex + 1) >= fNextIndex then
          childIndex := 2*parentIndex
        else if Compare( fBuckets[2*parentIndex], fbuckets[2*parentIndex + 1] ) > 0 then
          childIndex := 2*parentIndex
        else
          childIndex := 2*parentIndex + 1;
        child := fBuckets[ childIndex ];
        if Compare(child,parent) > 0 then //swap if necissary otherwise exit
        begin
          SwapItems(childIndex,parentIndex);
          parentIndex := childIndex;
          Continue;
        end
        else
          Exit;
      end
      else
        Exit;
    end;
  end
  //otherwise it's a min heap...  seems a bit redundant...
  else
   begin
    while (parentIndex <= fNextIndex) do
    begin
      if 2*parentIndex < fNextIndex then
      begin
        parent := fBuckets[parentIndex];
        //determine which one is the child and set it...
        if (2*parentIndex + 1) >= fNextIndex then
          childIndex := 2*parentIndex
        else if Compare( fBuckets[2*parentIndex], fbuckets[2*parentIndex + 1] ) < 0 then
          childIndex := 2*parentIndex
        else
          childIndex := 2*parentIndex + 1;
        child := fBuckets[ childIndex ];
        if Compare(child,parent) < 0 then //swap if necissary otherwise exit
        begin
          SwapItems(childIndex,parentIndex);
          parentIndex := childIndex;
          Continue;
        end
        else
          exit;
      end
      else
        exit;
    end;
  end;
end;

procedure THeap.FixHeapUp;
var
  childIndex: Cardinal;
  child, parent: HeapItem;
begin
  childIndex := fNextIndex; //fNextIndex hasn't been updated yet so it currently points to child
  while childIndex > 1 do //if equeal to one then we are done
  begin
    child := fBuckets[childIndex];
    parent := fBuckets[childIndex div 2];  //is ok since childIndex > 1

    if (HeapType = hMax) and (Compare(child, parent) > 0) then
      SwapItems(childIndex, childIndex div 2)
    else if (HeapType = hMin) and (Compare(child, parent) < 0) then
      SwapItems(childIndex, childIndex div 2)
    else if Compare(child, parent) = 0 then
      exit;
    //else they are equal and in either case neither needs to move.

    childIndex := childIndex div 2;
  end;
end;

function THeap.GetCount: Cardinal;
begin
  Result := fNextIndex - 1;
end;

function THeap.GetPriority: HeapItem;
begin
  if fDim >= 1 then
    Result := fBuckets[1]
  else
    Result := nil;
end;

procedure THeap.Insert(AItem: HeapItem);
begin
  if not assigned(Compare) then
    raise ENoCMPFunc.Create(NO_CMP_FUNC);
  //if this is the first time to insert then need to initialize an array
  if fDim = 0 then
  begin
    SetDim( 4 );
    fNextIndex := 1;
  end;
  
  if fNextIndex = fDim then //make sure there is room in heap for new item
    SetDim( fDim * 2 );
  fBuckets[fNextIndex] := AItem;  //then insert item into array
  FixHeapUp;
  Inc(fNextIndex);
  // no insert stuff yeah yeah!
end;

function THeap.Pop: HeapItem;
begin
  Result := nil;
  if fNextIndex > 1 then
  begin
    Dec(fNextIndex);
    Result := fBuckets[1];
    fBuckets[1] := fBuckets[fNextIndex];
    fBuckets[fNextIndex] := nil;
    FixHeapDown;
  end;
end;

procedure THeap.SetDim(aDim: Cardinal);
begin
  if aDim > fDim then
  begin
    BucketResize( aDim );
    fDim := aDim;
  end;
end;

procedure THeap.SetHeapType(aType: THeapType);
var
  temp: HeapArr;
  itor: Integer;
  oldNext: Integer;
begin
  temp := nil;
  if aType <> fHeapType then
  begin
    temp := fBuckets;
    SetLength( fBuckets, fDim );
    for itor := 0 to fDim - 1 do
      fBuckets[itor] := nil;
    oldNext := fNextIndex;
    fNextIndex := 1;
    fHeapType := aType;
    for itor:=1 to oldNext - 1 do
      Insert(temp[itor]);
    temp := nil;
  end;
end;

procedure THeap.SwapItems(A, B: Cardinal);
var
  swap: HeapItem;
begin
  swap := fBuckets[A];
  fBuckets[A] := fBuckets[B];
  fBuckets[B] := swap;
end;

end.
