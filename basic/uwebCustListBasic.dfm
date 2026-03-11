object webCustListBasic: TwebCustListBasic
  OnCreate = WebModuleCreate
  Actions = <>
  AfterDispatch = WebModuleAfterDispatch
  Height = 339
  Width = 279
  object wsEngineCustList: TWebStencilsEngine
    Dispatcher = WebFileDispatcher
    PathTemplates = <>
    RootDirectory = '/'
    OnError = wsEngineCustListError
    Left = 64
    Top = 32
  end
  object WebBasicAuthenticator: TWebBasicAuthenticator
    LogoutURL = '/'
    OnAuthenticate = WebBasicAuthenticatorAuthenticate
    Left = 136
    Top = 152
  end
  object WebAuthorizer: TWebAuthorizer
    UnauthorizedURL = '/notallowed'
    Zones = <
      item
        PathInfo = '/'
        Kind = zkFree
      end
      item
        PathInfo = '/custlist'
        Roles = 'viewer'
      end>
    Left = 160
    Top = 208
  end
  object WebFileDispatcher: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/html'
        Extensions = 'html;htm'
      end
      item
        MimeType = 'application/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpeg;jpg'
      end
      item
        MimeType = 'image/png'
        Extensions = 'png'
      end>
    BeforeDispatch = WebFileDispatcherBeforeDispatch
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\html\*'
      end>
    RootDirectory = '/html'
    VirtualPath = '/'
    DefaultFile = 'index.html'
    Left = 80
    Top = 256
  end
  object WebSessionManager: TWebSessionManager
    Left = 112
    Top = 96
  end
end
