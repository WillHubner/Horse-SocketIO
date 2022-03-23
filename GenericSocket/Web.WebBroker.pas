{*******************************************************}
{                                                       }
{                Delphi Runtime Library                 }
{                                                       }
{ Copyright(c) 1995-2019 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

{ *************************************************************************** }
{                                                                             }
{ Licensees holding a valid Borland No-Nonsense License for this Software may }
{ use this file in accordance with such license, which appears in the file    }
{ license.txt that came with this Software.                                   }
{                                                                             }
{ *************************************************************************** }

{$HPPEMIT LEGACYHPP}

unit Web.WebBroker;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Web.WebReq;

type
  TServerExceptionEvent = procedure (E: Exception; wr: TWebResponse) of object;
  TUnloadProc = procedure;

  TWebApplication = class(TWebRequestHandler)
  private
    FTitle: string;
    FUnloadProc: TUnloadProc;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateForm(InstanceClass: TComponentClass; var Reference); virtual;
    procedure Initialize; virtual;
    procedure Run; virtual;
    property Title: string read FTitle write FTitle;
    /// <summary>This events raises when the module is detached from the server.</summary>
    property OnUnload: TUnloadProc read FUnloadProc write FUnloadProc;
  end;

var
  Application: TWebApplication = nil;

type
  THandleShutdownException = procedure(E: Exception);

{ HandleShutdownException is defined as the last point for the developer to
  analyze exceptions which are occur on shutdown of the application.
  This function should only be called under abnormal cirrcumstances and is
  provided to help the developer diagnose what exception occured.  To use
  this functionality simply define a function with the same signature as
  THandleShutdownException and then set the variable HandleShutdownException
  to your function.  For example, in your function you could write the text
  of the exception to a text file. }

var
  HandleShutdownException: THandleShutdownException;

implementation

uses
{$IFDEF MSWINDOWS}
  Winapi.Windows,
{$ENDIF}
  Web.BrkrConst;

{ TWebApplication }

var
  OldDllProc: TDLLProc;

procedure DoneVCLApplication;
begin
  try
    if Assigned(Application.OnUnload) then
      Application.OnUnload;

    Application.Free;
    Application := nil;
  except
    on E:Exception do
      if Assigned(HandleShutdownException) then
      begin
        Application := nil;  // Application of no use at this point so clear it
        System.Classes.ApplicationHandleException := nil;
        HandleShutdownException(E);
      end;
  end;
end;

procedure DLLExitProc(Reason: Integer);
begin
{$IFDEF MSWINDOWS}
  if Reason = DLL_PROCESS_DETACH then
    DoneVCLApplication;
{$ENDIF}
{$IFDEF POSIX}
  if Reason = 0 then
    DoneVCLApplication;
{$ENDIF}
  if Assigned(OldDllProc) then
    OldDllProc(Reason);
end;

function WebRequestHandler: TWebRequestHandler;
begin
  Result := Application;
end;

constructor TWebApplication.Create(AOwner: TComponent);
begin
  Web.WebReq.WebRequestHandlerProc := WebRequestHandler;
  inherited Create(AOwner);

  System.Classes.ApplicationHandleException := HandleException;
  if IsLibrary then
  begin
    IsMultiThread := True;
    OldDllProc := DLLProc;
    DLLProc := DLLExitProc;
  end
  else
    AddExitProc(DoneVCLApplication);
end;

destructor TWebApplication.Destroy;
begin
  System.Classes.ApplicationHandleException := nil;
  inherited Destroy;
end;

procedure TWebApplication.CreateForm(InstanceClass: TComponentClass;
  var Reference);
begin
  // Support CreateForm for backward compatability with D3, D4, and
  // D5 web modules.  D6 generated web modules register a factory.
  if WebModuleClass = nil then
    WebModuleClass := InstanceClass
  else if WebModuleClass <> InstanceClass then
    raise Exception.CreateRes(@sOnlyOneDataModuleAllowed);
end;

procedure TWebApplication.Initialize;
begin
  // This is a place holder
  if InitProc <> nil then TProcedure(InitProc);
end;

procedure TWebApplication.Run;
begin
end;

end.
