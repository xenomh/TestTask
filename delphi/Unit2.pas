unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, System.Net.HttpClient, System.JSON;

type
  TCategory = record
    CategoryId: Integer;
    CategoryName: string;
    ParentCategoryId: Integer;
  end;
type
    TForm2 = class(TForm)
    TreeView1: TTreeView;
    procedure FormCreate(Sender: TObject);
  private
  public
    procedure AddCategoryToTreeView(const Categories: array of TCategory;
                                 ParentNode: TTreeNode;
                                 ParentCategoryId: Integer);

    function GetCategory: TArray<TCategory>;
  end;

var
  Form2: TForm2;

implementation

procedure TForm2.FormCreate(Sender: TObject);
var
  Categories: TArray<TCategory>;
  I: Integer;
begin
  SetLength(Categories, 3);

  Categories := GetCategory();

  AddCategoryToTreeView(Categories, nil, 0);
end;

procedure TForm2.AddCategoryToTreeView(const Categories: array of TCategory;
                                 ParentNode: TTreeNode;
                                 ParentCategoryId: Integer);
var
  i: Integer;
  node: TTreeNode;
begin
  for i := 0 to High(Categories) do
  begin
    if Categories[i].ParentCategoryId = ParentCategoryId then
    begin
      if Assigned(ParentNode) then
        node := TreeView1.Items.AddChild(ParentNode, Categories[i].CategoryName)
      else
        node := TreeView1.Items.Add(nil, Categories[i].CategoryName);

      AddCategoryToTreeView(Categories, node, Categories[i].CategoryId);
    end;
  end;
end;

function TForm2.GetCategory: TArray<TCategory>;
var
  HttpClient: THTTPClient;
  Response: IHTTPResponse;
  JsonValue: TJSONValue;
  JsonArray: TJSONArray;
  JsonObject: TJSONObject;
  CategoryId: Integer;
  CategoryName: string;
  I: Integer;
  Category: TCategory;
  JsonCategoryId, JsonCategoryName, JsonParentCategoryId: TJSONValue;
  Categories: TArray<TCategory>;
begin
  HttpClient := THTTPClient.Create;
  try
    Response := HttpClient.Get('https://localhost:7241/api/v1/categories');
    if Response.StatusCode = 200 then
    begin
      JsonValue := TJSONObject.ParseJSONValue(Response.ContentAsString());
      try
        if JsonValue is TJSONArray then
        begin
          JsonArray := TJSONArray(JsonValue);
          SetLength(Categories, JsonArray.Count);

          for I := 0 to JsonArray.Count - 1 do
          begin
            if JsonArray.Items[I] is TJSONObject then
            begin
              JsonObject := TJSONObject(JsonArray.Items[I] as TJSONObject);

              Category.CategoryId := JsonObject.GetValue<Integer>('categoryId');
              Category.CategoryName := JsonObject.GetValue<String>('categoryName');
              JsonParentCategoryId := JsonObject.GetValue('parentCategoryId');

              if JsonParentCategoryId is TJSONNull then
                Category.ParentCategoryId := 0
              else
                Category.ParentCategoryId := JsonObject.GetValue<integer>('parentCategoryId');

              Categories[I] := Category;
            end;
          end;
        end
        else
        begin
          raise Exception.Create('Expected JSON array format');
        end;
      finally
        JsonValue.Free;
      end;
    end
    else
    begin
      raise Exception.Create('Failed to retrieve data: ' + Response.StatusText);
    end;
  finally
    HttpClient.Free;
  end;

  Result := Categories;
end;

{$R *.dfm}

end.
