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
      PathInfo = '/invalid_user'
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
      Producer = wspLoginFailed
    end
    item
      MethodType = mtPost
      Name = 'waLogout'
      PathInfo = '/logout'
      OnAction = webCustListWebStencilwaLogoutAction
    end>
  Height = 866
  Width = 796
  PixelsPerInch = 168
  object wspIndex: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'index.html'
    PathTemplate = 'html'
    Left = 126
    Top = 126
  end
  object wsEngineCustList: TWebStencilsEngine
    PathTemplates = <>
    RootDirectory = '/html'
    OnError = wsEngineCustListError
    Left = 448
    Top = 56
  end
  object wspLoginFailed: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'loginfailed.html'
    PathTemplate = 'html'
    Left = 145
    Top = 341
  end
  object wspCustList: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'custlist.html'
    PathTemplate = 'html'
    UserRoles = 'viewer,editor,manager'
    Left = 280
    Top = 453
  end
  object wspCustEdit: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'custedit.html'
    PathTemplate = 'html'
    UserRoles = 'editor,manager'
    Left = 285
    Top = 560
  end
  object wspLogin: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'loginform.html'
    PathTemplate = 'html'
    Left = 135
    Top = 229
  end
  object WebSessionMgr: TWebSessionManager
    OnIdGenerate = WebSessionMgrIdGenerate
    OnValidate = WebSessionMgrValidate
    Left = 579
    Top = 131
  end
  object WebFormsAuthenticator: TWebFormsAuthenticator
    LoginURL = '/login'
    FailedURL = '/invalid_user'
    HomeURL = '/custlist'
    LogoutURL = '/'
    OnAuthenticate = WebFormsAuthenticatorAuthenticate
    Left = 588
    Top = 261
  end
end
