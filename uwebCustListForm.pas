unit uwebCustListForm;

{$IF CompilerVersion < 37.0}
  {$MESSAGE FATAL 'Delphi 13 or newer required for this project.'}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd, Web.Stencils;

type
  TwebCustListWebStencil = class(TWebModule)
    wspIndex: TWebStencilsProcessor;
    wsEngineCustList: TWebStencilsEngine;
    wspLoginFailed: TWebStencilsProcessor;
    wspCustList: TWebStencilsProcessor;
    wspCustEdit: TWebStencilsProcessor;
    wspLogin: TWebStencilsProcessor;
    WebSessionMgr: TWebSessionManager;
    WebFormsAuthenticator: TWebFormsAuthenticator;
    procedure WebModuleCreate(Sender: TObject);
    procedure webCustListWebStencilwaListCustomersAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure webCustListWebStencilwaEditCustomerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wsEngineCustListError(Sender: TObject; const AMessage: string);
    procedure WebFormsAuthenticatorAuthenticate(
      Sender: TCustomWebAuthenticator; Request: TWebRequest; const UserName,
      Password: string; var Roles: string; var Success: Boolean);
    procedure WebSessionMgrIdGenerate(Sender: TCustomWebSessionManager; Request:
        TWebRequest; const User: IWebUser; var SessionId: string);
    procedure WebSessionMgrValidate(Sender: TCustomWebSessionManager; Request:
        TWebRequest; var Session: TWebSession; var Status: TWebSessionStatus);
    procedure wspLoginBeforeProduce(Sender: TObject);
  private
    // these are NOT accessible by the WebStencilsEngine
    FTitle: string;
    FVersion: string;
    FFullName: string;
    FUserTitle: string;
    FHighestUserRole: string;
    FIsHome: Boolean;
    FUsesFormLogin: Boolean;
  public
    // these will be available by the WebStencilsEngine parser
    property Title: string read FTitle;
    property Version: string read FVersion;
    property FullName: string read FFullName;
    property UserTitle: string read FUserTitle;
    property HighestUserRole: string read FHighestUserRole write FHighestUserRole;
    property IsHome: Boolean read FIsHome;
    property UsesFormLogin: Boolean read FUsesFormLogin;
  end;

var
  WebModuleClass: TComponentClass = TwebCustListWebStencil;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Dialogs, System.IOUtils, System.bindings.EvalProtocol, System.Bindings.Methods,
  udmCust, uLogging;

procedure TwebCustListWebStencil.WebModuleCreate(Sender: TObject);
begin
  // web app vars
  FTitle := 'Customer List for WebStencils with Session Management';
  FVersion := '1.0';
  FIsHome := True;
  FUsesFormLogin := True;

  wsEngineCustList.AddVar('App', Self, False);

  {$IFDEF MSWINDOWS}
  // root folder for web templates is 'html' off the executable folder
  wsEngineCustList.RootDirectory := TPath.Combine(ExtractFilePath(ParamStr(0)), 'html');
  dmCust.ConnectDB(ExtractFilePath(ParamStr(0)));
  {$ELSE}
  {$MESSAGE FATAL 'This demo app was designed for Windows only'}
  {$ENDIF}
end;

procedure TwebCustListWebStencil.webCustListWebStencilwaListCustomersAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
  dmCust.qryCustomers.Open;
  try
    if not wsEngineCustList.HasVar('CustList') then
      wsEngineCustList.AddVar('CustList', dmCust.qryCustomers, False);
    try
      Response.Content := wspCustList.Content;
    except
      on E:EWebNotAuthenticated do
        Response.Content := wspLoginFailed.Content;
    end;
  finally
    dmCust.qryCustomers.Close;
  end;
end;

procedure TwebCustListWebStencil.webCustListWebStencilwaEditCustomerAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  CustNo: string;
  CustNum: Integer;
begin
  if Request.QueryFields.Count > 0 then
  begin
    CustNum := Request.QueryFields.Values['cust_no'].ToInteger;
    dmCust.OpenCustDetails(CustNum);
    if not wsEngineCustList.HasVar('CustDetails') then
      wsEngineCustList.AddVar('CustDetails', dmCust.qryCustDetails, False);
    try
      try
        Response.Content := wspCustEdit.Content;
      except
        on E:EWebNotAuthenticated do
          Response.Content := wspLoginFailed.Content;
      end;
    finally
      dmCust.CloseCustDetails;
    end;
  end;
end;

procedure TwebCustListWebStencil.WebFormsAuthenticatorAuthenticate(
  Sender: TCustomWebAuthenticator; Request: TWebRequest; const UserName,
  Password: string; var Roles: string; var Success: Boolean);
begin
  FFullName := EmptyStr;
  FUserTitle := EmptyStr;
  Roles := EmptyStr;
  FHighestUserRole := EmptyStr;

  Success := dmCust.LoginCheck(Username, Password);
  if Success then begin
    FFullName := dmCust.EmployeeFirstName + ' ' + dmCust.EmployeeLastName;
    FUserTitle := dmCust.EmployeeTitle;
    if Pos('MANAGER', UpperCase(FUserTitle)) > 0 then begin
      Roles := 'manager,editor,viewer';
      FHighestUserRole := 'manager';
    end
    else if (Pos('IT', UpperCase(FUserTitle)) > 0) then begin
      Roles := 'editor,viewer';
      FHighestUserRole := 'editor';
    end else begin
      Roles := 'viewer';
      FHighestUserRole := 'viewer';
    end;

    FIsHome := False;
  end;
end;

procedure TwebCustListWebStencil.WebSessionMgrIdGenerate(Sender: TCustomWebSessionManager;
    Request: TWebRequest; const User: IWebUser; var SessionId: string);
begin
  if Assigned(User) then
    WebLogger.Add(Format('WebSessionMgr generated ID [%s] for user [%s]',
                         [SessionID, User.UserName]))
  else
    WebLogger.Add(Format('WebSessionMgr generated ID [%s]', [SessionID]));
end;

procedure TwebCustListWebStencil.WebSessionMgrValidate(Sender:
    TCustomWebSessionManager; Request: TWebRequest; var Session: TWebSession;
    var Status: TWebSessionStatus);
begin
  if Assigned(Session) then
    WebLogger.Add(Format('WebSessionMgr.OnValidate: Request: [%s], SessionId: [%s]',
                         [Request.PathInfo, Session.Id]))
  else
    WebLogger.Add(Format('WebSessionMgr.OnValidate: Request: [%s]',
                         [Request.PathInfo]));
end;

procedure TwebCustListWebStencil.wsEngineCustListError(Sender: TObject; const AMessage: string);
begin
  WebLogger.Add('WebEngine ERROR: ' + AMessage);
end;

procedure TwebCustListWebStencil.wspLoginBeforeProduce(Sender: TObject);
begin
  // clear our our local variables
  FFullName := EmptyStr;
  FUserTitle := EmptyStr;
  FHighestUserRole := EmptyStr;
  FIsHome := True;
end;

end.
