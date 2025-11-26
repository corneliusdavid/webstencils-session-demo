program CustListFormsSessions;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  ufrmCustListForm in 'ufrmCustListForm.pas' {Form2},
  uwebCustListForm in 'uwebCustListForm.pas' {webCustListWebStencil: TWebModule},
  udmCust in 'udmCust.pas' {dmCust: TDataModule},
  uLogging in 'uLogging.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TdmCust, dmCust);
  Application.Run;
end.
