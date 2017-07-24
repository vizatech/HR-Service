using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HRCompetence
{
    public partial class _Default : Page
    {
        private EntityDataModelContainer _context = new EntityDataModelContainer();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ListBoxPerson_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxPerson.SelectedValue, out int _id))
            {
                var _person = _context.GetPersonById(_id).ToList();
                LabelPerson.Text = (_person.First().IfActive) ? "# Учетная запись активна" : "# Учетная запись отключена";
                LabelPerson.CssClass = (_person.First().IfActive) ? "label label-success" : "label label-warning";
                TextBoxUpdatePerson.Text = _person.First().Title;
                CheckBoxUpdatePerson.Checked = _person.First().IfActive;
                LabelPerson.Visible = true;
            }
            LabelCompetence.Visible = false;
            LabelIndicator.Visible = false;
        }

        protected void ButtonCreatePerson_Click(object sender, EventArgs e)
        {
            if (TextBoxCreatePerson.Text != "") 
            {
                var _source = ListBoxPerson.DataSourceID;
                ListBoxPerson.DataSourceID = "";
                _context.PostPerson(TextBoxCreatePerson.Text, CheckBoxCreatePerson.Checked);
                ListBoxPerson.DataSourceID = _source;
            }
        }
        protected void ButtonUpdatePerson_Click(object sender, EventArgs e)
        {
            if ((TextBoxUpdatePerson.Text != "") && (int.TryParse(ListBoxPerson.SelectedValue, out int _id)))
            {
                var _source = ListBoxPerson.DataSourceID;
                ListBoxPerson.DataSourceID = "";
                _context.PutPersonById(_id, TextBoxUpdatePerson.Text, CheckBoxUpdatePerson.Checked);
                ListBoxPerson.DataSourceID = _source;
            }
        }

        protected void ButtonDeletePerson_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxPerson.SelectedValue, out int _id))
            {
                var _source = ListBoxPerson.DataSourceID;
                ListBoxPerson.DataSourceID = "";
                _context.DeletePersonById(_id);
                ListBoxPerson.DataSourceID = _source;
            }
        }


        protected void ListBoxCompetence_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxCompetence.SelectedValue, out int _id))
            {
                var _competence = _context.GetCompetenceById(_id).ToList();
                LabelCompetence.Text = (_competence.First().IfActive) ? "# Компетенция активна" : "# Компетенция отключена";
                LabelCompetence.CssClass = (_competence.First().IfActive) ? "label label-success" : "label label-warning";
                TextBoxUpdateCompetence.Text = _competence.First().Title;
                CheckBoxUpdateCompetence.Checked = _competence.First().IfActive;
                LabelCompetence.Visible = true;
            }
            LabelCompetence.Visible = false;
        }

        protected void ButtonCreateCompetence_Click(object sender, EventArgs e)
        {
            if ((TextBoxCreateCompetence.Text != "") && (int.TryParse(ListBoxPerson.SelectedValue, out int _id)))
            {
                var _source = ListBoxCompetence.DataSourceID;
                ListBoxCompetence.DataSourceID = "";
                _context.PostCompetence(TextBoxCreateCompetence.Text, CheckBoxCreateCompetence.Checked, _id);
                ListBoxCompetence.DataSourceID = _source;
            }
        }
        protected void ButtonUpdateCompetence_Click(object sender, EventArgs e)
        {
            if ((TextBoxUpdateCompetence.Text != "") && (int.TryParse(ListBoxCompetence.SelectedValue, out int _id)))
            {
                var _source = ListBoxCompetence.DataSourceID;
                ListBoxCompetence.DataSourceID = "";
                _context.PutCompetenceById(_id, TextBoxUpdateCompetence.Text, CheckBoxUpdateCompetence.Checked);
                ListBoxCompetence.DataSourceID = _source;
            }
        }

        protected void ButtonDeleteCompetence_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxCompetence.SelectedValue, out int _id))
            {
                var _source = ListBoxCompetence.DataSourceID;
                ListBoxCompetence.DataSourceID = "";
                _context.DeleteCompetenceById(_id);
                ListBoxCompetence.DataSourceID = _source;
            }
        }


        protected void ListBoxIndicator_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxIndicator.SelectedValue, out int _id))
            {
                var _indicator = _context.GetIndicatorById(_id).ToList();
                LabelIndicator.Text = (_indicator.First().IfActive) ? "# Индикатор активен" : "# Индикатор отключён";
                LabelIndicator.CssClass = (_indicator.First().IfActive) ? "label label-success" : "label label-warning";
                TextBoxUpdateIndicator.Text = _indicator.First().Title;
                CheckBoxUpdateIndicator.Checked = _indicator.First().IfActive;
                LabelIndicator.Visible = true;
            }
        }

        protected void ButtonCreateIndicator_Click(object sender, EventArgs e)
        {
            if ((TextBoxCreateIndicator.Text != "") && (int.TryParse(ListBoxCompetence.SelectedValue, out int _id)))
            {
                var _source = ListBoxIndicator.DataSourceID;
                ListBoxIndicator.DataSourceID = "";
                _context.PostIndicator(TextBoxCreateIndicator.Text, CheckBoxCreateIndicator.Checked, _id);
                ListBoxIndicator.DataSourceID = _source;
            }
        }
        protected void ButtonUpdateIndicator_Click(object sender, EventArgs e)
        {
            if ((TextBoxUpdateIndicator.Text != "") && (int.TryParse(ListBoxIndicator.SelectedValue, out int _id)))
            {
                var _source = ListBoxIndicator.DataSourceID;
                ListBoxIndicator.DataSourceID = "";
                _context.PutIndicatorById(_id, TextBoxUpdateIndicator.Text, CheckBoxUpdateIndicator.Checked);
                ListBoxIndicator.DataSourceID = _source;
            }
        }

        protected void ButtonDeleteIndicator_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxIndicator.SelectedValue, out int _id))
            {
                var _source = ListBoxIndicator.DataSourceID;
                ListBoxIndicator.DataSourceID = "";
                _context.DeleteIndicatorById(_id);
                ListBoxIndicator.DataSourceID = _source;
            }
        }


        protected void ListBoxComment_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxComment.SelectedValue, out int _id))
            {
                var _comment = _context.GetCommentById(_id).ToList();
                TextBoxUpdateComment.Text = _comment.First().Title;
                LabelComment.Visible = true;
            }
        }

        protected void ButtonCreateComment_Click(object sender, EventArgs e)
        {
            if ((TextBoxCreateComment.Text != "") && (int.TryParse(ListBoxPerson.SelectedValue, out int _id)))
            {
                var _source = ListBoxComment.DataSourceID;
                ListBoxComment.DataSourceID = "";
                _context.PostComment(TextBoxCreateComment.Text, _id);
                ListBoxComment.DataSourceID = _source;
            }
        }
        protected void ButtonUpdateComment_Click(object sender, EventArgs e)
        {
            if ((TextBoxUpdateComment.Text != "") && (int.TryParse(ListBoxComment.SelectedValue, out int _id)))
            {
                var _source = ListBoxComment.DataSourceID;
                ListBoxComment.DataSourceID = "";
                _context.PutCommentById(_id, TextBoxUpdateComment.Text);
                ListBoxComment.DataSourceID = _source;
            }
        }

        protected void ButtonDeleteComment_Click(object sender, EventArgs e)
        {
            if (int.TryParse(ListBoxComment.SelectedValue, out int _id))
            {
                var _source = ListBoxComment.DataSourceID;
                ListBoxComment.DataSourceID = "";
                _context.DeleteCommentById(_id);
                ListBoxComment.DataSourceID = _source;
            }
        }

    }
}