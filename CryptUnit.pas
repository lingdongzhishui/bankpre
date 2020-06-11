unit CryptUnit;

interface

uses
  Windows;

procedure Encrypt(const MingWen: Pchar; const MiWen: Pchar); stdcall; external 'Cryptogram.dll';
procedure Decrypt(const MiWen: Pchar; const MingWen: Pchar); stdcall; external 'Cryptogram.dll';

procedure EncryptStr(MingWen: string; var MiWen: string);
procedure DecryptStr(MiWen: string; var MingWen: string);

implementation

procedure EncryptStr(MingWen: string; var MiWen: string);
var
  MingWenChar: array [0..255] of char;
  MiWenChar: array [0..255] of char;
  i: integer;
begin
  MiWen := '';
  try
    FillChar(MingWenChar, SizeOf(MingWenChar), 0);
    FillChar(MiWenChar, SizeOf(MiWenChar), 0);

    for i := 1 to Length(MingWen) do MingWenChar[i - 1] := MingWen[i];
    Encrypt(@MingWenChar, @MiWenChar);

    MiWen := Pchar(@MiWenChar);
  except
  end;
end;

procedure DecryptStr(MiWen: string; var MingWen: string);
var
  MingWenChar: array [0..255] of char;
  MiWenChar: array [0..255] of char;
  i: integer;
begin
  MingWen := '';
  try
    FillChar(MingWenChar, SizeOf(MingWenChar), 0);
    FillChar(MiWenChar, SizeOf(MiWenChar), 0);

    for i := 1 to Length(MiWen) do MiWenChar[i - 1] := MiWen[i];
    Decrypt(@MiWenChar, @MingWenChar);

    MingWen := Pchar(@MingWenChar);
  except
  end;

end;

end.
