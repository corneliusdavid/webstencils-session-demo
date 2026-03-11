unit uwebCustListBasic;

{$IF CompilerVersion < 37.0}
  {$MESSAGE FATAL 'Delphi 13 or newer required for this project.'}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd, Web.Stencils;

type
  TwebCustListBasic = class(TWebModule)
    wsEngineCustList: TWebStencilsEngine;
    WebBasicAuthenticator: TWebBasicAuthenticator;
    WebAuthorizer: TWebAuthorizer;
    WebFileDispatcher: TWebFileDispatcher;
    WebSessionManager: TWebSessionManager;
    procedure WebModuleCreate(Sender: TObject);
    procedure wsEngineCustListError(Sender: TObject; const AMessage: string);
    procedure WebBasicAuthenticatorAuthenticate(
      Sender: TCustomWebAuthenticator; Request: TWebRequest; const UserName,
      Password: string; var Roles: string; var Success: Boolean);
    procedure WebFileDispatcherBeforeDispatch(Sender: TObject; const AFileName:
        string; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleAfterDispatch(Sender: TObject; Request: TWebRequest;
        Response: TWebResponse; var Handled: Boolean);
    procedure webCustListBasicwaLogoutAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
  private
    // these are NOT accessible by the WebStencilsEngine
    FTitle: string;
    FVersion: string;
    FFullName: string;
    FUserTitle: string;
    FHighestUserRole: string;
    procedure ClearVars;
    procedure OpenCustomerList;
    procedure EditCustomer(const CustNum: Integer);
  public
    // these will be available by the WebStencilsEngine parser
    property Title: string read FTitle;
    property Version: string read FVersion;
    property FullName: string read FFullName;
    property UserTitle: string read FUserTitle;
    property HighestUserRole: string read FHighestUserRole write FHighestUserRole;
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
  FTitle := 'Customer List for WebStencils with Basic Authentication';
  FVersion := '1.2';

  wsEngineCustList.AddVar('App', Self, False);
end;

procedure TwebCustListBasic.ClearVars;
begin
  FFullName := EmptyStr;
  FUserTitle := EmptyStr;
  FHighestUserRole := EmptyStr;
end;

procedure TwebCustListBasic.OpenCustomerList;
begin
  dmCust.qryCustomers.Close;
  dmCust.qryCustomers.Open;
  if not wsEngineCustList.HasVar('CustList') then
    wsEngineCustList.AddVar('CustList', dmCust.qryCustomers, False);
end;

procedure TwebCustListBasic.EditCustomer(const CustNum: Integer);
begin
  dmCust.OpenCustDetails(CustNum);
  if not wsEngineCustList.HasVar('CustDetails') then
    wsEngineCustList.AddVar('CustDetails', dmCust.qryCustDetails, False);
end;

procedure TwebCustListBasic.WebBasicAuthenticatorAuthenticate(
  Sender: TCustomWebAuthenticator; Request: TWebRequest; const UserName,
  Password: string; var Roles: string; var Success: Boolean);
begin
  ClearVars;
  Roles := EmptyStr;

  Success := dmCust.LoginCheck(Username, Password);
  if Success then begin
    FFullName := dmCust.EmployeeFirstName + ' ' + dmCust.EmployeeLastName;
    FUserTitle := dmCust.EmployeeTitle;
    if Pos('MANAGER', UpperCase(FUserTitle)) > 0 then begin
      Roles := 'viewer,editor,manager';
      FHighestUserRole := 'manager';
    end
    else if (Pos('IT', UpperCase(FUserTitle)) > 0) then begin
      Roles := 'viewer,editor';
      FHighestUserRole := 'editor';
    end else begin
      Roles := 'viewer';
      FHighestUserRole := 'viewer';
    end;
  end;
end;

procedure TwebCustListBasic.webCustListBasicwaLogoutAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
  Response.StatusCode := 401;
  Handled := True;
end;

procedure TwebCustListBasic.WebFileDispatcherBeforeDispatch(Sender: TObject;
    const AFileName: string; Request: TWebRequest; Response: TWebResponse; var
    Handled: Boolean);
begin
  if SameText(Request.PathInfo, '/custlist') then
    OpenCustomerList
  else if Request.PathInfo.StartsWith('/custedit', True) then
    EditCustomer(Request.QueryFields.Values['cust_no'].ToInteger);
end;

procedure TwebCustListBasic.WebModuleAfterDispatch(Sender: TObject; Request:
    TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  // This code works around a bug in Web.HTTPApp to get the Web Browser to prompt for the user credentials
  if Response.StatusCode = 401 then
    begin
      // InternalSentinel used CustomHeaders.Add() which corrupts the value via
      // TStrings name=value parsing (splits on '=' in the challenge string).
      // Clear the malformed entry and set via the WWWAuthenticate property instead,
      // which goes through FormatAuthenticate -> AddHeaderItem (no TStrings parsing).
      Response.CustomHeaders.Clear;
      Response.WWWAuthenticate := 'Basic realm="' + WebBasicAuthenticator.Realm + '", charset="UTF-8"';
    end;
end;

procedure TwebCustListBasic.wsEngineCustListError(Sender: TObject; const AMessage: string);
begin
  WebLogger.Add('WebEngine ERROR: ' + AMessage);
end;

end.
