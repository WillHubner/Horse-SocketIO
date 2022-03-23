unit GenericSocket.Message;

interface

uses
  GenericSocket.Interfaces,
  System.JSON;

type
  TSocketMessage = Class(TInterfacedObject, iSocketMessage)
  private
    FTitle : String;
    FBody : TJSONValue;
  public
    constructor Create;
    destructor Destroy; override;

    class function New : iSocketMessage; overload;
    class function New(vParam : String) : iSocketMessage; overload;

    function Title(vTitle : String) : iSocketMessage;
    function Body(vBody : TJSONValue) : iSocketMessage;
    function GetTitle : String;
    function JSONValue : TJSONValue;
  End;

implementation

{ TSocketMessage }

function TSocketMessage.Body(vBody : TJSONValue) : iSocketMessage;
begin
  Result := Self;
  FBody := TJSONObject.ParseJSONValue( vBody.ToJSON );
end;

constructor TSocketMessage.Create;
begin

end;

destructor TSocketMessage.Destroy;
begin
  FBody.Free;

  inherited;
end;

function TSocketMessage.GetTitle: String;
begin
  Result := FTitle;
end;

class function TSocketMessage.New: iSocketMessage;
begin
  Result := Self.Create;
end;

class function TSocketMessage.New(vParam: String): iSocketMessage;
var
  vJSONParam : TJSONObject;
begin
  Result := Self.New;

  vJSONParam := TJSONObject.ParseJSONValue(vParam) as TJSONObject;

  try
    Result
      .Title(vJSONParam.GetValue<String>('title'))
      .Body(vJSONParam.GetValue<TJSONValue>('body'));
  finally
    vJSONParam.Free;
  end;
end;

function TSocketMessage.Title(vTitle: String): iSocketMessage;
begin
  FTitle := vTitle;
  Result := Self;
end;

function TSocketMessage.JSONValue: TJSONValue;
begin
  Result := FBody;
end;

end.
