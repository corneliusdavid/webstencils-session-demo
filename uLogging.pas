unit uLogging;

interface

uses
  Classes;

type
  TWebLogger = class
  private
    FLogFilePath: string;
    FLogFileBase: string;
    FLogFilename: string;
    FLogWriter: TStreamWriter;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const LogMsg: string);
    property LogFilename: string read FLogFilename;
  end;

var
  WebLogger: TWebLogger;

implementation

uses
  SysUtils, IOUtils;

{ TWebLogger }

procedure TWebLogger.Add(const LogMsg: string);
begin
  FLogWriter.WriteLine(FormatDateTime('yyyy-mm-dd hh:nn:ss  ', Now) + LogMsg);
end;

constructor TWebLogger.Create;
begin
  FLogFilePath := TPath.GetPublicPath;
  FLogFileBase := 'WebLog_' + FormatDateTime('yyyy_mm_dd', Date);
  FLogFilename := TPath.Combine(FLogFilePath, FLogFileBase + '.log');

  FLogWriter := TStreamWriter.Create(FLogFilename, True);
  Add('v----------startup----------v');
end;

destructor TWebLogger.Destroy;
begin
  Add('^----------shutdown----------^');
  FLogWriter.Free;
  inherited;
end;

initialization
  WebLogger := TWebLogger.Create;
finalization
  WebLogger.Free;
end.
