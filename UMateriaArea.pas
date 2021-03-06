unit UMateriaArea;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask, FireDAC.Phys.OracleDef,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Comp.UI, FireDAC.Phys.Oracle,
  UData, UMateria, UMateriaCadastro, UFuncUtils,
  Vcl.ComCtrls;

type
  TFrmMateriaArea = class(TForm)
    menu: TMainMenu;
    Arquivo1: TMenuItem;
    Cadastrar1: TMenuItem;
    Sair1: TMenuItem;
    StatusBar1: TStatusBar;
    Atualizar1: TMenuItem;
    Recarregar1: TMenuItem;
    Excluir1: TMenuItem;
    PnlPesquisa: TPanel;
    TxtNome: TEdit;
    BtnFiltrar: TButton;
    BtnRecarregar: TButton;
    Panel1: TPanel;
    DbgMateria: TDBGrid;
    RbtNome: TRadioButton;
    RbtRA: TRadioButton;
    TxtDescricao: TEdit;
    N1: TMenuItem;
    Sair2: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Cadastrar1Click(Sender: TObject);
    procedure DbgMateriaCellClick(Column: TColumn);
    procedure DbgMateriaDblClick(Sender: TObject);
    procedure Atualizar1Click(Sender: TObject);
    procedure Recarregar1Click(Sender: TObject);
    procedure Excluir1Click(Sender: TObject);
    procedure BtnRecarregarClick(Sender: TObject);
    procedure RbtNomeClick(Sender: TObject);
    procedure RbtRAClick(Sender: TObject);
    procedure BtnFiltrarClick(Sender: TObject);
    procedure DbgMateriaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DbgMateriaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Sair2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AtualizarGrid;
  end;

var
  FrmMateriaArea: TFrmMateriaArea;

implementation

{$R *.dfm}

procedure TFrmMateriaArea.Atualizar1Click(Sender: TObject);
begin

  if DbgMateria.Fields[0].Text = '' then
    Exit;

  If not Assigned(FrmMateriaCadastro) Then
    FrmMateriaCadastro := TFrmMateriaCadastro.Create(Application);

  with FrmMateriaCadastro do
  begin
    Acao := 'UPDATE';
    ID := StrToInt(DbgMateria.Fields[0].Text);
    TxtNome.Text := DbgMateria.Fields[1].Text;
    TxtDescricao.Text := DbgMateria.Fields[2].Text;
    KeyValueCurso := StrToInt(DbgMateria.Fields[4].Text);
    ShowModal;
  end;

end;

procedure TFrmMateriaArea.Cadastrar1Click(Sender: TObject);
begin

  If not Assigned(FrmMateriaCadastro) Then
    FrmMateriaCadastro := TFrmMateriaCadastro.Create(Application);

  FrmMateriaCadastro.Acao := 'INSERT';
  FrmMateriaCadastro.ShowModal;

end;

procedure TFrmMateriaArea.DbgMateriaCellClick(Column: TColumn);
begin

  StatusBar1.Panels[0].Text := '-> CLIQUE DUAS VEZES PARA EDITAR O REGISTRO!'

end;

procedure TFrmMateriaArea.DbgMateriaDblClick(Sender: TObject);
begin

  Atualizar1Click(Sender);

end;

procedure TFrmMateriaArea.DbgMateriaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

  //Come�a Zebrando a linha �mpar
  with DbgMateria do
    begin
      if not (gdSelected in State) then
        if not odd(DataModuleSecretaria.FDQueryMateria.RecNo) then
          Canvas.Brush.Color := clWhite
        else
          Canvas.Brush.Color:= clMoneyGreen
      else
        begin
          Canvas.Brush.Color:= clSkyBlue;
          Canvas.Font.Style := [fsBold];
        end;

       Canvas.FillRect(Rect);
       DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;

end;

procedure TFrmMateriaArea.DbgMateriaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_DELETE then
    Excluir1Click(Sender);

end;

procedure TFrmMateriaArea.Excluir1Click(Sender: TObject);
var
  Materia: TMateria;
  ID: Integer;
begin

  if DbgMateria.Fields[0].Text = '' then
    Exit;

  ID := StrToInt(DbgMateria.Fields[0].Text);

  if MessageBox(Handle, 'Deseja realmente excluir essa mat�ria?',
                'Aviso', MB_YESNO or MB_ICONQUESTION) = ID_YES then
    begin
      try

        Materia := TMateria.Create(ID);
        Materia.ExcluirMateria();

        Materia.BuscarMaterias;

      finally

        FreeAndNil(Materia);

      end;
    end;


end;

procedure TFrmMateriaArea.FormActivate(Sender: TObject);
begin

  AtualizarGrid;

end;

procedure TFrmMateriaArea.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Action := caFree;
  FrmMateriaArea := Nil;

end;

procedure TFrmMateriaArea.Sair1Click(Sender: TObject);
begin

  Close;
  FrmMateriaArea := Nil;

end;

procedure TFrmMateriaArea.Sair2Click(Sender: TObject);
begin

  Sair1Click(sender);

end;

procedure TFrmMateriaArea.RbtNomeClick(Sender: TObject);
begin

  TxtNome.Enabled := True;
  TxtDescricao.Enabled := False;
  TxtDescricao.Clear;

  TxtNome.SetFocus;

end;

procedure TFrmMateriaArea.RbtRAClick(Sender: TObject);
begin

  TxtNome.Enabled := False;
  TxtNome.Clear;
  TxtDescricao.Enabled := True;

  TxtDescricao.SetFocus;

end;

procedure TFrmMateriaArea.Recarregar1Click(Sender: TObject);
begin

  AtualizarGrid;

end;

procedure TFrmMateriaArea.AtualizarGrid;
var
  Materia: TMateria;
begin

  try

    UData.DataModuleSecretaria.FDConn.Connected := True;

    Materia := TMateria.Create;

    DbgMateria.DataSource := Materia.BuscarMaterias;

  finally

    FreeAndNil(Materia);

  end;

end;


procedure TFrmMateriaArea.BtnFiltrarClick(Sender: TObject);
var
  Materia: TMateria;
begin

  try

    Materia := TMateria.Create;

    if RbtNome.Checked then
      Materia.BuscarMaterias(TxtNome.Text)
    else
      Materia.BuscarMateriasDescricao(TxtDescricao.Text);

  finally

    FreeAndNil(Materia);

  end;

end;

procedure TFrmMateriaArea.BtnRecarregarClick(Sender: TObject);
begin

  TxtNome.Clear;
  TxtDescricao.Clear;

  AtualizarGrid;

  RbtNome.Checked := True;
  TxtNome.SetFocus;

end;

end.
