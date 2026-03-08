unit uwebCustListForm;

{$IF CompilerVersion < 37.0}
  {$MESSAGE FATAL 'Delphi 13 or newer required for this project.'}
{$ENDIF}

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd, Web.Stencils;

type
  TwebCustListWebStencil = class(TWebModule)
    wsEngineCustList: TWebStencilsEngine;
    WebSessionMgr: TWebSessionManager;
    WebFormsAuthenticator: TWebFormsAuthenticator;
    WebAuthorizer: TWebAuthorizer;
    WebFileDispatcher: TWebFileDispatcher;
    procedure WebModuleCreate(Sender: TObject);
    procedure wsEngineCustListError(Sender: TObject; const AMessage: string);
    procedure WebAuthorizerAuthorize(Sender: TCustomWebAuthorizer; Request: TWebRequest;
                              const User: IWebUser; var Success: Boolean);
    procedure WebFileDispatcherBeforeDispatch(Sender: TObject; const AFileName:
        string; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebFormsAuthenticatorAuthenticate(
      Sender: TCustomWebAuthenticator; Request: TWebRequest; const UserName,
      Password: string; var Roles: string; var Success: Boolean);
    procedure wspLoginBeforeProduce(Sender: TObject);
  private
    // these are NOT accessible by the WebStencilsEngine
    FTitle: string;
    FVersion: string;
    FFullName: string;
    FUserTitle: string;
    FHighestUserRole: string;
    procedure OpenCustomerList;
    procedure EditCustomer(const CustParams: string);
  public
    // these will be available by the WebStencilsEngine parser
    property Title: string read FTitle;
    property Version: string read FVersion;
    property FullName: string read FFullName;
    property UserTitle: string read FUserTitle;
    property HighestUserRole: string read FHighestUserRole write FHighestUserRole;
  end;

var
  WebModuleClass: TComponentClass = TwebCustListWebStencil;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Dialogs, System.IOUtils, System.bindings.EvalProtocol, System.Bindings.Methods,
  udmCust, uLogging;

procedure TwebCustListWebStencil.OpenCustomerList;
begin
  dmCust.qryCustomers.Close;
  dmCust.qryCustomers.Open;
  if not wsEngineCustList.HasVar('CustList') then
    wsEngineCustList.AddVar('CustList', dmCust.qryCustomers, False);
end;

procedure TwebCustListWebStencil.WebAuthorizerAuthorize(Sender:
    TCustomWebAuthorizer; Request: TWebRequest; const User: IWebUser; var
    Success: Boolean);
var
  roleList: TStringList;
begin
  if Assigned(User) then begin
    WebLogger.Add(Format('WebAuthorizer.Authorize.Path=%s, User=%s', [Request.PathInfo, User.UserName]));
    roleList := TStringList.Create;
    try
      roleList.CommaText := User.UserRoles;
      for var i := 0 to roleList.Count - 1 do
        WebLogger.Add('  Role: ' + roleList[i]);
    finally
      roleList.Free;
    end;
  end else begin
    FFullName := EmptyStr;
    FUserTitle := EmptyStr;
    FHighestUserRole := EmptyStr;

    WebLogger.Add('WebAuthorizer.Authorize.Path=' + Request.PathInfo);
  end;
end;

procedure TwebCustListWebStencil.WebModuleCreate(Sender: TObject);
begin
  // web app vars
  FTitle := 'Customer List for WebStencils with Session Management';
  FVersion := '1.1';

  wsEngineCustList.AddVar('App', Self, False);

  {$IFDEF MSWINDOWS}
  // root folder for web templates is 'html' off the executable folder
  wsEngineCustList.RootDirectory := TPath.Combine(ExtractFilePath(ParamStr(0)), 'html');
  {$ELSE}
  {$MESSAGE FATAL 'This demo app was designed for Windows only'}
  {$ENDIF}
end;

procedure TwebCustListWebStencil.EditCustomer(const CustParams: string);
var
  ParamsList: TStringList;
  CustNo: string;
  CustNum: Integer;
begin
  ParamsList := TStringList.Create;
  try
    ParamsList.CommaText := CustParams;
  finally
    ParamsList.Free;
    if ParamsList.Count > 0 then
    begin
      CustNo := ParamsList.Values['cust_no'];
      if TryStrToInt(CustNo, CustNum) then
      begin
        dmCust.OpenCustDetails(CustNum);
        if not wsEngineCustList.HasVar('CustDetails') then
          wsEngineCustList.AddVar('CustDetails', dmCust.qryCustDetails, False);
      end;
    end;
  end;
end;

procedure TwebCustListWebStencil.WebFileDispatcherBeforeDispatch(Sender:
    TObject; const AFileName: string; Request: TWebRequest; Response:
    TWebResponse; var Handled: Boolean);
begin
  if SameText(Request.PathInfo, '/custlist') then
    OpenCustomerList
  else if Request.PathInfo.StartsWith('/custedit', True) then
    EditCustomer(Request.QueryFields.ToString);
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
end;

end.
