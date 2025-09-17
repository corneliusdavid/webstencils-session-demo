object webCustListWebStencil: TwebCustListWebStencil
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
      MethodType = mtPost
      Name = 'waLoginVerify'
      PathInfo = '/login'
    end
    item
      MethodType = mtGet
      Name = 'waListCustomers'
      PathInfo = '/custlist'
      OnAction = webCustListWebStencilwaListCustomersAction
    end
    item
      MethodType = mtGet
      Name = 'waEditCustomer'
      PathInfo = '/custedit'
      OnAction = webCustListWebStencilwaEditCustomerAction
    end
    item
      MethodType = mtGet
      Name = 'waLoginFailed'
      PathInfo = '/inavlid_user'
      Producer = wspLoginFailed
    end
    item
      MethodType = mtGet
      Name = 'waLogin'
      PathInfo = '/login'
      Producer = wspLogin
    end
    item
      Name = 'waUnauthorized'
      PathInfo = '/unauthorized'
      Producer = wspAccessDenied
    end
    item
      MethodType = mtGet
      Name = 'waLogout'
      PathInfo = '/logout'
      OnAction = webCustListWebStencilwaLogoutAction
    end>
  Height = 692
  Width = 945
  PixelsPerInch = 144
  object wspIndex: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'index-wStencils.html'
    PathTemplate = 'html'
    Left = 156
    Top = 156
  end
  object wsEngineCustList: TWebStencilsEngine
    PathTemplates = <>
    RootDirectory = '/html'
    OnError = wsEngineCustListError
    Left = 96
    Top = 48
  end
  object wspLoginFailed: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'loginfailed-wStencils.html'
    Left = 148
    Top = 364
  end
  object wspCustList: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'custlist-wStencils.html'
    UserLoggedIn = True
    Left = 312
    Top = 328
  end
  object wspAccessDenied: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'accessdenied-wStencils.html'
    Left = 152
    Top = 468
  end
  object wspCustEdit: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'custedit-wStencils.html'
    Left = 304
    Top = 408
  end
  object wspLogin: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'login-wStencils.html'
    UserLoggedIn = True
    Left = 164
    Top = 244
  end
  object WebSessionManager1: TWebSessionManager
    Left = 496
    Top = 112
  end
  object WebFormsAuthenticator1: TWebFormsAuthenticator
    LoginURL = '/login'
    FailedURL = '/invalid_user'
    HomeURL = '/custlist'
    LogoutURL = '/'
    OnAuthenticate = WebFormsAuthenticator1Authenticate
    Left = 504
    Top = 224
  end
  object WebAuthorizer1: TWebAuthorizer
    Zones = <>
    Left = 504
    Top = 344
  end
end
