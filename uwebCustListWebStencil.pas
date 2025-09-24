unit uwebCustListWebStencil;

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
    wspAccessDenied: TWebStencilsProcessor;
    wspCustEdit: TWebStencilsProcessor;
    wspLogin: TWebStencilsProcessor;
    WebSessionManager1: TWebSessionManager;
    WebFormsAuthenticator1: TWebFormsAuthenticator;
    WebAuthorizer1: TWebAuthorizer;
    procedure WebModuleCreate(Sender: TObject);
    procedure webCustListWebStencilwaListCustomersAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure webCustListWebStencilwaEditCustomerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wsEngineCustListError(Sender: TObject; const AMessage: string);
    procedure WebSessionMgrCreated(Sender: TCustomWebSessionManager;
      Request: TWebRequest; Session: TWebSession);
    procedure WebSessionMgrAcquire(Sender: TCustomWebSessionManager;
      Request: TWebRequest; Session: TWebSession);
    procedure WebFormsAuthenticator1Authenticate(
      Sender: TCustomWebAuthenticator; Request: TWebRequest; const UserName,
      Password: string; var Roles: string; var Success: Boolean);
    procedure webCustListWebStencilwaLogoutAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    // these are NOT accessible by the WebStencilsEngine
    FVersion: string;
    FTitle: string;
    FFullName: string;
    FJobTitle: string;
  public
    // these will be available by the WebStencilsEngine parser
    property Title: string read FTitle write FTitle;
    property Version: string read FVersion write FVersion;
    property FullName: string read FFullName write FFullName;
    property JobTitle: string read FJobTitle write FJobTitle;
  end;

var
  WebModuleClass: TComponentClass = TwebCustListWebStencil;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Dialogs, System.IOUtils, System.bindings.EvalProtocol, System.Bindings.Methods,
  udmCust, uLogging;

procedure TwebCustListWebStencil.webCustListWebStencilwaEditCustomerAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  CustNo: string;
  CustNum: Integer;
begin
  if Request.QueryFields.Count > 0 then
  begin
    CustNo := Request.QueryFields.Values['cust_no'];
    if TryStrToInt(CustNo, CustNum) then
    begin
      dmCust.OpenCustDetails(CustNum);
      if not wsEngineCustList.HasVar('CustDetails') then
        wsEngineCustList.AddVar('CustDetails', dmCust.qryCustDetails, False);
      try
        Response.Content := wspCustEdit.Content;
      except
        on E:EWebNotAuthenticated do
          Response.Content := wspAccessDenied.Content;
      end;
      dmCust.CloseCustDetails;
    end;
  end;
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
        Response.Content := wspAccessDenied.Content;
    end;
  finally
    dmCust.qryCustomers.Close;
  end;
end;

procedure TwebCustListWebStencil.webCustListWebStencilwaLogoutAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  LSession: TWebSession;
begin
  if Assigned(Request) then
    LSession := Request.Session;

  if Assigned(LSession) then
    LSession.Login(nil);

  Response.SendRedirect('/');
end;

procedure TwebCustListWebStencil.WebFormsAuthenticator1Authenticate(
  Sender: TCustomWebAuthenticator; Request: TWebRequest; const UserName,
  Password: string; var Roles: string; var Success: Boolean);
begin
  Success := dmCust.LoginCheck(Username, Password);
  if Success then
    FFullName := dmCust.EmployeeFirstName + ' ' + dmCust.EmployeeLastName;
    FJobTitle := dmCust.EmployeeTitle;
end;

procedure TwebCustListWebStencil.WebModuleCreate(Sender: TObject);
begin
  FTitle := 'Customer List for WebStencils with Session Management';
  FVersion := '0.7';
  wsEngineCustList.AddVar('App', Self, False);
  wsEngineCustList.RootDirectory := TPath.Combine(ExtractFilePath(ParamStr(0)), 'html');
  for var i := 0 to ComponentCount - 1 do begin
    if Components[i] is TWebStencilsProcessor then
      TWebStencilsProcessor(Components[i]).InputFileName := TPath.Combine(
        wsEngineCustList.RootDirectory, TWebStencilsProcessor(Components[i]).InputFileName);
  end;

end;

procedure TwebCustListWebStencil.WebSessionMgrAcquire(Sender: TCustomWebSessionManager;
  Request: TWebRequest; Session: TWebSession);
begin
  WebLogger.Add('WebSessionMgr acquired a session');
end;

procedure TwebCustListWebStencil.WebSessionMgrCreated(Sender: TCustomWebSessionManager;
  Request: TWebRequest; Session: TWebSession);
begin
  WebLogger.Add('WebSessionMgr was created');
end;

procedure TwebCustListWebStencil.wsEngineCustListError(Sender: TObject; const AMessage: string);
begin
  WebLogger.Add('WebEngine ERROR: ' + AMessage);
  ShowMessage(AMessage);
end;

end.
