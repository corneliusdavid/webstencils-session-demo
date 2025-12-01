unit uwebCustListBasic;

{$IF CompilerVersion < 37.0}
  {$MESSAGE FATAL 'Delphi 13 or newer required for this project.'}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd, Web.Stencils;

type
  TwebCustListBasic = class(TWebModule)
    wspIndex: TWebStencilsProcessor;
    wsEngineCustList: TWebStencilsEngine;
    wspLoginFailed: TWebStencilsProcessor;
    wspCustList: TWebStencilsProcessor;
    wspCustEdit: TWebStencilsProcessor;
    WebBasicAuthenticator: TWebBasicAuthenticator;
    WebBasicAuthorizer: TWebAuthorizer;
    procedure WebModuleCreate(Sender: TObject);
    procedure webCustListWebStencilwaListCustomersAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure webCustListWebStencilwaEditCustomerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure wsEngineCustListError(Sender: TObject; const AMessage: string);
    procedure WebBasicAuthenticatorAuthenticate(
      Sender: TCustomWebAuthenticator; Request: TWebRequest; const UserName,
      Password: string; var Roles: string; var Success: Boolean);
    procedure webCustListWebStencilwaLogoutAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    // these are NOT accessible by the WebStencilsEngine
    FTitle: string;
    FFullName: string;
    FVersion: string;
    FUserTitle: string;
    FIsHome: Boolean;
    FUsesFormLogin: Boolean;
  public
    // these will be available by the WebStencilsEngine parser
    property Title: string read FTitle;
    property Version: string read FVersion;
    property FullName: string read FFullName;
    property UserTitle: string read FUserTitle;
    property IsHome: Boolean read FIsHome;
    property UsesFormLogin: Boolean read FUsesFormLogin;
  end;

var
  WebModuleClass: TComponentClass = TwebCustListBasic;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Dialogs, System.IOUtils, System.bindings.EvalProtocol, System.Bindings.Methods,
  udmCust, uLogging;

procedure TwebCustListBasic.WebModuleCreate(Sender: TObject);
begin
  // web app vars
  FTitle := 'Customer List for WebStencils with Session Management';
  FVersion := '0.6';
  FIsHome := True;
  FUsesFormLogin := False;

  wsEngineCustList.AddVar('App', Self, False);

  // html paths
  wsEngineCustList.RootDirectory := TPath.Combine(ExtractFilePath(ParamStr(0)), 'html');
  for var i := 0 to ComponentCount - 1 do begin
    if Components[i] is TWebStencilsProcessor then
      TWebStencilsProcessor(Components[i]).InputFileName := TPath.Combine(
        wsEngineCustList.RootDirectory, TWebStencilsProcessor(Components[i]).InputFileName);
  end;
end;

procedure TwebCustListBasic.webCustListWebStencilwaEditCustomerAction(Sender: TObject; Request: TWebRequest;
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

procedure TwebCustListBasic.webCustListWebStencilwaListCustomersAction(Sender: TObject; Request: TWebRequest;
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

procedure TwebCustListBasic.webCustListWebStencilwaLogoutAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
begin
  if Assigned(Request) then begin
    var LSession := Request.Session;

    if Assigned(LSession) then
      LSession.Login(nil);
  end;

  Response.SendRedirect('/');
end;

procedure TwebCustListBasic.WebBasicAuthenticatorAuthenticate(
  Sender: TCustomWebAuthenticator; Request: TWebRequest; const UserName,
  Password: string; var Roles: string; var Success: Boolean);
begin
  FFullName := EmptyStr;
  FTitle := EmptyStr;
  Roles := EmptyStr;

  Success := dmCust.LoginCheck(Username, Password);
  if Success then begin
    FFullName := dmCust.EmployeeFirstName + ' ' + dmCust.EmployeeLastName;
    FUserTitle := dmCust.EmployeeTitle;

    Roles := 'viewer';
  end;
end;

procedure TwebCustListBasic.wsEngineCustListError(Sender: TObject; const AMessage: string);
begin
  WebLogger.Add('WebEngine ERROR: ' + AMessage);
  ShowMessage(AMessage);
end;

end.
