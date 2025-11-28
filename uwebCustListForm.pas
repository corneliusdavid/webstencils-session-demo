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
    procedure webCustListWebStencilwaLogoutAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebSessionMgrIdGenerate(Sender: TCustomWebSessionManager; Request:
        TWebRequest; const User: IWebUser; var SessionId: string);
    procedure WebSessionMgrValidate(Sender: TCustomWebSessionManager; Request:
        TWebRequest; var Session: TWebSession; var Status: TWebSessionStatus);
  private
    // these are NOT accessible by the WebStencilsEngine
    FFullName: string;
    FUserTitle: string;
    FVersion: string;
    FTitle: string;
    FCanEdit: Boolean;
    FIsMgr: Boolean;
    FIsHome: Boolean;
    FUsesFormLogin: Boolean;
  public
    // these will be available by the WebStencilsEngine parser
    property Title: string read FTitle;
    property Version: string read FVersion;
    property FullName: string read FFullName;
    property UserTitle: string read FUserTitle;
    property CanEdit: Boolean read FCanEdit write FCanEdit;
    property IsMgr: Boolean read FIsMgr write FIsMgr;
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
  FVersion := '0.7';
  FIsHome := True;
  FUsesFormLogin := True;

  wsEngineCustList.AddVar('App', Self, False);

  // html paths
  wsEngineCustList.RootDirectory := TPath.Combine(ExtractFilePath(ParamStr(0)), 'html');
  for var i := 0 to ComponentCount - 1 do begin
    if Components[i] is TWebStencilsProcessor then
      TWebStencilsProcessor(Components[i]).InputFileName := TPath.Combine(
        wsEngineCustList.RootDirectory, TWebStencilsProcessor(Components[i]).InputFileName);
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
          Response.Content := wspLoginFailed.Content;
      end;
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

  Success := dmCust.LoginCheck(Username, Password);
  if Success then begin
    FFullName := dmCust.EmployeeFirstName + ' ' + dmCust.EmployeeLastName;
    FUserTitle := dmCust.EmployeeTitle;
    FIsMgr := Pos('MANAGER', UpperCase(FUserTitle)) > 0;
    FCanEdit := FIsMgr or (Pos('IT', UpperCase(FUserTitle)) > 0);
    FIsHome := False;

    //Roles := if FIsMgr then 'mgr' else if FCanEdit then 'IT' else EmptyStr;
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

  FFullName := EmptyStr;
  FUserTitle := EmptyStr;
  FCanEdit := False;
  FIsMgr := False;

  FIsHome := True;
  Response.SendRedirect('/');
end;

end.
