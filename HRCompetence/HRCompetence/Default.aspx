<%@ Page Title="Кабинет" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="HRCompetence._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<!-- ЗАГОЛОВОК -->
    <div class="row">
        <div class="col-md-1"><span class="icon-bar"></span></div>
        <div class="col-md-10">
            <div class="jumbotron well">
                <h2 id="GeneralHead">Модуль анализа компетенций</h2>
                <blockquote class="primary">
                    <p class="lead">Приложение написано в архитектуре <mark>ASP.NET Web Forms / Entity Data Model</mark></p>
                </blockquote>                
                <p><a href="https://github.com/vizatech/HR-Service" class="btn btn-primary btn-lg">Перейти на Git-Hub &raquo;</a></p>
            </div>
        </div>
        <div class="col-md-1"><span class="icon-bar"></span></div>
    </div>

<!-- ИСТОЧНИКИ ДАННЫХ -->

    <!-- Источник данных - Persons -->
                    <asp:SqlDataSource ID="SqlDataSourcePerson" runat="server" ConnectionString="<%$ ConnectionStrings:HRCompetenceConnectionString %>" SelectCommand="SELECT * FROM [PersonSet] ORDER BY [Title]" OldValuesParameterFormatString="original_{0}" ConflictDetection="CompareAllValues" DeleteCommand="DELETE FROM [PersonSet] WHERE [Id] = @original_Id AND [Title] = @original_Title AND [IfActive] = @original_IfActive" InsertCommand="INSERT INTO [PersonSet] ([Title], [IfActive]) VALUES (@Title, @IfActive)" UpdateCommand="UPDATE [PersonSet] SET [Title] = @Title, [IfActive] = @IfActive WHERE [Id] = @original_Id AND [Title] = @original_Title AND [IfActive] = @original_IfActive">
                        <DeleteParameters>
                            <asp:Parameter Name="original_Id" Type="Int32" />
                            <asp:Parameter Name="original_Title" Type="String" />
                            <asp:Parameter Name="original_IfActive" Type="Boolean" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Title" Type="String" />
                            <asp:Parameter Name="IfActive" Type="Boolean" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Title" Type="String" />
                            <asp:Parameter Name="IfActive" Type="Boolean" />
                            <asp:Parameter Name="original_Id" Type="Int32" />
                            <asp:Parameter Name="original_Title" Type="String" />
                            <asp:Parameter Name="original_IfActive" Type="Boolean" />
                        </UpdateParameters>
                    </asp:SqlDataSource>

    <!-- Источник данных - Competence -->
                    <asp:SqlDataSource ID="SqlDataSourceCompetence" runat="server" ConnectionString="<%$ ConnectionStrings:HRCompetenceConnectionString %>" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [CompetenceSet] WHERE ([PersonId] = @PersonId) ORDER BY [Id]" ConflictDetection="CompareAllValues" DeleteCommand="DELETE FROM [CompetenceSet] WHERE [Id] = @original_Id AND [Title] = @original_Title AND [IfActive] = @original_IfActive AND (([PersonId] = @original_PersonId) OR ([PersonId] IS NULL AND @original_PersonId IS NULL))" InsertCommand="INSERT INTO [CompetenceSet] ([Title], [IfActive], [PersonId]) VALUES (@Title, @IfActive, @PersonId)" UpdateCommand="UPDATE [CompetenceSet] SET [Title] = @Title, [IfActive] = @IfActive, [PersonId] = @PersonId WHERE [Id] = @original_Id AND [Title] = @original_Title AND [IfActive] = @original_IfActive AND (([PersonId] = @original_PersonId) OR ([PersonId] IS NULL AND @original_PersonId IS NULL))">
                        <DeleteParameters>
                            <asp:Parameter Name="original_Id" Type="Int32" />
                            <asp:Parameter Name="original_Title" Type="String" />
                            <asp:Parameter Name="original_IfActive" Type="Boolean" />
                            <asp:Parameter Name="original_PersonId" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Title" Type="String" />
                            <asp:Parameter Name="IfActive" Type="Boolean" />
                            <asp:Parameter Name="PersonId" Type="Int32" />
                        </InsertParameters>
                        <SelectParameters>
                            <asp:ControlParameter ControlID="ListBoxPerson" DefaultValue="-1" Name="PersonId" PropertyName="SelectedValue" Type="Int32" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Title" Type="String" />
                            <asp:Parameter Name="IfActive" Type="Boolean" />
                            <asp:Parameter Name="PersonId" Type="Int32" />
                            <asp:Parameter Name="original_Id" Type="Int32" />
                            <asp:Parameter Name="original_Title" Type="String" />
                            <asp:Parameter Name="original_IfActive" Type="Boolean" />
                            <asp:Parameter Name="original_PersonId" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>    

    <!-- Источник данных - Comment -->
                    <asp:SqlDataSource ID="SqlDataSourceComment" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:HRCompetenceConnectionString %>" DeleteCommand="DELETE FROM [CommentSet] WHERE [Id] = @original_Id AND [Title] = @original_Title AND [PersonId] = @original_PersonId" InsertCommand="INSERT INTO [CommentSet] ([Title], [PersonId]) VALUES (@Title, @PersonId)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [CommentSet] WHERE ([PersonId] = @PersonId) ORDER BY [Id]" UpdateCommand="UPDATE [CommentSet] SET [Title] = @Title, [PersonId] = @PersonId WHERE [Id] = @original_Id AND [Title] = @original_Title AND [PersonId] = @original_PersonId">
                        <DeleteParameters>
                            <asp:Parameter Name="original_Id" Type="Int32" />
                            <asp:Parameter Name="original_Title" Type="String" />
                            <asp:Parameter Name="original_PersonId" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Title" Type="String" />
                            <asp:Parameter Name="PersonId" Type="Int32" />
                        </InsertParameters>
                        <SelectParameters>
                            <asp:ControlParameter ControlID="ListBoxPerson" Name="PersonId" PropertyName="SelectedValue" Type="Int32" DefaultValue="-1" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Title" Type="String" />
                            <asp:Parameter Name="PersonId" Type="Int32" />
                            <asp:Parameter Name="original_Id" Type="Int32" />
                            <asp:Parameter Name="original_Title" Type="String" />
                            <asp:Parameter Name="original_PersonId" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>

    <!-- Источник данных - Indicator -->
                    <asp:SqlDataSource ID="SqlDataSourceIndicator" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:HRCompetenceConnectionString %>" DeleteCommand="DELETE FROM [IndicatorSet] WHERE [Id] = @original_Id AND [Title] = @original_Title AND [IfActive] = @original_IfActive AND [CompetenceId] = @original_CompetenceId" InsertCommand="INSERT INTO [IndicatorSet] ([Title], [IfActive], [CompetenceId]) VALUES (@Title, @IfActive, @CompetenceId)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [IndicatorSet] WHERE ([CompetenceId] = @CompetenceId) ORDER BY [Id]" UpdateCommand="UPDATE [IndicatorSet] SET [Title] = @Title, [IfActive] = @IfActive, [CompetenceId] = @CompetenceId WHERE [Id] = @original_Id AND [Title] = @original_Title AND [IfActive] = @original_IfActive AND [CompetenceId] = @original_CompetenceId">
                        <DeleteParameters>
                            <asp:Parameter Name="original_Id" Type="Int32" />
                            <asp:Parameter Name="original_Title" Type="String" />
                            <asp:Parameter Name="original_IfActive" Type="Boolean" />
                            <asp:Parameter Name="original_CompetenceId" Type="Int32" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Title" Type="String" />
                            <asp:Parameter Name="IfActive" Type="Boolean" />
                            <asp:Parameter Name="CompetenceId" Type="Int32" />
                        </InsertParameters>
                        <SelectParameters>
                            <asp:ControlParameter ControlID="ListBoxCompetence" Name="CompetenceId" PropertyName="SelectedValue" Type="Int32" DefaultValue="-1" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Title" Type="String" />
                            <asp:Parameter Name="IfActive" Type="Boolean" />
                            <asp:Parameter Name="CompetenceId" Type="Int32" />
                            <asp:Parameter Name="original_Id" Type="Int32" />
                            <asp:Parameter Name="original_Title" Type="String" />
                            <asp:Parameter Name="original_IfActive" Type="Boolean" />
                            <asp:Parameter Name="original_CompetenceId" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>

<!-- МОДАЛЬНЫЕ ОКНА -->
       
    <!-- Person -->
                    <!-- Тело модального окна контекста поиска учетной записи сотрудника -->
                    <div <%= PersonModalClass()%> id="FindPerson" tabindex="-1" role="dialog" aria-labelledby="CreatePersonLabel">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header text-center bg-info">
                                    <asp:Button ID="ButtonFindPersonHeadClose" BorderStyle="None" CssClass="close" runat="server" Text="&times;" OnClick="PersonHeadButtonClose_Click" /> 
                                    <h4 class="modal-title" id="FindPersonHead">Поиск учетной записи</h4>
                                </div>
                                <div class="modal-body text-left">
                                    <blockquote class="primary">
                                        <p>Заполните в текстовом окне <mark>признак поиска</mark> - любую часть фамилии или имени</p>
                                        <footer>Выберите в списке подходящий вариант</footer>
                                    </blockquote>                
                                    <div class="row">
                                    <div class="col-md-1"><span class="icon-bar"></span></div>
                                        <div class="col-md-10">
                                            <div class="input-group">
                                                <asp:TextBox ID="TextBoxFindPerson" placeholder="Search for..." CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" AutoPostBack="True"></asp:TextBox>
                                                <span class="input-group-addon">
                                                    <asp:Button ID="FindPersonList" runat="server" BorderStyle="None" Text="Go!" OnClick="FindPersonList_Click" />
                                                </span>
                                            </div>
                                            <br />
                                            <asp:ListBox ID="ListBoxFindPerson" CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" Rows="7" Height="200px"></asp:ListBox>
                                        </div>
                                    <div class="col-md-1"><span class="icon-bar"></span></div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <asp:Button ID="ButtonFindPersonBottomClose" CssClass="btn btn-default" runat="server" Text="Отменить" OnClick="PersonHeadButtonClose_Click" />
                                    <asp:Button ID="ButtonFindPerson" CssClass="btn btn-primary" runat="server" Text="Найти" OnClick="ButtonFindPerson_Click"/>
                                </div>
                            </div>
                        </div>
                    </div> <!-- конец контекста -->

                    <!-- Тело модального окна контекста добавления сотрудника -->
                    <div class="modal fade" id="CreatePerson" tabindex="-1" role="dialog" aria-labelledby="CreatePersonLabel">
                        <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header text-center bg-info">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="CreatePersonLabel">Добавить сотрудника</h4>
                            </div>
                            <div class="modal-body text-left">
                                <blockquote class="primary">
                                    <p>Заполните в текстовом окне <mark>имя и фамилию сотрудника</mark></p>
                                    <p>Выберите следует ли учетную запись считать <mark>активной</mark></p>
                                    <footer>Вы всегда можете изменть значения этих полей</footer>
                                </blockquote>                
                                <div class="row">
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                    <div class="col-md-10">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                        <asp:CheckBox ID="CheckBoxCreatePerson" runat="server" ToolTip="Отметьте галочкой включена или нет эта учетная запись" Checked="True" />  
                                        </span>
                                        <asp:TextBox ID="TextBoxCreatePerson" placeholder="Фамилия Имя ..." CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" ToolTip="Введите имя и фамилию сотрудника">Имя и фамилия</asp:TextBox>
                                    </div>
                                    </div>
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                            <asp:Button ID="ButtonCreatePerson" CssClass="btn btn-primary" runat="server" Text="Создать" OnClick="ButtonCreatePerson_Click" />
                            </div>
                        </div>
                        </div>
                    </div><!-- конец контекста -->

                    <!-- Тело модального окна контекста изменения учетной записи сотрудника -->
                    <div class="modal fade" id="UpdatePerson" tabindex="-1" role="dialog" aria-labelledby="UpdatePersonLabel">
                        <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header text-center bg-success">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="UpdatePersonLabel">Изменить учетную запись</h4>
                            </div>
                            <div class="modal-body text-left">
                                <blockquote class="primary">
                                    <p>Заполните в текстовом окне <mark>имя и фамилию сотрудника</mark></p>
                                    <p>Выберите следует ли данную учетную запись считать <mark>активной</mark></p>
                                    <footer>Вы всегда можете изменть значения этих полей</footer>
                                </blockquote>                
                                <div class="row">
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                    <div class="col-md-10">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                        <asp:CheckBox ID="CheckBoxUpdatePerson" runat="server" ToolTip="Отметьте галочкой включена или нет эта учетная запись" Checked="True" />  
                                        </span>
                                        <asp:TextBox ID="TextBoxUpdatePerson" placeholder="Фамилия Имя..." CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" ToolTip="Введите имя и фамилию"></asp:TextBox>
                                    </div>
                                    </div>
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                            <asp:Button ID="ButtonUpdatePerson" CssClass="btn btn-primary" runat="server" Text="Сохранить" OnClick="ButtonUpdatePerson_Click" />
                            </div>
                        </div>
                        </div>
                    </div><!-- конец контекста -->

                    <!-- Тело модального окна контекста удаления учетной записи -->
                    <div class="modal fade" id="DeletePerson" tabindex="-1" role="dialog" aria-labelledby="DeletePersonLabel">
                        <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header text-center bg-warning">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="DeletePersonLabel">Удалить учетную запись</h4>
                            </div>
                            <div class="modal-body text-left">
                                <blockquote class="primary">
                                    <p>Выбранная учетная запись будет <mark>удалена</mark></p>
                                    <footer>Вы всегда можете создать такую же</footer>
                                </blockquote>                
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                            <asp:Button ID="ButtonDeletePerson" CssClass="btn btn-warning" runat="server" Text="Удалить" OnClick="ButtonDeletePerson_Click" />
                            </div>
                        </div>
                        </div>
                    </div><!-- конец контекста -->

    <!-- Competence -->
                    <!-- Тело модального окна контекста поиска учетной записи сотрудника -->
                    <div <%= CompetenceModalClass()%> id="FindCompetence" tabindex="-1" role="dialog" aria-labelledby="FindCompetenceHead">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header text-center bg-info">
                                    <asp:Button ID="ButtonFindCompetenceHeadClose" Style="border-width: 0px;" CssClass="close" runat="server" Text="&times;" OnClick="ButtonFindCompetenceHeadClose_Click" /> 
                                    <h4 class="modal-title" id="FindCompetenceHead">Поиск компетенции</h4>
                                </div>
                                <div class="modal-body text-left">
                                    <blockquote class="primary">
                                        <p>Заполните в текстовом окне <mark>признак поиска</mark> - любую часть текста компетенции</p>
                                        <footer>Выберите в списке подходящий вариант</footer>
                                    </blockquote>                
                                    <div class="row">
                                    <div class="col-md-1"><span class="icon-bar"></span></div>
                                        <div class="col-md-10">
                                            <div class="input-group">
                                                <asp:TextBox ID="TextBoxFindCompetence" placeholder="Search for..." CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" AutoPostBack="True"></asp:TextBox>
                                                <span class="input-group-addon">
                                                    <asp:Button ID="LabelFindCompeten" runat="server" BorderStyle="None" Text="Go!" OnClick="LabelFindCompeten_Click" />
                                                </span>
                                            </div>
                                            <br />
                                            <asp:ListBox ID="ListBoxFindCompetence" CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" Rows="7" Height="200"></asp:ListBox>
                                        </div>
                                    <div class="col-md-1"><span class="icon-bar"></span></div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <asp:Button ID="ButtonFindCompetenceBottomClose" CssClass="btn btn-default" runat="server" Text="Отменить" OnClick="ButtonFindCompetenceHeadClose_Click" />
                                    <asp:Button ID="ButtonFindCompetence" CssClass="btn btn-primary" runat="server" Text="Найти" OnClick="ButtonFindCompetence_Click" />
                                </div>
                            </div>
                        </div>
                    </div><!-- конец контекста -->

                    <!-- Тело модального окна контекста добавления компетенции -->
                    <div class="modal fade" id="CreateCompetence" tabindex="-1" role="dialog" aria-labelledby="CreateCompetenceLabel">
                        <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header text-center bg-info">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="CreateCompetenceLabel">Добавить компетенцию</h4>
                            </div>
                            <div class="modal-body text-left">
                                <blockquote class="primary">
                                    <p>Заполните в текстовом окне <mark>наименование компетенции</mark></p>
                                    <p>Выберите следует ли компеткнцию считать <mark>активной</mark></p>
                                    <footer>Вы всегда можете изменть значения этих полей</footer>
                                </blockquote>                
                                <div class="row">
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                    <div class="col-md-10">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                        <asp:CheckBox ID="CheckBoxCreateCompetence" runat="server" ToolTip="Отметьте галочкой включена или нет эта компетенция" Checked="True" />  
                                        </span>
                                        <asp:TextBox ID="TextBoxCreateCompetence" placeholder="Компетенция..." CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" ToolTip="Введите текстовое описание компетенции"></asp:TextBox>
                                    </div>
                                    </div>
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                            <asp:Button ID="ButtonCreateCompetence" CssClass="btn btn-primary" runat="server" Text="Создать" OnClick="ButtonCreateCompetence_Click" />
                            </div>
                        </div>
                        </div>
                    </div><!-- конец контекста -->

                    <!-- Тело модального окна контекста изменения компетенции -->
                    <div class="modal fade" id="UpdateCompetence" tabindex="-1" role="dialog" aria-labelledby="UpdateCompetenceLabel">
                        <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header text-center bg-success">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="UpdateCompetenceLabel">Изменить значение компетенции</h4>
                            </div>
                            <div class="modal-body text-left">
                                <blockquote class="primary">
                                    <p>Заполните в текстовом окне <mark>наименование компетенции</mark></p>
                                    <p>Выберите следует ли данную компетенцию считать <mark>активным</mark></p>
                                    <footer>Вы всегда можете изменть значения этих полей</footer>
                                </blockquote>                
                                <div class="row">
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                    <div class="col-md-10">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                        <asp:CheckBox ID="CheckBoxUpdateCompetence" runat="server" ToolTip="Отметьте галочкой включена или нет эта компетенция" Checked="True" />  
                                        </span>
                                        <asp:TextBox ID="TextBoxUpdateCompetence"  placeholder="Компетенция..." CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" ToolTip="Введите текстовое описание компетенции"></asp:TextBox>
                                    </div>
                                    </div>
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                            <asp:Button ID="ButtonUpdateCompetence" CssClass="btn btn-primary" runat="server" Text="Сохранить" OnClick="ButtonUpdateCompetence_Click" />
                            </div>
                        </div>
                        </div>
                    </div><!-- конец контекста -->

                    <!-- Тело модального окна контекста удаления компетенции -->
                    <div class="modal fade" id="DeleteCompetence" tabindex="-1" role="dialog" aria-labelledby="DeleteCompetenceLabel">
                        <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header text-center bg-warning">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="DeleteCompetenceLabel">Удалить индикатор</h4>
                            </div>
                            <div class="modal-body text-left">
                                <blockquote class="primary">
                                    <p>Выбранная компетенция будет <mark>удалена</mark></p>
                                    <footer>Вы всегда можете создать такую же</footer>
                                </blockquote>                
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                            <asp:Button ID="ButtonDeleteCompetence" CssClass="btn btn-warning" runat="server" Text="Удалить" OnClick="ButtonDeleteCompetence_Click" />
                            </div>
                        </div>
                        </div>
                    </div><!-- конец контекста -->

    <!-- Comment-->
                    <!-- Тело модального окна контекста добавления комментария -->
                    <div class="modal fade" id="CreateComment" tabindex="-1" role="dialog" aria-labelledby="CreateCommentLabel">
                        <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header text-center bg-info">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="CreateCommentLabel">Добавить комментарий</h4>
                            </div>
                            <div class="modal-body text-left">
                                <blockquote class="primary">
                                    <p>Заполните в текстовом окне выш <mark>комментарий</mark></p>
                                    <footer>Вы всегда можете изменть это значение или удалить</footer>
                                </blockquote>                
                                <div class="row">
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                    <div class="col-md-10">
                                    <div class="form-group">
                                        <asp:TextBox ID="TextBoxCreateComment" placeholder="Комментарий..." CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" ToolTip="Введите ваш комментарий"></asp:TextBox>
                                    </div>
                                    </div>
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                            <asp:Button ID="ButtonCreateComment" CssClass="btn btn-primary" runat="server" Text="Создать" OnClick="ButtonCreateComment_Click" />
                            </div>
                        </div>
                        </div>
                    </div><!-- конец контекста -->

                    <!-- Тело модального окна контекста изменения комментария -->
                    <div class="modal fade" id="UpdateComment" tabindex="-1" role="dialog" aria-labelledby="UpdateCommentLabel">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header text-center bg-success">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" id="UpdateCommentLabel">Изменить комментарий</h4>
                                </div>
                                <div class="modal-body text-left">
                                    <blockquote class="primary">
                                        <p>Заполните в текстовом окне <mark>Ваш комментарий</mark></p>
                                        <footer>Вы всегда можете изменть значение этого поля</footer>
                                    </blockquote>                
                                    <div class="row">
                                        <div class="col-md-1"><span class="icon-bar"></span></div>
                                        <div class="col-md-10">
                                            <div class="input-form">
                                                <asp:TextBox ID="TextBoxUpdateCommentNew"  placeholder="Комментарий..." CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" ToolTip="Введите текстовый комментарий"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="col-md-1"><span class="icon-bar"></span></div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                                    <asp:Button ID="ButtonUpdateCommentNew" CssClass="btn btn-primary" runat="server" Text="Сохранить" OnClick="ButtonUpdateCommentNew_Click" />
                                </div>
                            </div>
                        </div>
                    </div><!-- конец контекста -->

                    <!-- Тело модального окна контекста удаления комментария -->
                    <div class="modal fade" id="DeleteComment" tabindex="-1" role="dialog" aria-labelledby="DeleteCommentLabel">
                        <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header text-center bg-warning">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="DeleteCommentLabel">Удалить комментарий</h4>
                            </div>
                            <div class="modal-body text-left">
                                <blockquote class="primary">
                                    <p>Выбранный комментарий будет <mark>удален</mark></p>
                                    <footer>Вы всегда можете создать такой же</footer>
                                </blockquote>                
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                            <asp:Button ID="ButtonDeleteComment" CssClass="btn btn-warning" runat="server" Text="Удалить" OnClick="ButtonDeleteComment_Click" />
                            </div>
                        </div>
                        </div>
                    </div><!-- конец контекста -->

    <!-- Indicator -->
                    <!-- Тело модального окна контекста добавления индикатора -->
                    <div class="modal fade" id="CreateIndicator" tabindex="-1" role="dialog" aria-labelledby="CreateIndicatorLabel">
                        <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header text-center bg-info">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="CreateIndicatorLabel">Добавить индикатор</h4>
                            </div>
                            <div class="modal-body text-left">
                                <blockquote class="primary">
                                    <p>Заполните в текстовом окне <mark>наименование индикатора</mark></p>
                                    <p>Выберите следует ли индикатор считать <mark>активным</mark></p>
                                    <footer>Вы всегда можете изменть значения этих полей</footer>
                                </blockquote>                
                                <div class="row">
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                    <div class="col-md-10">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                        <asp:CheckBox ID="CheckBoxCreateIndicator" runat="server" ToolTip="Отметьте галочкой включен или нет этот индикатор" Checked="True" />  
                                        </span>
                                        <asp:TextBox ID="TextBoxCreateIndicator" placeholder="Индикатор..." CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" ToolTip="Введите текстовое описание индикатора"></asp:TextBox>
                                    </div>
                                    </div>
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                            <asp:Button ID="ButtonSaveIndicator" CssClass="btn btn-primary" runat="server" Text="Создать" OnClick="ButtonCreateIndicator_Click" />
                            </div>
                        </div>
                        </div>
                    </div><!-- конец контекста -->

                    <!-- Тело модального окна контекста изменения индикатора -->
                    <div class="modal fade" id="UpdateIndicator" tabindex="-1" role="dialog" aria-labelledby="UpdateIndicatorLabel">
                        <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header text-center bg-success">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="UpdateIndicatorLabel">Изменить значение индикатора</h4>
                            </div>
                            <div class="modal-body text-left">
                                <blockquote class="primary">
                                    <p>Заполните в текстовом окне <mark>наименование индикатора</mark></p>
                                    <p>Выберите следует ли индикатор считать <mark>активным</mark></p>
                                    <footer>Вы всегда можете изменть значения этих полей</footer>
                                </blockquote>                
                                <div class="row">
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                    <div class="col-md-10">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                        <asp:CheckBox ID="CheckBoxUpdateIndicator" runat="server" ToolTip="Отметьте галочкой включен или нет этот индикатор" Checked="True" />  
                                        </span>
                                        <asp:TextBox ID="TextBoxUpdateIndicator" placeholder="Индикатор..." CssClass="form-control" width="100%" Style="max-width: 500px;" runat="server" ToolTip="Введите текстовое описание индикатора"></asp:TextBox>
                                    </div>
                                    </div>
                                <div class="col-md-1"><span class="icon-bar"></span></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                            <asp:Button ID="ButtonUpdateIndicator" CssClass="btn btn-primary" runat="server" Text="Сохранить" OnClick="ButtonUpdateIndicator_Click" />
                            </div>
                        </div>
                        </div>
                    </div><!-- конец контекста -->

                    <!-- Тело модального окна контекста удаления индикатора -->
                    <div class="modal fade" id="DeleteIndicator" tabindex="-1" role="dialog" aria-labelledby="DeleteIndicatorLabel">
                        <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header text-center bg-warning">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="DeleteIndicatorLabel">Удалить индикатор</h4>
                            </div>
                            <div class="modal-body text-left">
                                <blockquote class="primary">
                                    <p>Выбранный индикатор будет <mark>удален</mark></p>
                                    <footer>Вы всегда можете создать такой же</footer>
                                </blockquote>                
                            </div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Отменить</button>
                            <asp:Button ID="ButtonDeleteIndicator" CssClass="btn btn-warning" runat="server" Text="Удалить" OnClick="ButtonDeleteIndicator_Click" />
                            </div>
                        </div>
                        </div>
                    </div><!-- конец контекста -->

<!-- БЛОК ОБРАБОТКИ ДАННЫХ -->
<!-- <asp:UpdatePanel ID="UpdatePanel1" runat="server"> 
    <ContentTemplate> -->

            <div class="row">
                <div class="col-md-1"><span class="icon-bar"></span></div>
                <asp:Panel ID="PanelDataRead" runat="server" BackColor="#0099CC">

    <!-- Person -->
                    <div class="col-md-3">
                        <div id="PersonHeader" class="panel panel-primary">

        <!-- Заголовок -->
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-md-8 text-left">
                                        <h2 class="panel-title">Сотрудники</h2>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <div class="dropdown">
                                            <div id="dropdownMenuPerson" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="cursor: pointer">
                                                <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                                            </div>
                                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuPerson">
                                                <li><a data-toggle="modal" data-target="#CreatePerson">Добавить</a></li>
                                                <li><a data-toggle="modal" data-target="#UpdatePerson">Изменить</a></li>
                                                <li><a data-toggle="modal" data-target="#DeletePerson">Удалить</a></li>
                                                <li role="separator" class="divider"></li>
                                                <li><asp:Button ID="LinkButtonFindPerson" CssClass="btn btn-default" Style="border-width: 0px; text-align:left; padding: 3px 20px;" width="100%" runat="server" OnClick="LinkButtonFindPerson_Click" Text="Найти" /></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

        <!-- Тело -->
                            <asp:ListBox CssClass="media-object panel-body" Style="border-width: 0px" width="100%" ID="ListBoxPerson" runat="server" DataSourceID="SqlDataSourcePerson" DataTextField="Title" DataValueField="Id" OnSelectedIndexChanged="ListBoxPerson_SelectedIndexChanged" AutoPostBack="True" Font-Size="Medium" Rows="7" Height="200px"></asp:ListBox>
        <!-- Футер -->
                            <div class="panel-footer">
                                <div class="row">
                                    <div class="col-md-2 text-left text-info">
                                         <span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span>
                                    </div>
                                    <div class="col-md-10 text-left">
                                        <asp:Label ID="LabelPerson" runat="server" Font-Size="X-Small"></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

    <!-- Accordion Competence & Comment -->
                    <div class="col-md-4">
                        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
    <!-- Competence -->
                             <div id="CompetenceHeader" class="panel panel-primary">

         <!-- Заголовок -->
                               <div class="panel-heading" role="tab" id="headingOne">
                                    <div class="row">
                                        <div class="col-md-8 text-left">
                                            <h4 class="panel-title">
                                                <asp:Button ID="AccordionCompetence" CssClass="btn btn-primary" Style="border-width: 0px; text-align:left; padding: 0px 20px;" runat="server" OnClick="AccordionCompetenceButton_Click" Text="Компетенции" />
                                            </h4>
                                        </div>
                                        <div class="col-md-4 text-right">
                                            <div class="dropdown">
                                                <div id="dropdownMenuCompetence" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="cursor: pointer">
                                                    <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                                                </div>
                                                <ul class="dropdown-menu" aria-labelledby="dropdownMenuCompetence">
                                                    <li><a data-toggle="modal" data-target="#CreateCompetence">Добавить</a></li>
                                                    <li><a data-toggle="modal" data-target="#UpdateCompetence">Изменить</a></li>
                                                    <li><a data-toggle="modal" data-target="#DeleteCompetence">Удалить</a></li>
                                                    <li role="separator" class="divider"></li>
                                                    <li><asp:Button ID="LinkButtonFindCompetence" CssClass="btn btn-default" Style="border-width: 0px; text-align:left; padding: 3px 20px;" width="100%" runat="server" Text="Найти" OnClick="LinkButtonFindCompetence_Click" /></li>
                                                    <li role="separator" class="divider"></li>
                                                    <li><a href="#">Загрузить из файла</a></li>
                                                    <li><a href="#">Выгрузить в файл</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>

        <!-- Тело -->
                                <div id="divCollapseCompetence" <%= AccordionCompetenceClass()%> role="tabpanel" aria-labelledby="headingOne">
                                    <asp:ListBox CssClass="media-object panel-body" width="100%" Style="max-width: 500px; border-width: 0px" ID="ListBoxCompetence" runat="server" DataSourceID="SqlDataSourceCompetence" DataTextField="Title" DataValueField="Id" Font-Size="Medium" Rows="5" AutoPostBack="True" Height="155px" OnSelectedIndexChanged="ListBoxCompetence_SelectedIndexChanged"></asp:ListBox>

        <!-- Футер -->
                                    <div class="panel-footer">
                                        <div class="row">
                                            <div class="col-md-2 text-left text-info">
                                                <span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span>
                                            </div>
                                            <div class="col-md-10 text-left">
                                                <asp:Label ID="LabelCompetence" runat="server" Font-Size="X-Small"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                </div>  
                            </div>

    <!-- Comment -->
                            <div  id="CommentHeader" class="panel panel-primary">

        <!-- Заголовок -->
                                <div class="panel-heading" role="tab" id="headingTwo">
                                    <div class="row">
                                        <div class="col-md-8 text-left">
                                            <h4 class="panel-title">
                                                <asp:Button ID="AccordionComment" CssClass="btn btn-primary" Style="border-width: 0px; text-align:left; padding: 0px 20px;" runat="server" OnClick="AccordionCommentButton_Click" Text="Комментарии" />
                                            </h4>
                                        </div>
                                        <div class="col-md-4 text-right">
                                            <div class="dropdown">
                                                <div id="dropdownMenuComment" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="cursor: pointer">
                                                    <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                                                </div>
                                                <ul class="dropdown-menu" aria-labelledby="dropdownMenuComment">
                                                    <li><a data-toggle="modal" data-target="#CreateComment">Добавить</a></li>
                                                    <li><a data-toggle="modal" data-target="#UpdateComment">Изменить</a></li>
                                                    <li><a data-toggle="modal" data-target="#DeleteComment">Удалить</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                               
        <!-- Тело -->
                                <div id="divCollapseComment" <%= AccordionCommentClass()%> role="tabpanel" aria-labelledby="headingTwo">
                                    <asp:ListBox CssClass="media-object panel-body" width="100%" Style="max-width: 500px; border-width: 0px" ID="ListBoxComment" runat="server" DataSourceID="SqlDataSourceComment" DataTextField="Title" DataValueField="Id" Font-Size="Medium" Rows="5" AutoPostBack="True" Height="155px" OnSelectedIndexChanged="ListBoxComment_SelectedIndexChanged"></asp:ListBox>
        <!-- Футер -->
                                    <div class="panel-footer">
                                        <div class="row">
                                            <div class="col-md-2 text-left text-info">
                                                <span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span>
                                            </div>
                                            <div class="col-md-10 text-left">
                                                <asp:Label ID="LabelComment" runat="server" Font-Size="X-Small"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                            </div>
                        </div>
                    </div>

    <!-- Indicator -->
                    <div class="col-md-3">
                        <div  id="IndicatorHeader" class="panel panel-primary">
        <!-- Заголовок -->
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-md-8 text-left">
                                        <h2 class="panel-title">Индикаторы</h2>
                                    </div>
                                    <div class="col-md-4 text-right">
                                        <div class="dropdown">
                                            <div id="dropdownMenuIndicators" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="cursor: pointer">
                                                <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                                            </div>
                                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuIndicators">
                                                <li><a data-toggle="modal" data-target="#CreateIndicator">Добавить</a></li>
                                                <li><a data-toggle="modal" data-target="#UpdateIndicator">Изменить</a></li>
                                                <li><a data-toggle="modal" data-target="#DeleteIndicator">Удалить</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>

        <!-- Тело -->
                            <asp:ListBox CssClass="media-object panel-body" Style="border-width: 0px" width="100%" ID="ListBoxIndicator" runat="server" DataSourceID="SqlDataSourceIndicator" DataTextField="Title" DataValueField="Id" Font-Size="Medium" Rows="7" AutoPostBack="True" Height="200px" OnSelectedIndexChanged="ListBoxIndicator_SelectedIndexChanged"></asp:ListBox>
        <!-- Футер -->
                            <div class="panel-footer">
                                <div class="row">
                                    <div class="col-md-2 text-left text-info">
                                        <span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span>
                                    </div>
                                    <div class="col-md-10 text-left">
                                        <asp:Label ID="LabelIndicator" runat="server" Font-Size="X-Small"></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
                <div class="col-md-1"><span class="icon-bar"></span></div>
            </div>
            <div id="FooterFade" <%= BottomBodyModal()%> ></div>
<!--    </ContentTemplate>
</asp:UpdatePanel> -->
                                                        
</asp:Content>
