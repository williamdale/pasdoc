{
  Original version 2004-2005 Richard B. Winston, U.S. Geological Survey (USGS)
  Modifications copyright 2005 Michalis Kamburelis
  Additional modifications by Richard B. Winston, April 26, 2005.

  This file is part of pasdoc_gui.

  pasdoc_gui is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  pasdoc_gui is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with pasdoc_gui; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

{
  @abstract(@name contains the main form of Help Generator.)
  @author(Richard B. Winston <rbwinst@usgs.gov>)
  @author(Michalis Kamburelis)
  @created(2004-11-28)
  @cvs($Date$)
}

unit frmHelpGeneratorUnit;

{$mode DELPHI}

interface

uses
  SysUtils, Classes, LResources, Graphics, Controls, Forms,
  Dialogs, PasDoc_Gen, PasDoc_GenHtml, PasDoc, StdCtrls, PasDoc_Types,
  ComCtrls, ExtCtrls, CheckLst, PasDoc_Languages, Menus,
  Buttons, Spin, PasDoc_GenLatex, Process, PasDoc_Serialize,
  IniFiles, PasDoc_GenHtmlHelp, EditBtn;

type
  // @abstract(TfrmHelpGenerator is the class of the main form of Help
  // Generator.) Its published fields are mainly components that are used to
  // save the project settings.
  TfrmHelpGenerator = class(TForm)
   CheckAutoAbstract: TCheckBox;
   CheckUseTipueSearch: TCheckBox;
    EditCssFileName: TFileNameEdit;
    EditHtmlBrowserCommand: TEdit;
    CssFileNameFileNameEdit1: TFileNameEdit;
    EditIntroductionFileName: TFileNameEdit;
    EditConclusionFileName: TFileNameEdit;
    HtmlHelpDocGenerator: THTMLHelpDocGenerator;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LabelHtmlBrowserCommand: TLabel;
    MemoCommandLog: TMemo;
    memoFooter: TMemo;
    memoHeader: TMemo;
    MenuAbout: TMenuItem;
    PanelWebPageTop: TPanel;
    // @name is the main workhorse of @classname.  It analyzes the source
    // code and cooperates with @link(HtmlDocGenerator)
    // and @link(TexDocGenerator) to create the output.
    PasDoc1: TPasDoc;
    // @name generates HTML output.
    HtmlDocGenerator: THTMLDocGenerator;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    DocBrowserProcess: TProcess;
    tabGenerate: TTabSheet;
    // memoMessages displays compiler warnings.  See also @link(seVerbosity);
    memoMessages: TMemo;
    tabHeadFoot: TTabSheet;
    TabMoreOptions: TTabSheet;
    tabWebPage: TTabSheet;
    tabOptions: TTabSheet;
    // @name controls whether of private, protected, public, published and
    // automated properties, methods, events, and fields will be included in
    // generated output.
    clbMethodVisibility: TCheckListBox;
    Label1: TLabel;
    // comboLanguages is used to set the language in which the web page will
    // be written.  Of course, this only affects tha language for the text
    // generated by the program, not the comments about the program.
    comboLanguages: TComboBox;
    Label2: TLabel;
    tabSourceFiles: TTabSheet;
    // @name holds the complete paths of all the source files
    // in the project.
    memoFiles: TMemo;
    PanelSourceFilesBottom: TPanel;
    // Click @name to select one or more sorce files for the
    // project.
    btnBrowseSourceFiles: TButton;
    // @name has the path of the directory where the web files will
    // be created.
    edOutput: TEdit;
    Label3: TLabel;
    Panel1: TPanel;
    // Click @name  to generate web pages.
    btnGenerateWebPages: TButton;
    tabIncludeDirectories: TTabSheet;
    // The lines in @name are the paths of the files that
    // may have include files that are part of the project.
    memoIncludeDirectories: TMemo;
    PanelIncludeDirectoriesBottom: TPanel;
    // Click @name  to select a directory that may
    // have include directories.
    btnBrowseIncludeDirectory: TButton;
    // Click @name to select the directory in whick the
    // output files will be created.
    btnBrowseOutputDirectory: TButton;
    Label6: TLabel;
    // @name is used to set the name of the project.
    edProjectName: TEdit;
    SaveDialog1: TSaveDialog;
    OpenDialog2: TOpenDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Exit1: TMenuItem;
    // @name controls the severity of the messages that are displayed.
    seVerbosity: TSpinEdit;
    Label7: TLabel;
    PanelSourceFilesTop: TPanel;
    Label8: TLabel;
    PanelIncludeDirectoriesTop: TPanel;
    Label9: TLabel;
    PanelGenerateTop: TPanel;
    Label10: TLabel;
    // @name determines what sort of files will be created
    comboGenerateFormat: TComboBox;
    Label11: TLabel;
    New1: TMenuItem;
    // @name generates Latex output.
    TexDocGenerator: TTexDocGenerator;
    tabDefines: TTabSheet;
    PanelDefinesTop: TPanel;
    Label12: TLabel;
    memoDefines: TMemo;
    MenuHelp: TMenuItem;
    procedure SomethingChanged(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure PasDoc1Warning(const MessageType: TMessageType;
      const AMessage: string; const AVerbosity: Cardinal);
    procedure btnBrowseSourceFilesClick(Sender: TObject);
    procedure clbMethodVisibilityClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGenerateWebPagesClick(Sender: TObject);
    procedure comboLanguagesChange(Sender: TObject);
    procedure btnBrowseIncludeDirectoryClick(Sender: TObject);
    procedure btnBrowseOutputDirectoryClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure edProjectNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure New1Click(Sender: TObject);
    procedure comboGenerateFormatChange(Sender: TObject);
  private
    FChanged: boolean;
    FSettingsFileName: string;
    procedure SaveChanges(var Action: TCloseAction);
    procedure SetChanged(const AValue: boolean);
    procedure SetDefaults;
    procedure SetSettingsFileName(const AValue: string);
    procedure UpdateCaption;
  public
    // @name is @true when the user has changed the project settings.
    // Otherwise it is @false.
    property Changed: boolean read FChanged write SetChanged;
    { This is the settings filename (.pds file) that is currently
      opened. You can look at pasdoc_gui as a "program to edit pds files".
      It is '' if current settings are not associated with any filename
      (because user did not opened any pds file, or he chose "New" menu item). }
    property SettingsFileName: string read FSettingsFileName
      write SetSettingsFileName;
    DefaultDirectives: TStringList;
  end;

var
  // @name is the main form of Help Generator
  frmHelpGenerator: TfrmHelpGenerator;

implementation

uses PasDoc_Items, frmAboutUnit;

procedure TfrmHelpGenerator.PasDoc1Warning(const MessageType: TMessageType;
  const AMessage: string; const AVerbosity: Cardinal);
begin
  memoMessages.Lines.Add(AMessage);
end;

procedure TfrmHelpGenerator.MenuAboutClick(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

procedure TfrmHelpGenerator.SomethingChanged(Sender: TObject);
begin
  Changed := true;
end;

procedure TfrmHelpGenerator.btnBrowseSourceFilesClick(Sender: TObject);
var
  Directory: string;
  FileIndex: integer;
  Files: TStringList;
begin
  if OpenDialog1.Execute then
  begin
    Files := TStringList.Create;
    try

      if edOutput.Text = '' then
      begin
        edOutput.Text := ExtractFileDir(OpenDialog1.FileName);
      end;

      Files.Sorted := True;
      Files.Duplicates := dupIgnore;

      Files.AddStrings(memoFiles.Lines);
      Files.AddStrings(OpenDialog1.Files);

      memoFiles.Lines := Files;

      for FileIndex := 0 to OpenDialog1.Files.Count - 1 do
      begin
        Directory := ExtractFileDir(OpenDialog1.Files[FileIndex]);
        if memoIncludeDirectories.Lines.IndexOf(Directory) < 0 then
        begin
          memoIncludeDirectories.Lines.Add(Directory);
        end;
      end;
    finally
      Files.Free;
    end;
  end;
end;

procedure TfrmHelpGenerator.clbMethodVisibilityClick(Sender: TObject);
var
  Options: TVisibilities;
begin
  Options := [];
  if clbMethodVisibility.Checked[0] then
  begin
    Include(Options, viPublished);
  end;
  if clbMethodVisibility.Checked[1] then
  begin
    Include(Options, viPublic);
  end;
  if clbMethodVisibility.Checked[2] then
  begin
    Include(Options, viProtected);
  end;
  if clbMethodVisibility.Checked[3] then
  begin
    Include(Options, viPrivate);
  end;
  if clbMethodVisibility.Checked[4] then
  begin
    Include(Options, viAutomated);
  end;

  if PasDoc1.ShowVisibilities <> Options then
  begin
    Changed := True;
    PasDoc1.ShowVisibilities := Options;
  end;
end;

procedure TfrmHelpGenerator.SetDefaults;
begin
  clbMethodVisibility.Checked[0] := True;
  clbMethodVisibility.Checked[1] := True;
  clbMethodVisibility.Checked[2] := False;
  clbMethodVisibility.Checked[3] := False;
  clbMethodVisibility.Checked[4] := False;
  clbMethodVisibilityClick(nil);

  comboLanguages.ItemIndex := Ord(lgEnglish);
  comboLanguagesChange(nil);

  edProjectName.Text := '';
  edOutput.Text := '';
  seVerbosity.Value := 2;
  comboGenerateFormat.ItemIndex := 0;
  memoFiles.Clear;
  memoIncludeDirectories.Clear;
  memoMessages.Clear;

  memoDefines.Lines.Assign(DefaultDirectives);

  EditCssFileName.FileName := '';
  EditIntroductionFileName.FileName := '';
  EditConclusionFileName.FileName := '';
  CheckAutoAbstract.Checked := false;
  CheckUseTipueSearch.Checked := false;
  
  Changed := False;
end;

procedure TfrmHelpGenerator.UpdateCaption;
var
  NewCaption: string;
begin
  { Caption value follows GNOME HIG 2.0 standard }
  NewCaption := '';
  if Changed then NewCaption += '*';
  if SettingsFileName = '' then
   NewCaption += 'Unsaved PasDoc settings' else
   NewCaption += ExtractFileName(SettingsFileName);
  NewCaption += ' - PasDoc GUI';
  Caption := NewCaption;
end;

procedure TfrmHelpGenerator.SetChanged(const AValue: boolean);
begin
  if FChanged = AValue then Exit;
  FChanged := AValue;
  UpdateCaption;
end;

procedure TfrmHelpGenerator.SetSettingsFileName(const AValue: string);
begin
  FSettingsFileName := AValue;
  UpdateCaption;
end;

procedure TfrmHelpGenerator.FormCreate(Sender: TObject);
var
  LanguageIndex: TLanguageID;
begin
  EditHtmlBrowserCommand.Text :=
    {$ifdef WIN32} 'explorer %s' {$else} 'sh -c "$BROWSER %s"' {$endif};

  comboLanguages.Items.Capacity :=
    Ord(High(LanguageIndex)) - Ord(Low(TLanguageID)) + 1;
  for LanguageIndex := Low(TLanguageID) to High(LanguageIndex) do
  begin
    comboLanguages.Items.Add(LANGUAGE_ARRAY[LanguageIndex].Name);
  end;

  Constraints.MinWidth := Width;
  Constraints.MinHeight := Height;

  DefaultDirectives := TStringList.Create;
  
  { Original HelpGenerator did here
    DefaultDirectives.Assign(memoDefines.Lines)
    I like this solution, but unfortunately current Lazarus seems
    to sometimes "lose" value of TMemo.Lines...
    So I'm setting these values at runtime. }
    
  {$IFDEF FPC}
  DefaultDirectives.Append('FPC');
  {$ENDIF}
  {$IFDEF UNIX}
  DefaultDirectives.Append('UNIX');
  {$ENDIF}
  {$IFDEF LINUX}
  DefaultDirectives.Append('LINUX');
  {$ENDIF}
  {$IFDEF DEBUG}
  DefaultDirectives.Append('DEBUG');
  {$ENDIF}

  {$IFDEF VER130}
  DefaultDirectives.Append('VER130');
  {$ENDIF}
  {$IFDEF VER140}
  DefaultDirectives.Append('VER140');
  {$ENDIF}
  {$IFDEF VER150}
  DefaultDirectives.Append('VER150');
  {$ENDIF}
  {$IFDEF VER160}
  DefaultDirectives.Append('VER160');
  {$ENDIF}
  {$IFDEF VER170}
  DefaultDirectives.Append('VER170');
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  DefaultDirectives.Append('MSWINDOWS');
  {$ENDIF}
  {$IFDEF WIN32}
  DefaultDirectives.Append('WIN32');
  {$ENDIF}
  {$IFDEF CPU386}
  DefaultDirectives.Append('CPU386');
  {$ENDIF}
  {$IFDEF CONDITIONALEXPRESSIONS}
  DefaultDirectives.Append('CONDITIONALEXPRESSIONS');
  {$ENDIF}

  SetDefaults;
  
  { It's too easy to change it at design-time, so we set it at runtime. }
  PageControl1.ActivePageIndex := 0;

  {$IFDEF WIN32}
  // Deal with bug in display of TSpinEdit in Win32.
  seVerbosity.Constraints.MinWidth := 60;
  seVerbosity.Width := seVerbosity.Constraints.MinWidth;
  {$ENDIF}

end;

procedure TfrmHelpGenerator.btnGenerateWebPagesClick(Sender: TObject);
var
  Files: TStringList;
begin
  Screen.Cursor := crHourGlass;
  try
    memoMessages.Clear;
    
    case comboGenerateFormat.ItemIndex of
      0: PasDoc1.Generator := HtmlDocGenerator;
      1: PasDoc1.Generator := HtmlHelpDocGenerator;
      2, 3:
         begin
           PasDoc1.Generator := TexDocGenerator;
           TexDocGenerator.Latex2rtf := (comboGenerateFormat.ItemIndex = 3);
         end;
    else
      Assert(False);
    end;

    if PasDoc1.Generator is TGenericHTMLDocGenerator then
    begin
      TGenericHTMLDocGenerator(PasDoc1.Generator).Header := memoHeader.Lines.Text;
      TGenericHTMLDocGenerator(PasDoc1.Generator).Footer := memoFooter.Lines.Text;
      TGenericHTMLDocGenerator(PasDoc1.Generator).CSS := EditCssFileName.Text;
      TGenericHTMLDocGenerator(PasDoc1.Generator).UseTipueSearch :=
        CheckUseTipueSearch.Checked;
    end;
    
    // Create the output directory if it does not exist.
    if not DirectoryExists(edOutput.Text) then
    begin
      CreateDir(edOutput.Text)
    end;
    PasDoc1.Generator.DestinationDirectory := edOutput.Text;
    
    PasDoc1.Generator.AutoAbstract := CheckAutoAbstract.Checked;
    
    PasDoc1.ProjectName := edProjectName.Text;
    PasDoc1.IntroductionFileName := EditIntroductionFileName.Text;
    PasDoc1.ConclusionFileName := EditConclusionFileName.Text;

    Files := TStringList.Create;
    try
      Files.AddStrings(memoFiles.Lines);
      PasDoc1.SourceFileNames.Clear;
      PasDoc1.AddSourceFileNames(Files);

      Files.Clear;
      Files.AddStrings(memoIncludeDirectories.Lines);
      PasDoc1.IncludeDirectories.Assign(Files);

      Files.Clear;
      Files.AddStrings(memoDefines.Lines);
      PasDoc1.Directives.Assign(Files);
    finally
      Files.Free;
    end;
    PasDoc1.Verbosity := Round(seVerbosity.Value);
    
    PasDoc1.Execute;

    case comboGenerateFormat.ItemIndex of
      0, 1:
        begin
          DocBrowserProcess.CommandLine := Format(EditHtmlBrowserCommand.Text,
            [ HtmlDocGenerator.DestinationDirectory + 'index.html' ]);
          DocBrowserProcess.Execute;
          MemoCommandLog.Lines.Append('Executed: ' + DocBrowserProcess.CommandLine);
          PageControl1.ActivePage := tabWebPage;
        end;
      2, 3:
        begin
        end;
    else
      Assert(False);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmHelpGenerator.comboLanguagesChange(Sender: TObject);
begin
  HtmlDocGenerator.Language := TLanguageID(comboLanguages.ItemIndex);
  TexDocGenerator.Language := TLanguageID(comboLanguages.ItemIndex);
  Changed := True;
end;

procedure TfrmHelpGenerator.btnBrowseIncludeDirectoryClick(Sender: TObject);
var
  directory: string;
begin
  if memoIncludeDirectories.Lines.Count > 0 then
  begin
    directory := memoIncludeDirectories.Lines[
      memoIncludeDirectories.Lines.Count - 1];
  end
  else
  begin
    directory := '';
  end;

  if SelectDirectory('Select directory to include', '', directory)
    then
  begin
    if memoIncludeDirectories.Lines.IndexOf(directory) < 0 then
    begin
      memoIncludeDirectories.Lines.Add(directory);
    end
    else
    begin
      MessageDlg('The directory you selected, (' + directory
        + ') is already included.', Dialogs.mtInformation, [mbOK], 0);
    end;
  end;
end;

procedure TfrmHelpGenerator.btnBrowseOutputDirectoryClick(Sender: TObject);
var
  directory: string;
begin
  directory := edOutput.Text;
  if SelectDirectory('Select output directory', '', directory)
    then
  begin
    edOutput.Text := directory;
  end;
end;

procedure TfrmHelpGenerator.btnOpenClick(Sender: TObject);
var
  Ini: TIniFile;

  procedure ReadStrings(const Section: string; S: TStrings);
  var i: Integer;
  begin
    S.Clear;
    for i := 0 to Ini.ReadInteger(Section, 'Count', 0) - 1 do
      S.Append(Ini.ReadString(Section, 'Item_' + IntToStr(i), ''));
  end;

var i: Integer;
begin
  if OpenDialog2.Execute then
  begin
    SettingsFileName := OpenDialog2.FileName;

    Ini := TIniFile.Create(SettingsFileName);
    try
      { Default values for ReadXxx() methods here are not so important,
        don't even try to set them right.
        *Good* default values are set in SetDefaults method of this class.
        Here we can assume that values are always present in ini file.

        Well, OK, in case user will modify settings file by hand we should
        set here some sensible default values... also in case we will add
        in the future some new values to this file...
        so actually we should set here sensible "default values".
        We can think of them as "good default values for user opening a settings
        file written by older version of pasdoc_gui program".
        They need not necessarily be equal to default values set by
        SetDefaults method, and this is very good, as it may give us
        additional possibilities. }

      comboLanguages.ItemIndex := Ini.ReadInteger('Main', 'Language', 0);
      comboLanguagesChange(nil);

      edOutput.Text := Ini.ReadString('Main', 'OutputDir', '');

      comboGenerateFormat.ItemIndex := Ini.ReadInteger('Main', 'GenerateFormat', 0);
      comboGenerateFormatChange(nil);

      edProjectName.Text := Ini.ReadString('Main', 'ProjectName', '');
      seVerbosity.Value := Ini.ReadInteger('Main', 'Verbosity', 0);

      for i := Ord(Low(TVisibility)) to Ord(High(TVisibility)) do
        clbMethodVisibility.Checked[i] := Ini.ReadBool(
          'Main', 'ClassMembers_' + IntToStr(i), true);
      clbMethodVisibilityClick(nil);

      ReadStrings('Defines', memoDefines.Lines);
      ReadStrings('Header', memoHeader.Lines);
      ReadStrings('Footer', memoFooter.Lines);
      ReadStrings('IncludeDirectories', memoIncludeDirectories.Lines);
      ReadStrings('Files', memoFiles.Lines);
      
      EditCssFileName.FileName := Ini.ReadString('Main', 'CssFileName', '');
      EditIntroductionFileName.FileName :=
        Ini.ReadString('Main', 'IntroductionFileName', '');
      EditConclusionFileName.FileName :=
        Ini.ReadString('Main', 'ConclusionFileName', '');
      CheckAutoAbstract.Checked := Ini.ReadBool('Main', 'AutoAbstract', false);
      CheckUseTipueSearch.Checked := Ini.ReadBool('Main', 'UseTipueSearch', false);
    finally Ini.Free end;

    Changed := False;
  end;
end;

procedure TfrmHelpGenerator.Save1Click(Sender: TObject);
var
  Ini: TIniFile;

  procedure WriteStrings(const Section: string; S: TStrings);
  var i: Integer;
  begin
    { It's not really necessary for correctness but it's nice to protect
      user privacy by removing trash data from file (in case previous
      value of S had larger Count). }
    Ini.EraseSection(Section);

    Ini.WriteInteger(Section, 'Count', S.Count);
    for i := 0 to S.Count - 1 do
      Ini.WriteString(Section, 'Item_' + IntToStr(i), S[i]);
  end;

var i: Integer;
begin
  if SaveDialog1.Execute then
  begin
    SettingsFileName := SaveDialog1.FileName;

    Ini := TIniFile.Create(SettingsFileName);
    try
      Ini.WriteInteger('Main', 'Language', comboLanguages.ItemIndex);
      Ini.WriteString('Main', 'OutputDir', edOutput.Text);
      Ini.WriteInteger('Main', 'GenerateFormat', comboGenerateFormat.ItemIndex);
      Ini.WriteString('Main', 'ProjectName', edProjectName.Text);
      Ini.WriteInteger('Main', 'Verbosity', Round(seVerbosity.Value));

      for i := Ord(Low(TVisibility)) to Ord(High(TVisibility)) do
        Ini.WriteBool('Main', 'ClassMembers_' + IntToStr(i),
          clbMethodVisibility.Checked[i]);

      WriteStrings('Defines', memoDefines.Lines);
      WriteStrings('Header', memoHeader.Lines);
      WriteStrings('Footer', memoFooter.Lines);
      WriteStrings('IncludeDirectories', memoIncludeDirectories.Lines);
      WriteStrings('Files', memoFiles.Lines);

      Ini.WriteString('Main', 'CssFileName', EditCssFileName.FileName);
      Ini.WriteString('Main', 'IntroductionFileName',
        EditIntroductionFileName.FileName);
      Ini.WriteString('Main', 'ConclusionFileName',
        EditConclusionFileName.FileName);
      Ini.WriteBool('Main', 'AutoAbstract', CheckAutoAbstract.Checked);
      Ini.WriteBool('Main', 'UseTipueSearch', CheckUseTipueSearch.Checked);

      Ini.UpdateFile;
    finally Ini.Free end;

    Changed := False;
  end;
end;

procedure TfrmHelpGenerator.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmHelpGenerator.edProjectNameChange(Sender: TObject);
begin
  Changed := True;
end;

procedure TfrmHelpGenerator.SaveChanges(var Action: TCloseAction);
var
  MessageResult: integer;
begin
  if Changed then
  begin
    MessageResult := MessageDlg(
      'Do you want to save the settings for this project?',
      Dialogs.mtInformation, [mbYes, mbNo, mbCancel], 0);
    case MessageResult of
      mrYes:
        begin
          Save1Click(nil);
        end;
      mrNo:
        begin
          // do nothing.
        end;
    else
      begin
        Action := caNone;
      end;
    end;
  end;
end;

procedure TfrmHelpGenerator.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveChanges(Action);
  DefaultDirectives.Free;
end;

procedure TfrmHelpGenerator.New1Click(Sender: TObject);
var
  Action: TCloseAction;
begin
  Action := caHide;
  if Changed then
  begin
    SaveChanges(Action);
    if Action = caNone then
      Exit;
  end;

  SetDefaults;

  SettingsFileName := '';

  Changed := False;
end;

procedure TfrmHelpGenerator.comboGenerateFormatChange(Sender: TObject);
begin
  Changed := true;
end;

initialization
  {$I frmhelpgeneratorunit.lrs}
end.
