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
      MethodType = mtGet
      Name = 'waLogout'
      PathInfo = '/logout'
      OnAction = webCustListWebStencilwaLogoutAction
    end>
  AfterDispatch = webCustListWebStencilwaEditCustomerAction
  Height = 495
  Width = 455
  object wspIndex: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'index.html'
    PathTemplate = 'html'
    Left = 72
    Top = 72
  end
  object wsEngineCustList: TWebStencilsEngine
    PathTemplates = <>
    RootDirectory = '/html'
    OnError = wsEngineCustListError
    Left = 256
    Top = 32
  end
  object wspLoginFailed: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'loginfailed.html'
    PathTemplate = 'html'
    Left = 83
    Top = 195
  end
  object wspCustList: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'custlist.html'
    PathTemplate = 'html'
    UserRoles = 'viewer,editor,manager'
    Left = 160
    Top = 259
  end
  object wspCustEdit: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'custedit.html'
    PathTemplate = 'html'
    UserRoles = 'editor,manager'
    Left = 163
    Top = 320
  end
  object wspLogin: TWebStencilsProcessor
    Engine = wsEngineCustList
    InputFileName = 'loginform.html'
    PathTemplate = 'html'
    Left = 77
    Top = 131
  end
  object WebSessionMgr: TWebSessionManager
    OnIdGenerate = WebSessionMgrIdGenerate
    OnValidate = WebSessionMgrValidate
    Left = 331
    Top = 75
  end
  object WebFormsAuthenticator: TWebFormsAuthenticator
    LoginURL = '/login'
    FailedURL = '/invalid_user'
    HomeURL = '/custlist'
    LogoutURL = '/'
    OnAuthenticate = WebFormsAuthenticatorAuthenticate
    Left = 336
    Top = 149
  end
end
