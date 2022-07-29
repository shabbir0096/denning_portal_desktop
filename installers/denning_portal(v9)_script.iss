; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Denning Student Portal "
#define MyAppVersion "2.0"
#define MyAppPublisher "Denning Service Pvt. Ltd."
#define MyAppURL "https://www.denningportal.com/"
#define MyAppExeName "denning_portal.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{99F7C192-C9B2-421D-9291-627E4CBDDF83}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=D:\Office Projects\denning_portal_updated_desktop\installers
OutputBaseFilename=denning_setup_v2
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\denning_portal.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\api-ms-win-core-heap-l2-1-0.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\camera_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\CoreMessaging.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\mfplat.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\msvcp140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\opengl32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\platform_device_id_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\smart_auth_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\vcruntime140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\webview_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\WebView2Loader.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Office Projects\denning_portal_updated_desktop\build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

