<%@ Page Title="Кабинет" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="HRCompetence._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Описание заголовка -->
    <div class="row">
        <div class="col-md-1"><span class="icon-bar"></span></div>
        <div class="col-md-10">
            <div class="jumbotron well">
                <h2>Модуль анализа компетенций</h2>
                <blockquote class="primary">
                    <p class="lead">Приложение написано в архитектуре <mark>ASP.NET Web Forms / Entity Data Model</mark></p>
                </blockquote>                
                <p><a href="#" class="btn btn-primary btn-lg">Перейти на Git-Hub &raquo;</a></p>
            </div>
        </div>
        <div class="col-md-1"><span class="icon-bar"></span></div>
    </div>

    <!-- Тело блока обработки данных -->
    <div class="row">
        <div class="col-md-1"><span class="icon-bar"></span></div>
        <asp:Panel ID="PanelDataRead" runat="server" BackColor="#0099CC">
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
            <!-- Список сотрудников -->
            <div class="col-md-3">
                <div class="panel panel-primary">
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
                                        <li><a href="#">Добавить</a></li>
                                        <li><a href="#">Изменить</a></li>
                                        <li><a href="#">Удалить</a></li>
                                        <li role="separator" class="divider"></li>
                                        <li><a href="#">Найти</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <asp:ListBox CssClass="media-object panel-body" Style="border-width: 0px" width="100%" ID="ListBoxPerson" runat="server" AutoPostBack="True" DataSourceID="SqlDataSourcePerson" DataTextField="Title" DataValueField="Id" Font-Size="Medium" Rows="7" Height="200px" ViewStateMode="Disabled" OnSelectedIndexChanged="ListBoxPerson_SelectedIndexChanged"></asp:ListBox>
                    <div class="panel-footer">
                    </div>
                </div>
            </div>

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
            <!-- Список компетенций и комментариев -->
            <div class="col-md-4">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                    <div class="panel panel-primary">
                        <div class="panel-heading" role="tab" id="headingOne">
                            <div class="row">
                                <div class="col-md-8 text-left">
                            <h4 class="panel-title">
                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                Компетенции
                            </a>
                            </h4>
                                </div>
                                <div class="col-md-4 text-right">
                                    <div class="dropdown">
                                        <div id="dropdownMenuCompetence" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="cursor: pointer">
                                            <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                                        </div>
                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuCompetence">
                                            <li><a href="#">Добавить</a></li>
                                            <li><a href="#">Изменить</a></li>
                                            <li><a href="#">Удалить</a></li>
                                            <li role="separator" class="divider"></li>
                                            <li><a href="#">Найти</a></li>
                                            <li role="separator" class="divider"></li>
                                            <li><a href="#">Загрузить из файла</a></li>
                                            <li><a href="#">Выгрузить в файл</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                            <asp:ListBox CssClass="media-object panel-body" width="100%" Style="max-width: 500px; border-width: 0px" ID="ListBoxCompetence" runat="server" DataSourceID="SqlDataSourceCompetence" DataTextField="Title" DataValueField="Id" Font-Size="Medium" Rows="5" AutoPostBack="True" Height="155px"></asp:ListBox>
                            <div class="panel-footer">
                       
                            </div>
                        </div>
                    </div>
                    <div class="panel panel-primary">
                        <div class="panel-heading" role="tab" id="headingTwo">
                            <div class="row">
                                <div class="col-md-8 text-left">
                                <h4 class="panel-title">
                                <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                    Комментарии
                                </a>
                                </h4>
                                </div>
                                <div class="col-md-4 text-right">
                                    <div class="dropdown">
                                        <div id="dropdownMenuComments" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="cursor: pointer">
                                            <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                                        </div>
                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuComments">
                                            <li><a href="#">Добавить</a></li>
                                            <li><a href="#">Изменить</a></li>
                                            <li><a href="#">Удалить</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                            <asp:ListBox CssClass="media-object panel-body" width="100%" Style="max-width: 500px; border-width: 0px" ID="ListBoxComment" runat="server" DataSourceID="SqlDataSourceComment" DataTextField="Title" DataValueField="Id" Font-Size="Medium" Rows="5" AutoPostBack="True" Height="155px" ViewStateMode="Disabled"></asp:ListBox>
                            <div class="panel-footer">
                       
                            </div>
                        </div>
                    </div>
                </div>
            </div>
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
            <!-- Список индикаторов -->
            <div class="col-md-3">
                <div class="panel panel-primary">
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
                                        <li><a href="#">Добавить</a></li>
                                        <li><a href="#">Изменить</a></li>
                                        <li><a href="#">Удалить</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <asp:ListBox CssClass="media-object panel-body" Style="border-width: 0px" width="100%" ID="ListBoxIndicator" runat="server" DataSourceID="SqlDataSourceIndicator" DataTextField="Title" DataValueField="Id" Font-Size="Medium" Rows="7" AutoPostBack="True" Height="200px"></asp:ListBox>
                    <div class="panel-footer">
                       
                    </div>
                </div>
            </div>
        </asp:Panel>
        <div class="col-md-1"><span class="icon-bar"></span></div>
    </div>
</asp:Content>
