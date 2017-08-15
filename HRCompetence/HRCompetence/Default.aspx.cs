using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Xml.Serialization;
using System.IO;

namespace HRCompetence
{
    public partial class _Default : Page
    {

        private EntityDataModelContainer _context = new EntityDataModelContainer();

        protected void Page_Load(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UsersState"];

            if (httpCookie != null)
            {
                // считываем Куки состояния модальных окон если они существуют
                _collection.AccordionCompetence = httpCookie["AccordionCompetence"];
                _collection.AccordionComment = httpCookie["AccordionComment"];
                _collection.FindPersonModal = httpCookie["FindPersonModal"];
                _collection.FindCompetenceModal = httpCookie["FindCompetenceModal"];
                _collection.TopBodyModal = httpCookie["TopBodyModal"];
                _collection.BottomBodyModal = httpCookie["BottomBodyModal"];
            }
            else
            {
                // создаем Куки модальных окон если их раньше не было
                httpCookie = new HttpCookie("UsersState");

                _collection.AccordionCompetence = "Class='panel-collapse collapse in'";
                httpCookie["AccordionCompetence"] = "Class='panel-collapse collapse in'";
                _collection.AccordionComment = "Class='panel-collapse collapse'";
                httpCookie["AccordionComment"] = "Class='panel-collapse collapse'";
                _collection.FindPersonModal = "Class='modal fade' Style='display:none' ";
                httpCookie["FindPersonModal"] = "Class='modal fade' Style='display:none' ";
                _collection.FindCompetenceModal = "Class='modal fade' Style='display:none' ";
                httpCookie["FindCompetenceModal"] = "Class='modal fade' Style='display:none' ";
                _collection.TopBodyModal = "";
                httpCookie["TopBodyModal"] = "";
                _collection.BottomBodyModal = "";
                httpCookie["BottomBodyModal"] = "";

                httpCookie.Expires = DateTime.Now.AddHours(72);

                Response.Cookies.Add(httpCookie);
            }
        }

        #region внедрение класса состояния модальных окон
        private class PublicCollection
        {
            public string FindPersonModal { get; set; }
            public string FindCompetenceModal { get; set; }
            public string TopBodyModal { get; set; }
            public string BottomBodyModal { get; set; }
            public string AccordionCompetence { get; set; }
            public string AccordionComment { get; set; }
        }

        private PublicCollection _collection = new PublicCollection();

        public string TopBodyModal()
        {
            return _collection.TopBodyModal;
        }

        public string BottomBodyModal()
        {
            return _collection.BottomBodyModal;
        }

        public string PersonModalClass()
        {
            return _collection.FindPersonModal;
        }

        public string CompetenceModalClass()
        {
            return _collection.FindCompetenceModal;
        }

        public string AccordionCompetenceClass()
        {
            return _collection.AccordionCompetence;
        }

        public string AccordionCommentClass()
        {
            return _collection.AccordionComment;
        }
        #endregion

        #region Экспорт - Импорт
        public class CompetenceFile
        {
            public string Title { get; set; }
            public bool IfActive { get; set; }
            public List<IndicatorFile> Indicators { get; set; }
        }

        public class IndicatorFile
        {
            public string Title { get; set; }
            public bool IfActive { get; set; }
        }

        protected void DownloadButton_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxCompetence.SelectedValue, out int _id)
                && int.TryParse(ListBoxPerson.SelectedValue, out int _idp))
            {
                int Id = Convert.ToInt32(ListBoxCompetence.SelectedValue);
                var Comp = _context.GetCompetenceById(Id);
                CompetenceFile CreateCompetenceClass = new CompetenceFile()
                {
                    Title = Comp.First().Title
                };

                Comp = _context.GetCompetenceById(Id);
                CreateCompetenceClass.IfActive = Comp.First().IfActive;
                var Ind = _context.GetIndicatorByIdCompetence(Id);
                CreateCompetenceClass.Indicators = new List<IndicatorFile>();
                foreach (var a in Ind.ToList())
                {
                    CreateCompetenceClass.Indicators.Add(new IndicatorFile { Title = a.Title, IfActive = a.IfActive });
                }
                if (DownloadFormat.Items[0].Selected)
                {
                    string content = JsonConvert.SerializeObject(CreateCompetenceClass);
                    Response.Clear();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment;filename=" + Server.UrlPathEncode(CreateCompetenceClass.Title + '.' + DownloadFormat.SelectedValue));
                    Response.Charset = "";
                    Response.ContentType = "text/plain";
                    Response.Output.Write(content);
                }
                else if (DownloadFormat.Items[1].Selected)
                {
                    XmlSerializer xmlSerializer = new XmlSerializer(CreateCompetenceClass.GetType());

                    StringWriter textWriter = new StringWriter();
                    xmlSerializer.Serialize(textWriter, CreateCompetenceClass);
                    var content = textWriter.ToString();
                    Response.Clear();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment;filename=" + Server.UrlPathEncode(CreateCompetenceClass.Title + '.' + DownloadFormat.SelectedValue));
                    Response.Charset = "";
                    Response.ContentType = "text/plain";
                    Response.Output.Write(content);
                }

                Response.Flush();
                Response.End();
            }
        }

        protected void ImportCompetenceButton_Click(object sender, EventArgs e)
        {
            string PersonIdText = ListBoxPerson.SelectedValue;
            int PersonId = Int32.Parse(PersonIdText);

            string FileData = ImportFileText.Text;
            CompetenceFile results = new CompetenceFile();
            try
            {
                results = JsonConvert.DeserializeObject<CompetenceFile>(FileData);
            }
            catch
            {
                XmlSerializer serializer = new XmlSerializer(typeof(CompetenceFile));
                StringReader rdr = new StringReader(FileData);
                results = (CompetenceFile)serializer.Deserialize(rdr);
            }

            if ((results.Title != "")
                && (!_context.GetCompetenceByTitleByIdPerson(results.Title, PersonId).Any()))
            {
                //фиксируем текущие значения контрола и разрываем связь с источником данных
                var _source = ListBoxCompetence.DataSourceID;

                //инициируем хранимую процедуру создания элемента
                _context.PostCompetence(results.Title, results.IfActive, PersonId);

                //восстанавливаем связь контрола с источником данных          
                ListBoxCompetence.DataSourceID = _source;
                int _count = _context.GetCompetenceByIdPerson(PersonId).Count();

                //передаем фокус на первый элемент списка если он существует
                ListBoxCompetence.Focus();

                var Comp = _context.GetCompetenceByTitleByIdPerson(results.Title, PersonId);
                int _cId = Comp.First().Id;

                foreach (IndicatorFile a in results.Indicators)
                {
                    //фиксируем текущие значения контрола и разрываем связь с источником данных
                    _source = ListBoxIndicator.DataSourceID;
                    //инициируем хранимую процедуру создания элемента
                    _context.PostIndicator(a.Title, a.IfActive, _cId);
                    //восстанавливаем связь контрола с источником данных
                    ListBoxIndicator.DataSourceID = _source;
                    _count = _context.GetIndicatorByIdCompetence(_cId).Count();
                    ListBoxIndicator.Focus();
                }
            }
        }
        #endregion

        #region аккордеон
        protected void AccordionCompetenceButton_Click(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UsersState"];

            httpCookie["AccordionCompetence"] = "Class='panel-collapse collapse in'";
            _collection.AccordionCompetence = "Class='panel-collapse collapse in'";
            httpCookie["AccordionComment"] = "Class='panel-collapse collapse'";
            _collection.AccordionComment = "Class='panel-collapse collapse'";

            httpCookie.Expires = DateTime.Now.AddHours(72);

            Response.Cookies.Add(httpCookie);

        }

        protected void AccordionCommentButton_Click(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UsersState"];

            httpCookie["AccordionCompetence"] = "Class='panel-collapse collapse'";
            _collection.AccordionCompetence = "Class='panel-collapse collapse'";
            httpCookie["AccordionComment"] = "Class='panel-collapse collapse in'";
            _collection.AccordionComment = "Class='panel-collapse collapse in'";

            httpCookie.Expires = DateTime.Now.AddHours(72);
            Response.Cookies.Add(httpCookie);

        }
        #endregion

        #region поиск учетных записей
        protected void FindPersonList_Click(object sender, EventArgs e)
        {
            var _person = _context.GetPersonByAssociation(TextBoxFindPerson.Text).ToList();

            if (_person.Any())
            {
                ListBoxFindPerson.DataSource = _person;
                ListBoxFindPerson.DataTextField = "Title";
                ListBoxFindPerson.DataValueField = "Id";
                ListBoxFindPerson.DataBind();
            }
        }

        protected void ButtonFindPerson_Click(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UsersState"];

            _collection.FindPersonModal = "Class='modal fade' Style='display:none' ";
            httpCookie["FindPersonModal"] = "Class='modal fade' Style='display:none' ";
            _collection.TopBodyModal = "";
            httpCookie["TopBodyModal"] = "";
            _collection.BottomBodyModal = "";
            httpCookie["BottomBodyModal"] = "";

            httpCookie.Expires = DateTime.Now.AddHours(72);

            Response.Cookies.Add(httpCookie);

            ListBoxPerson.ClearSelection();
            try { ListBoxPerson.Items.FindByValue(ListBoxFindPerson.SelectedItem.Value).Selected = true; } catch { };

            // очищаем состояния связанных окон
            ListBoxCompetence.ClearSelection();
            LabelCompetence.Visible = false;
            ListBoxIndicator.ClearSelection();
            LabelIndicator.Visible = false;
            ListBoxComment.ClearSelection();
        }

        protected void PersonHeadButtonClose_Click(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UsersState"];

            _collection.FindPersonModal = "Class='modal fade' Style='display:none' ";
            httpCookie["FindPersonModal"] = "Class='modal fade' Style='display:none' ";
            _collection.TopBodyModal = "";
            httpCookie["TopBodyModal"] = "";
            _collection.BottomBodyModal = "";
            httpCookie["BottomBodyModal"] = "";

            httpCookie.Expires = DateTime.Now.AddHours(72);

            Response.Cookies.Add(httpCookie);
        }

        protected void LinkButtonFindPerson_Click(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UsersState"];

            _collection.FindPersonModal = "Class='modal fade in' Style='display:block' ";
            httpCookie["FindPersonModal"] = "Class='modal fade in' Style='display:block' ";
            _collection.TopBodyModal = "Class='modal-open' Style='padding-right: 12px' ";
            httpCookie["TopBodyModal"] = "Class='modal-open' Style='padding-right: 12px' ";
            _collection.BottomBodyModal = "Class='modal-backdrop fade in'";
            httpCookie["BottomBodyModal"] = "Class='modal-backdrop fade in'";

            httpCookie.Expires = DateTime.Now.AddHours(72);

            Response.Cookies.Add(httpCookie);
        }
        #endregion

        #region поиск компетенций
        protected void LabelFindCompeten_Click(object sender, EventArgs e)
        {
            var _competence = _context.GetCompetenceByAssociation(TextBoxFindCompetence.Text).ToList();

            if (_competence.Any())
            {
                ListBoxFindCompetence.DataSource = _competence;
                ListBoxFindCompetence.DataTextField = "Title";
                ListBoxFindCompetence.DataValueField = "Id";
                ListBoxFindCompetence.DataBind();
            }
        }

        protected void ButtonFindCompetence_Click(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UsersState"];

            _collection.FindCompetenceModal = "Class='modal fade' Style='display:none' ";
            httpCookie["FindCompetenceModal"] = "Class='modal fade' Style='display:none' ";
            _collection.TopBodyModal = "";
            httpCookie["TopBodyModal"] = "";
            _collection.BottomBodyModal = "";
            httpCookie["BottomBodyModal"] = "";

            httpCookie.Expires = DateTime.Now.AddHours(72);

            Response.Cookies.Add(httpCookie);

            int.TryParse(ListBoxFindCompetence.SelectedItem.Value, out int _idc);
            if (_idc > 0)
            {
                var _competence = _context.GetCompetenceById(_idc).ToList();

                if (_competence.Any())
                {
                    int _idp = _competence.First().PersonId.Value;

                    ListBoxPerson.ClearSelection();
                    try { ListBoxPerson.Items.FindByValue(_idp.ToString()).Selected = true; } catch { };

                    ListBoxCompetence.DataBind();
                    ListBoxCompetence.ClearSelection();
                    try { ListBoxCompetence.Items.FindByValue(_idc.ToString()).Selected = true; } catch { };

                    // очищаем состояния связанных окон
                    ListBoxIndicator.ClearSelection();
                    LabelIndicator.Visible = false;
                }
            }
        }

        protected void ButtonFindCompetenceHeadClose_Click(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UsersState"];

            _collection.FindCompetenceModal = "Class='modal fade' Style='display:none' ";
            httpCookie["FindCompetenceModal"] = "Class='modal fade' Style='display:none' ";
            _collection.TopBodyModal = "";
            httpCookie["TopBodyModal"] = "";
            _collection.BottomBodyModal = "";
            httpCookie["BottomBodyModal"] = "";

            httpCookie.Expires = DateTime.Now.AddHours(72);

            Response.Cookies.Add(httpCookie);
        }

        protected void LinkButtonFindCompetence_Click(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UsersState"];

            _collection.FindCompetenceModal = "Class='modal fade in' Style='display:block' ";
            httpCookie["FindCompetenceModal"] = "Class='modal fade in' Style='display:block' ";
            _collection.TopBodyModal = "Class='modal-open' Style='padding-right: 12px' ";
            httpCookie["TopBodyModal"] = "Class='modal-open' Style='padding-right: 12px' ";
            _collection.BottomBodyModal = "Class='modal-backdrop fade in'";
            httpCookie["BottomBodyModal"] = "Class='modal-backdrop fade in'";
       
            httpCookie.Expires = DateTime.Now.AddHours(72);

            Response.Cookies.Add(httpCookie);
        }
        #endregion

        #region методы контекста Учетной записи
        protected void ListBoxPerson_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxPerson.SelectedValue, out int _id))
            {
                //получаем контекст Индикатора по его id в базе данных
                var _person = _context.GetPersonById(_id).ToList();

                if (_person.Any())
                {
                    //заполняем значения тега в футере панели
                    LabelPerson.Text = (_person.First().IfActive) ? "# Учетная запись активна" : "# Учетная запись отключена";
                    LabelPerson.CssClass = (_person.First().IfActive) ? "label label-success" : "label label-warning";
                    LabelPerson.Visible = true;
                    ListBoxCompetence.ClearSelection();
                    LabelCompetence.Visible = false;
                    ListBoxIndicator.ClearSelection();
                    LabelIndicator.Visible = false;
                    ListBoxComment.ClearSelection();

                    LinkButtonUpdatePerson.Enabled = true;
                    LinkButtonDeletePerson.Enabled = true;
                    LinkButtonCreateCompetence.Enabled = true;
                    LinkButtonImportCompetence.Enabled = true;
                    LinkButtonCreateComment.Enabled = true;

                    LinkButtonUpdateCompetence.Enabled = false;
                    LinkButtonDeleteCompetence.Enabled = false;
                    LinkButtonExportCompetence.Enabled = false;
                    LinkButtonUpdateComment.Enabled = false;
                    LinkButtonDeleteComment.Enabled = false;

                    LinkButtonCreateIndicator.Enabled = false;
                    LinkButtonUpdateIndicator.Enabled = false;
                    LinkButtonDeleteIndicator.Enabled = false;

                    //заполняем всплывающий тег контрола
                    ListBoxPerson.ToolTip = _person.First().Title;

                    //заполняем значение текстового контрола Изменить
                    TextBoxUpdatePerson.Text = ListBoxPerson.SelectedItem.Text;
                    CheckBoxUpdatePerson.Checked = _person.First().IfActive;
                }
                else
                {
                    ListBoxPerson.ToolTip = "список пуст";
                    LabelPerson.Visible = false;
                    LabelCompetence.Visible = false;
                    LabelIndicator.Visible = false;
                }
            }
        }

        protected void ButtonCreatePerson_Click(object sender, EventArgs e)
        {
            //если создаваемая запись не пуста и в базе данных нет такой же
            if ((TextBoxCreatePerson.Text != "")
                && (!_context.GetPersonByTitle(TextBoxCreatePerson.Text).Any()))
            {
                //инициируем хранимую процедуру создания элемента и получаем его id
                _context.PostPerson(TextBoxCreatePerson.Text, CheckBoxCreatePerson.Checked);

                //восстанавливаем связь контрола с источником данных
                ListBoxPerson.DataBind();
                string _id = _context.GetPersonByTitle(TextBoxCreatePerson.Text).First().Id.ToString();

                //изменяем футер состояния записи
                LabelPerson.Text = (CheckBoxCreatePerson.Checked) ? "# Учетная запись активна" : "# Учетная запись отключена";
                LabelPerson.CssClass = (CheckBoxCreatePerson.Checked) ? "label label-success" : "label label-warning";
                LabelPerson.Visible = true;

                // Обнуляем значения контролов Создания значений полей
                TextBoxCreatePerson.Text = "";
                CheckBoxCreatePerson.Checked = true;

                // Передаем указатель на созданное поле
                ListBoxPerson.ClearSelection();
                try { ListBoxPerson.Items.FindByValue(_id).Selected = true; } catch { };

                // очищаем состояния связанных окон
                ListBoxCompetence.ClearSelection();
                LabelCompetence.Visible = false;
                ListBoxIndicator.ClearSelection();
                LabelIndicator.Visible = false;
                ListBoxComment.ClearSelection();
            }
        }

        protected void ButtonUpdatePerson_Click(object sender, EventArgs e)
        {

            //если значение записи не пустое и передано id записи
            if ((TextBoxUpdatePerson.Text != "")
                && (int.TryParse(ListBoxPerson.SelectedValue, out int _id)))
            {

                // если запись в базе данных отличается от предложенного к изменению варианта
                string _text = _context.GetPersonById(_id).First().Title;
                bool _ifActive = _context.GetPersonById(_id).First().IfActive;
                if (!_context.GetPersonByTitle(TextBoxUpdatePerson.Text).Any() || (CheckBoxUpdatePerson.Checked != _ifActive))
                {

                    //получаем контекст Учетной записи по ее id в базе данных
                    int _item = Int32.Parse(ListBoxPerson.SelectedIndex.ToString());

                    //инициируем хранимую процедуру изменения элемента
                    _context.PutPersonById(_id, TextBoxUpdatePerson.Text, CheckBoxUpdatePerson.Checked);

                    //восстанавливаем связь контрола с источником данных
                    ListBoxPerson.DataBind();

                    //изменяем футер состояния записи
                    LabelPerson.Text = (CheckBoxUpdatePerson.Checked) ? "# Учетная запись активна" : "# Учетная запись отключена";
                    LabelPerson.CssClass = (CheckBoxUpdatePerson.Checked) ? "label label-success" : "label label-warning";
                    LabelPerson.Visible = true;

                    //передаем фокус на отредактированный элемент списка если он существует
                    TextBoxUpdatePerson.Text = "";
                    CheckBoxUpdatePerson.Checked = true;
                    ListBoxPerson.ClearSelection();
                    ListBoxPerson.SelectedIndex = _item;
                }
            }
        }

        protected void ButtonDeletePerson_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxPerson.SelectedValue, out int _id))
            {
                //инициируем хранимую процедуру удаления элемента
                _context.DeletePersonById(_id);

                //восстанавливаем связь контрола с источником данных
                ListBoxPerson.DataBind();

                //передаем фокус на отредактированный элемент списка если он существует
                int _count = ListBoxPerson.Items.Count;

                //передаем фокус на первый элемент списка если он существует
                if (_count > 0)
                {
                    ListBoxPerson.SelectedIndex = _count - 1;

                    //изменяем футер состояния записи
                    int.TryParse(ListBoxPerson.SelectedValue, out int _newid);
                    bool _ifActive = _context.GetPersonById(_newid).First().IfActive;
                    LabelPerson.Text = (_ifActive) ? "# Учетная запись активна" : "# Учетная запись отключена";
                    LabelPerson.CssClass = (_ifActive) ? "label label-success" : "label label-warning";
                    LabelPerson.Visible = true;

                    // очищаем состояния связанных окон
                    ListBoxCompetence.ClearSelection();
                    LabelCompetence.Visible = false;
                    ListBoxIndicator.ClearSelection();
                    LabelIndicator.Visible = false;
                    ListBoxComment.ClearSelection();
                }
                else
                {
                    //если список пуст - все значения гасим
                    ListBoxPerson.ToolTip = "список Учетных записей пуст";
                    LinkButtonUpdatePerson.Enabled = false;
                    LinkButtonDeletePerson.Enabled = false;
                    LinkButtonCreateCompetence.Enabled = false;
                    LinkButtonImportCompetence.Enabled = false;
                    LinkButtonCreateComment.Enabled = false;
                    LabelPerson.Visible = false;
                }
            }
        }
        #endregion

        #region методы контекста Компетенции
        protected void ListBoxCompetence_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxCompetence.SelectedValue, out int _id))
            {
                //получаем контекст Индикатора по его id в базе данных
                var _competence = _context.GetCompetenceById(_id).ToList();

                if (_competence.Any())
                {
                    //заполняем значения тега в футере панели
                    LabelCompetence.Text = (_competence.First().IfActive) ? "# Компетенция активна" : "# Компетенция отключена";
                    LabelCompetence.CssClass = (_competence.First().IfActive) ? "label label-success" : "label label-warning";
                    LabelCompetence.Visible = true;

                    LinkButtonUpdateCompetence.Enabled = true;
                    LinkButtonUpdateCompetence.Enabled = true;
                    LinkButtonExportCompetence.Enabled = true;
                    LinkButtonDeleteCompetence.Enabled = true;
                    LinkButtonCreateIndicator.Enabled = true;

                    LinkButtonUpdateIndicator.Enabled = false;
                    LinkButtonDeleteIndicator.Enabled = false;

                    //заполняем всплывающий тег контрола
                    ListBoxCompetence.ToolTip = _competence.First().Title;

                    //заполняем значение поля Изменить
                    TextBoxUpdateCompetence.Text = ListBoxCompetence.SelectedItem.Text;
                    CheckBoxUpdateCompetence.Checked = _competence.First().IfActive;

                    // очищаем состояния связанных окон
                    ListBoxIndicator.ClearSelection();
                    LabelIndicator.Visible = false;
                }
                else
                {
                    ListBoxCompetence.ToolTip = "список пуст";
                    LabelCompetence.Visible = false;
                    LabelIndicator.Visible = false;
                }
            }
        }

        protected void ButtonCreateCompetence_Click(object sender, EventArgs e)
        {
            //если запись не пустая, есть привязка к Person и такой же записи не существует в этой привязке
            if ((TextBoxCreateCompetence.Text != "")
                && (int.TryParse(ListBoxPerson.SelectedValue, out int _idp))
                && (!_context.GetCompetenceByTitleByIdPerson(TextBoxCreateCompetence.Text, _idp).Any()))
            {
                //инициируем хранимую процедуру создания элемента
                _context.PostCompetence(TextBoxCreateCompetence.Text, CheckBoxCreateCompetence.Checked, _idp);

                //восстанавливаем связь контрола с источником данных
                ListBoxCompetence.DataBind();
                string _id = _context.GetCompetenceByTitleByIdPerson(TextBoxCreateCompetence.Text, _idp).First().Id.ToString();

                //изменяем футер состояния записи
                LabelCompetence.Text = (CheckBoxCreateCompetence.Checked) ? "# Компетенция активна" : "# Компетенция отключена";
                LabelCompetence.CssClass = (CheckBoxCreateCompetence.Checked) ? "label label-success" : "label label-warning";
                LabelCompetence.Visible = true;

                //обнуляем значения контролов Создания значений полей
                TextBoxCreateCompetence.Text = "";
                CheckBoxCreateCompetence.Checked = true;

                // Передаем указатель на созданное поле
                ListBoxCompetence.ClearSelection();
                try { ListBoxCompetence.Items.FindByValue(_id).Selected = true; } catch { };

                // очищаем состояния связанных окон
                ListBoxIndicator.ClearSelection();
                LabelIndicator.Visible = false;
            }
        }

        protected void ButtonUpdateCompetence_Click(object sender, EventArgs e)
        {
            // если передання запись не пуста и содержит Id
            if ((TextBoxUpdateCompetence.Text != "")
                && (int.TryParse(ListBoxCompetence.SelectedValue, out int _id))
                && (int.TryParse(ListBoxPerson.SelectedValue, out int _idp)))
            {

                // если запись в базе данных отличается от предложенного к изменению варианта
                string _text = _context.GetCompetenceById(_id).First().Title;
                bool _ifActive = _context.GetCompetenceById(_id).First().IfActive;
                if (!_context.GetCompetenceByTitleByIdPerson(TextBoxUpdateCompetence.Text, _idp).Any() || (CheckBoxUpdateCompetence.Checked != _ifActive))
                {
                    //фиксируем текущие значения контрола и разрываем связь с источником данных
                    int _item = Int32.Parse(ListBoxCompetence.SelectedIndex.ToString());

                    //инициируем хранимую процедуру изменения элемента
                    _context.PutCompetenceById(_id, TextBoxUpdateCompetence.Text, CheckBoxUpdateCompetence.Checked);

                    //восстанавливаем связь контрола с источником данных
                    ListBoxCompetence.DataBind();

                    //изменяем футер состояния записи
                    LabelCompetence.Text = (CheckBoxUpdateCompetence.Checked) ? "# Компетенция активна" : "# Компетенция отключена";
                    LabelCompetence.CssClass = (CheckBoxUpdateCompetence.Checked) ? "label label-success" : "label label-warning";
                    LabelCompetence.Visible = true;

                    //передаем фокус на отредактированный элемент списка если он существует
                    TextBoxUpdateCompetence.Text = "";
                    CheckBoxUpdateCompetence.Checked = true;
                    ListBoxCompetence.ClearSelection();
                    ListBoxCompetence.SelectedIndex = _item;
                }
            }
        }

        protected void ButtonDeleteCompetence_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxCompetence.SelectedValue, out int _id)
                && int.TryParse(ListBoxPerson.SelectedValue, out int _idp))
            {
                //инициируем хранимую процедуру удаления элемента
                _context.DeleteCompetenceById(_id);

                //восстанавливаем связь контрола с источником данных
                ListBoxCompetence.DataBind();

                //передаем фокус на первый элемент списка если он существует
                int _count = ListBoxCompetence.Items.Count;

                ListBoxCompetence.ClearSelection();
                if (_count > 0)
                {
                    ListBoxCompetence.SelectedIndex = _count - 1;
                }
                else
                {
                    //если список пуст - все значения гасим

                    LinkButtonUpdateCompetence.Enabled = false;
                    LinkButtonUpdateCompetence.Enabled = false;
                    LinkButtonDeleteCompetence.Enabled = false;

                    LabelCompetence.Visible = false;
                    ListBoxCompetence.ToolTip = "список Компетенций пуст";
                }

                // очищаем состояния связанных окон
                ListBoxIndicator.ClearSelection();
                LabelIndicator.Visible = false;
            }
        }
        #endregion

        #region методы контекста Индикатора    
        protected void ListBoxIndicator_SelectedIndexChanged(object sender, EventArgs e)
        {
            //получаем контекст Индикатора по его id в базе данных
            if (int.TryParse(ListBoxIndicator.SelectedValue, out int _id))
            {
                //получаем экземпляр Индикатора
                var _indicator = _context.GetIndicatorById(_id).ToList();

                if (_indicator.Any())
                {
                    //заполняем значения тега в футере панели
                    LabelIndicator.Text = (_indicator.First().IfActive) ? "# Индикатор активен" : "# Индикатор отключён";
                    LabelIndicator.CssClass = (_indicator.First().IfActive) ? "label label-success" : "label label-warning";
                    LabelIndicator.Visible = true;

                    LinkButtonUpdateIndicator.Enabled = true;
                    LinkButtonDeleteIndicator.Enabled = true;


                    //заполняем всплывающий тег контрола
                    ListBoxIndicator.ToolTip = _indicator.First().Title;

                    //заполняем значение текстового контрола Изменить
                    TextBoxUpdateIndicator.Text = ListBoxIndicator.SelectedItem.Text;
                    CheckBoxUpdateIndicator.Checked = _indicator.First().IfActive;
                }
                else
                {
                    ListBoxIndicator.ToolTip = "список пуст";
                    LabelIndicator.Visible = false;
                }
            }
        }

        protected void ButtonCreateIndicator_Click(object sender, EventArgs e)
        {
            //если запись не пустая, есть привязка к Competence, и такой же записи не существует в этой привязке
            if ((TextBoxCreateIndicator.Text != "")
                && (int.TryParse(ListBoxCompetence.SelectedValue, out int _idc))
                && (!_context.GetIndicatorByTitleByIdCompetence(TextBoxCreateIndicator.Text, _idc).Any()))
            {
                //инициируем хранимую процедуру создания элемента
                _context.PostIndicator(TextBoxCreateIndicator.Text, CheckBoxCreateIndicator.Checked, _idc);

                //восстанавливаем связь контрола с источником данных
                ListBoxIndicator.DataBind();
                string _id = _context.GetIndicatorByTitleByIdCompetence(TextBoxCreateIndicator.Text, _idc).First().Id.ToString();

                //изменяем футер состояния записи
                LabelIndicator.Text = (CheckBoxCreateIndicator.Checked) ? "# Индикатор активен" : "# Индикатор отключен";
                LabelIndicator.CssClass = (CheckBoxCreateIndicator.Checked) ? "label label-success" : "label label-warning";
                LabelIndicator.Visible = true;

                //обнуляем значения контролов Создания значений полей
                TextBoxCreateIndicator.Text = "";
                CheckBoxCreateIndicator.Checked = true;

                // Передаем указатель на созданное поле
                ListBoxIndicator.ClearSelection();
                try { ListBoxIndicator.Items.FindByValue(_id).Selected = true; } catch { };
            }
        }

        protected void ButtonUpdateIndicator_Click(object sender, EventArgs e)
        {
            //если запись не пустая, есть привязка к Competence, и такой же записи не существует в этой привязке
            if ((TextBoxUpdateIndicator.Text != "")
                && (int.TryParse(ListBoxIndicator.SelectedValue, out int _id))
                && (int.TryParse(ListBoxIndicator.SelectedValue, out int _idc)))
            {
                // если запись в базе данных отличается от предложенного к изменению варианта
                string _text = _context.GetIndicatorById(_id).First().Title;
                bool _ifActive = _context.GetIndicatorById(_id).First().IfActive;
                if (!_context.GetIndicatorByTitleByIdCompetence(TextBoxUpdateIndicator.Text, _idc).Any() || (CheckBoxUpdateIndicator.Checked != _ifActive))
                {
                    //фиксируем текущие значения контрола и разрываем связь с источником данных
                    int _item = Int32.Parse(ListBoxIndicator.SelectedIndex.ToString());

                    //инициируем хранимую процедуру изменения элемента
                    _context.PutIndicatorById(_id, TextBoxUpdateIndicator.Text, CheckBoxUpdateIndicator.Checked);

                    //восстанавливаем связь контрола с источником данных
                    ListBoxIndicator.DataBind();

                    //изменяем футер состояния записи
                    LabelIndicator.Text = (CheckBoxUpdateIndicator.Checked) ? "# Индикатор активен" : "# Индикатор отключен";
                    LabelIndicator.CssClass = (CheckBoxUpdateIndicator.Checked) ? "label label-success" : "label label-warning";
                    LabelIndicator.Visible = true;

                    //передаем фокус на отредактированный элемент списка если он существует
                    TextBoxUpdateIndicator.Text = "";
                    CheckBoxUpdateIndicator.Checked = true;
                    ListBoxIndicator.ClearSelection();
                    ListBoxIndicator.SelectedIndex = _item;
                }
            }
        }

        protected void ButtonDeleteIndicator_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxIndicator.SelectedValue, out int _id)
                && int.TryParse(ListBoxCompetence.SelectedValue, out int _idc))
            {
                //инициируем хранимую процедуру удаления элемента
                _context.DeleteIndicatorById(_id);

                //восстанавливаем связь контрола с источником данных
                ListBoxIndicator.DataBind();
                int _count = ListBoxIndicator.Items.Count;

                //передаем фокус на первый элемент списка если он существует
                ListBoxIndicator.ClearSelection();
                if (_count > 0)
                {
                    ListBoxIndicator.SelectedIndex = _count - 1;
                }
                else
                {
                    //если список пуст - все значения гасим

                    LinkButtonDeleteIndicator.Enabled = false;
                    LinkButtonUpdateIndicator.Enabled = false;
                    LabelIndicator.Visible = false;
                    ListBoxIndicator.ToolTip = "список Индикаторов пуст";
                }
            }
        }
        #endregion

        #region методы контекста Комментария
        protected void ListBoxComment_SelectedIndexChanged(object sender, EventArgs e)
        {
            //получаем контекст Комментария по его id в базе данных
            if (int.TryParse(ListBoxComment.SelectedValue, out int _id))
            {
                var _comment = _context.GetCommentById(_id).ToList();

                if (_comment.Any())
                {
                    //заполняем всплывающий тег контрола
                    ListBoxComment.ToolTip = _comment.First().Title;

                    LinkButtonUpdateComment.Enabled = true;
                    LinkButtonDeleteComment.Enabled = true;

                    //заполняем значение текстового контрола Изменить
                    TextBoxUpdateComment.Text = ListBoxComment.SelectedItem.Text;
                }
            }
            else
            {
                ListBoxComment.ToolTip = "список пуст";
            }
        }

        protected void ButtonCreateComment_Click(object sender, EventArgs e)
        {
            //если запись не пустая, есть привязка к Person и такой же записи не существует в этой привязке
            if ((TextBoxCreateComment.Text != "")
                && (int.TryParse(ListBoxPerson.SelectedValue, out int _idp))
                && (!_context.GetCommentByTitleByIdPerson(TextBoxCreateComment.Text, _idp).Any()))
            {
                //инициируем хранимую процедуру создания нового элемента
                _context.PostComment(TextBoxCreateComment.Text, _idp);

                //восстанавливаем связь контрола с источником данных
                ListBoxComment.DataBind();
                string _id = _context.GetCommentByTitleByIdPerson(TextBoxCreateComment.Text, _idp).First().Id.ToString();

                //обнуляем значения контролов Создания значений полей
                TextBoxCreateComment.Text = "";

                // Передаем указатель на созданное поле
                ListBoxComment.ClearSelection();
                try { ListBoxComment.Items.FindByValue(_id).Selected = true; } catch { };
            }
        }

        protected void ButtonUpdateCommentNew_Click(object sender, EventArgs e)
        {
            //редактируем элемент если поле задано и родительский элемент существует 
            if ((TextBoxUpdateComment.Text != "")
                && (int.TryParse(ListBoxComment.SelectedValue, out int _id))
                && (int.TryParse(ListBoxPerson.SelectedValue, out int _idp)))
            {
                // если запись в базе данных отличается от предложенного к изменению варианта
                if (!_context.GetCommentByTitleByIdPerson(TextBoxUpdateComment.Text, _idp).Any())
                {
                    //фиксируем текущие значения контрола и разрываем связь с источником данных
                    int _item = Int32.Parse(ListBoxComment.SelectedIndex.ToString());

                    //инициируем хранимую процедуру изменения элемента
                    _context.PutCommentById(_id, TextBoxUpdateComment.Text);

                    //восстанавливаем связь контрола с базой данных
                    ListBoxComment.DataBind();

                    //передаем фокус на отредактированный элемент списка если он существует
                    TextBoxUpdateComment.Text = "";
                    ListBoxComment.ClearSelection();
                    ListBoxComment.SelectedIndex = _item;
                }
            }
        }

        protected void ButtonDeleteComment_Click(object sender, EventArgs e)
        {
            //удаляем элемент если он существует 
            if (int.TryParse(ListBoxComment.SelectedValue, out int _id)
                && int.TryParse(ListBoxPerson.SelectedValue, out int _idp))
            {
                //инициируем хранимую процедуру удаления элемента
                _context.DeleteCommentById(_id);

                //восстанавливаем связь контрола с базой данных
                ListBoxComment.DataBind();
                int _count = ListBoxComment.Items.Count;

                //передаем фокус на первый элемент списка если он существует
                ListBoxComment.ClearSelection();
                if (_count > 0)
                {
                    ListBoxComment.SelectedIndex = _count - 1;
                }
                else
                {
                    //если список пуст - все значения гасим

                    LinkButtonUpdateComment.Enabled = false;
                    LinkButtonDeleteComment.Enabled = false;

                    ListBoxComment.ToolTip = "список Коментариев пуст";
                }
            }
        }
        #endregion
    }
}