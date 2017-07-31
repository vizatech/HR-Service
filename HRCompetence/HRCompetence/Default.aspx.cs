using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Forms;

namespace HRCompetence
{
    public partial class _Default : Page
    {
        private EntityDataModelContainer _context = new EntityDataModelContainer();

        protected void Page_Load(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UserState"];

            if (httpCookie == null)
            {
            }
            else
            {
                divCollapseCompetence.CssClass = httpCookie["divCollapseCompetenceClass"];
                divCollapseComment.CssClass = httpCookie["divCollapseCommentClass"];
            }
        }


        protected void AccordionCompetenceButton_Click(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UserState"];

            if (httpCookie == null)
            {
                httpCookie = new HttpCookie("UserState");
            }

            divCollapseCompetence.CssClass = "panel-collapse collapse in";
            divCollapseComment.CssClass = "panel-collapse collapse";
            httpCookie["divCollapseCompetenceClass"] = divCollapseCompetence.CssClass.ToString();
            httpCookie["divCollapseCommentClass"] = divCollapseComment.CssClass.ToString();

            httpCookie.Expires = DateTime.Now.AddMinutes(20);

            Response.Cookies.Add(httpCookie);
        }

        protected void AccordionCommentButton_Click(object sender, EventArgs e)
        {
            HttpCookie httpCookie = Request.Cookies["UserState"];

            if (httpCookie == null)
            {
                httpCookie = new HttpCookie("UserState");
            }

            divCollapseCompetence.CssClass = "panel-collapse collapse";
            divCollapseComment.CssClass = "panel-collapse collapse in";
            httpCookie["divCollapseCompetenceClass"] = divCollapseCompetence.CssClass.ToString();
            httpCookie["divCollapseCommentClass"] = divCollapseComment.CssClass.ToString();

            httpCookie.Expires = DateTime.Now.AddMinutes(20);

            Response.Cookies.Add(httpCookie);
        }

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
                    LabelCompetence.Visible = false;
                    LabelIndicator.Visible = false;

                    //заполняем всплывающий тег контрола
                    ListBoxPerson.ToolTip = _person.First().Title;
                }
            }
        }

        protected void ButtonCreatePerson_Click(object sender, EventArgs e)
        {
            //если создаваемая запись не пуста и в базе данных нет такой же
            if ((TextBoxCreatePerson.Text != "") 
                && (!_context.GetPersonByTitle(TextBoxCreatePerson.Text).Any()))
            {
                //получаем контекст Учетной записи по ее id в базе данных
                var _source = ListBoxPerson.DataSourceID;
                ListBoxPerson.DataSourceID = "";

                //инициируем хранимую процедуру создания элемента
                _context.PostPerson(TextBoxCreatePerson.Text, CheckBoxCreatePerson.Checked);

                //восстанавливаем связь контрола с источником данных
                ListBoxPerson.DataSourceID = _source;
                int _count = _context.GetAllPersons().Count();

                //передаем фокус на первый элемент списка если он существует
                ListBoxPerson.Focus();
            }
        }

        protected void ButtonUpdatePerson_Click(object sender, EventArgs e)
        {
            //если значение записи не пустое и в базе данных нет такой же
            if ((TextBoxUpdatePerson.Text != "") 
                && (int.TryParse(ListBoxPerson.SelectedValue, out int _id))
                && (!_context.GetPersonByTitle(TextBoxUpdatePerson.Text).Any()))
            {
                //получаем контекст Учетной записи по ее id в базе данных
                var _source = ListBoxPerson.DataSourceID;
                int _item = Int32.Parse(ListBoxPerson.SelectedIndex.ToString());
                ListBoxPerson.DataSourceID = "";

                //инициируем хранимую процедуру изменения элемента
                _context.PutPersonById(_id, TextBoxUpdatePerson.Text, CheckBoxUpdatePerson.Checked);

                //восстанавливаем связь контрола с источником данных
                ListBoxPerson.DataSourceID = _source;

                //передаем фокус на отредактированный элемент списка если он существует
                ListBoxPerson.Focus();
                ListBoxPerson.SelectedIndex = _item;
            }
        }

        protected void ButtonDeletePerson_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxPerson.SelectedValue, out int _id))
            {
                //получаем контекст Учетной записи по ее id в базе данных
                var _source = ListBoxPerson.DataSourceID;
                ListBoxPerson.DataSourceID = "";

                //инициируем хранимую процедуру удаления элемента
                _context.DeletePersonById(_id);

                //восстанавливаем связь контрола с источником данных
                ListBoxPerson.DataSourceID = _source;
                int _count = _context.GetAllPersons().Count();

                //передаем фокус на первый элемент списка если он существует
                ListBoxPerson.Focus();
                if (_count > 0)
                {
                    ListBoxPerson.SelectedIndex = _count - 1;
                }
                else
                {
                    //если список пуст - все значения гасим
                    ListBoxPerson.ToolTip = "список Учетных записей пуст";
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
                    LabelIndicator.Visible = false;

                    //заполняем всплывающий тег контрола
                    ListBoxCompetence.ToolTip = _competence.First().Title;
                }
            }
            else
            {
                ListBoxCompetence.ToolTip = "список пуст";
            }
        }

        protected void ButtonCreateCompetence_Click(object sender, EventArgs e)
        {
            //если запись не пустая, есть привязка к Person и такой же записи не существует в этой привязке
            if ((TextBoxCreateCompetence.Text != "") 
                && (int.TryParse(ListBoxPerson.SelectedValue, out int _idp))
                && (!_context.GetCompetenceByTitleByIdPerson(TextBoxCreateCompetence.Text, _idp).Any()))
            {
                //фиксируем текущие значения контрола и разрываем связь с источником данных
                var _source = ListBoxCompetence.DataSourceID;

                //инициируем хранимую процедуру создания элемента
                _context.PostCompetence(TextBoxCreateCompetence.Text, CheckBoxCreateCompetence.Checked, _idp);

                //восстанавливаем связь контрола с источником данных
                ListBoxCompetence.DataSourceID = _source;
                int _count = _context.GetCompetenceByIdPerson(_idp).Count();

                //передаем фокус на первый элемент списка если он существует
                ListBoxCompetence.Focus();
            }
        }

        protected void ButtonUpdateCompetence_Click(object sender, EventArgs e)
        {
            if ((TextBoxUpdateCompetence.Text != "") 
                && (int.TryParse(ListBoxCompetence.SelectedValue, out int _id))
                && (int.TryParse(ListBoxPerson.SelectedValue, out int _idp))
                && (!_context.GetCompetenceByTitleByIdPerson(TextBoxUpdateCompetence.Text, _idp).Any()))
            {
                //фиксируем текущие значения контрола и разрываем связь с источником данных
                var _source = ListBoxCompetence.DataSourceID;
                int _item = Int32.Parse(ListBoxCompetence.SelectedIndex.ToString());

                //инициируем хранимую процедуру изменения элемента
                _context.PutCompetenceById(_id, TextBoxUpdateCompetence.Text, CheckBoxUpdateCompetence.Checked);

                //восстанавливаем связь контрола с источником данных
                ListBoxCompetence.DataSourceID = _source;

                //передаем фокус на отредактированный элемент списка если он существует
                ListBoxCompetence.Focus();
                ListBoxCompetence.SelectedIndex = _item;
            }
        }

        protected void ButtonDeleteCompetence_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxCompetence.SelectedValue, out int _id) 
                && int.TryParse(ListBoxPerson.SelectedValue, out int _idp))
            {
                //фиксируем текущие значения контрола и разрываем связь с источником данных
                var _source = ListBoxCompetence.DataSourceID;

                //инициируем хранимую процедуру удаления элемента
                _context.DeleteCompetenceById(_id);

                //восстанавливаем связь контрола с источником данных
                ListBoxCompetence.DataSourceID = _source;
                int _count = _context.GetCompetenceByIdPerson(_idp).Count();

                //передаем фокус на первый элемент списка если он существует
                ListBoxCompetence.Focus();
                if (_count > 0)
                {
                    ListBoxCompetence.SelectedIndex = _count - 1;
                }
                else
                {
                    //если список пуст - все значения гасим
                    LabelCompetence.Visible = false;
                    ListBoxCompetence.ToolTip = "список Компетенций пуст";
                }
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

                    //заполняем всплывающий тег контрола
                    ListBoxIndicator.ToolTip = _indicator.First().Title;
                }
            }
            else
            {
                ListBoxIndicator.ToolTip = "список пуст";
            }
        }

        protected void ButtonCreateIndicator_Click(object sender, EventArgs e)
        {
            //если запись не пустая, есть привязка к Competence, и такой же записи не существует в этой привязке
            if ((TextBoxCreateIndicator.Text != "") 
                && (int.TryParse(ListBoxCompetence.SelectedValue, out int _idc))
                && (!_context.GetIndicatorByTitleByIdCompetence(TextBoxCreateIndicator.Text, _idc).Any()))
            {
                //фиксируем текущие значения контрола и разрываем связь с источником данных
                var _source = ListBoxIndicator.DataSourceID;

                //инициируем хранимую процедуру создания элемента
                _context.PostIndicator(TextBoxCreateIndicator.Text, CheckBoxCreateIndicator.Checked, _idc);

                //восстанавливаем связь контрола с источником данных
                ListBoxIndicator.DataSourceID = _source;

                int _count = _context.GetIndicatorByIdCompetence(_idc).Count();
                ListBoxIndicator.Focus();
            }
        }

        protected void ButtonUpdateIndicator_Click(object sender, EventArgs e)
        {
            //если запись не пустая, есть привязка к Competence, и такой же записи не существует в этой привязке
            if ((TextBoxUpdateIndicator.Text != "") 
                && (int.TryParse(ListBoxIndicator.SelectedValue, out int _id))
                && (int.TryParse(ListBoxCompetence.SelectedValue, out int _idc))
                && (!_context.GetIndicatorByTitleByIdCompetence(TextBoxUpdateIndicator.Text, _idc).Any()))
            {
                //фиксируем текущие значения контрола и разрываем связь с источником данных
                var _source = ListBoxIndicator.DataSourceID;
                int _item = Int32.Parse(ListBoxIndicator.SelectedIndex.ToString());

                //инициируем хранимую процедуру изменения элемента
                _context.PutIndicatorById(_id, TextBoxUpdateIndicator.Text, CheckBoxUpdateIndicator.Checked);

                //восстанавливаем связь контрола с источником данных
                ListBoxIndicator.DataSourceID = _source;

                //передаем фокус на отредактированный элемент списка если он существует
                ListBoxIndicator.Focus();
                ListBoxIndicator.SelectedIndex = _item;
            }
        }

        protected void ButtonDeleteIndicator_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxIndicator.SelectedValue, out int _id) 
                && int.TryParse(ListBoxCompetence.SelectedValue, out int _idc))
            {
                //фиксируем текущие значения контрола и разрываем связь с источником данных
                var _source = ListBoxIndicator.DataSourceID;

                //инициируем хранимую процедуру удаления элемента
                _context.DeleteIndicatorById(_id);

                //восстанавливаем связь контрола с источником данных
                ListBoxIndicator.DataSourceID = _source;
                int _count = _context.GetIndicatorByIdCompetence(_idc).Count();

                //передаем фокус на первый элемент списка если он существует
                ListBoxIndicator.Focus();
                if (_count > 0)
                {
                    ListBoxIndicator.SelectedIndex = _count - 1;
                }
                else
                {
                    //если список пуст - все значения гасим
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
                    ListBoxComment.ToolTip = _comment.First().Title;
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
                //фиксируем текущие значения контрола и разрываем связь с источником данных
                var _source = ListBoxComment.DataSourceID;

                //инициируем хранимую процедуру создания нового элемента
                _context.PostComment(TextBoxCreateComment.Text, _idp);

                //восстанавливаем связь контрола с источником данных
                ListBoxComment.DataSourceID = _source;
                int _count = _context.GetCommentByIdPerson(_idp).Count();

                //передаем фокус на первый элемент списка если он существует
                if (_count > 0)
                {
                    ListBoxComment.Focus();
                    ListBoxComment.SelectedIndex = _count - 1;
                }
                else
                {
                    //если список пуст - все значения гасим
                    ListBoxComment.ToolTip = "список Коментариев пуст";
                }
            }
        }

        protected void ButtonUpdateCommentNew_Click(object sender, EventArgs e)
        {
            //редактируем элемент если поле задано и родительский элемент существует 
            if ((TextBoxUpdateCommentNew.Text != "") 
                && (int.TryParse(ListBoxComment.SelectedValue, out int _id))
                && (int.TryParse(ListBoxPerson.SelectedValue, out int _idp))
                && (!_context.GetCommentByTitleByIdPerson(TextBoxUpdateCommentNew.Text, _idp).Any()))
            {
                //фиксируем текущие значения контрола и разрываем связь с источником данных
                var _source = ListBoxComment.DataSourceID;
                int _item = Int32.Parse(ListBoxComment.SelectedIndex.ToString());

                //инициируем хранимую процедуру изменения элемента
                _context.PutCommentById(_id, TextBoxUpdateCommentNew.Text);

                //восстанавливаем связь контрола с базой данных
                ListBoxComment.DataSourceID = _source;

                //передаем фокус на отредактированный элемент списка если он существует
                ListBoxComment.Focus();
                ListBoxComment.SelectedIndex = _item;
            }
        }

        protected void ButtonDeleteComment_Click(object sender, EventArgs e)
        {
            //удаляем элемент если он существует 
            if (int.TryParse(ListBoxComment.SelectedValue, out int _id) 
                && int.TryParse(ListBoxPerson.SelectedValue, out int _idp))
            {
                //фиксируем текущие значения контрола и разрываем связь с источником данных
                var _source = ListBoxComment.DataSourceID;

                //инициируем хранимую процедуру удаления элемента
                _context.DeleteCommentById(_id);

                //восстанавливаем связь контрола с базой данных
                ListBoxComment.DataSourceID = _source;
                int _count = _context.GetCommentByIdPerson(_idp).Count();

                //передаем фокус на первый элемент списка если он существует
                ListBoxComment.Focus();
                if (_count > 0)
                {
                    ListBoxComment.SelectedIndex = _count - 1;
                }
                else
                {
                    //если список пуст - все значения гасим
                    ListBoxComment.ToolTip = "список Коментариев пуст";
                }
            }
        }
        #endregion

        protected void TextBoxFindPerson_TextChanged(object sender, EventArgs e)
        {
            FindPersonLabel.Text = "onenter"; //_context.GetPersonByTitle(TextBoxFindPerson.Text).Count().ToString() + " записей найдено";
        }

        protected void ButtonFindPerson_Click(object sender, EventArgs e)
        {

        }

        protected void TextBoxFindCompetence_TextChanged(object sender, EventArgs e)
        {

        }

        protected void ButtonFindCompetence_Click(object sender, EventArgs e)
        {

        }
    }
}