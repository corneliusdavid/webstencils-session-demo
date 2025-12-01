object webCustListBasic: TwebCustListBasic
  OnCreate = WebModuleCreate
  Actions = <
    item
      Default = True
      MethodType = mtGet
      Name = 'DefaultHandler'
      PathInfo = '/'
      Producer = wspIndex
    end
    item
      MethodType = mtGet
      Name = 'waListCustomers'
      PathInfo = '/custlist'
      Producer = wspCustList
    end
    item
      MethodType = mtGet
      Name = 'waEditCustomer'
      PathInfo = '/custedit'
      OnAction = webCustListWebStencilwaEditCustomerAction
    end
    item
      Name = 'waUnauthorized'
      PathInfo = '/unauthorized'
      Producer = wspLoginFailed
    end
    item
      MethodType = mtPost
      Name = 'waLogout'
      PathInfo = '/logout'
      OnAction = webCustListWebStencilwaLogoutAction
    end>
  Height = 407
  Width = 455
  object wspIndex: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'index.html'
    PathTemplate = 'html'
    Left = 104
    Top = 104
  end
  object wsEngineCustList: TWebStencilsEngine
    PathTemplates = <>
    RootDirectory = '/html'
    OnError = wsEngineCustListError
    Left = 64
    Top = 32
  end
  object wspLoginFailed: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'loginfailed.html'
    PathTemplate = 'html'
    Left = 107
    Top = 171
  end
  object wspCustList: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'custlist.html'
    PathTemplate = 'html'
    Left = 128
    Top = 243
  end
  object wspCustEdit: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'custedit.html'
    PathTemplate = 'html'
    Left = 131
    Top = 304
  end
  object WebBasicAuthenticator: TWebBasicAuthenticator
    Realm = 'Customer Access'
    LogoutURL = '/logout'
    OnAuthenticate = WebBasicAuthenticatorAuthenticate
    Left = 328
    Top = 144
  end
  object WebBasicAuthorizer: TWebAuthorizer
    UnauthorizedURL = '/unauthorized'
    Zones = <
      item
        PathInfo = '/'
        Kind = zkFree
      end
      item
        PathInfo = '/unauthorized'
        Kind = zkFree
      end
      item
        PathInfo = '/custlist'
        Roles = 'viewer'
      end>
    Left = 328
    Top = 216
  end
end
