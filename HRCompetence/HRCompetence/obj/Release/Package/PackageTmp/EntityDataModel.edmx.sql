
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 07/15/2017 13:55:03
-- Generated from EDMX file: D:\Repositorium\HRCompetence\EntityDataModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [HRCompetence];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_PersonCompetence]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CompetenceSet] DROP CONSTRAINT [FK_PersonCompetence];
GO
IF OBJECT_ID(N'[dbo].[FK_PersonComment]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CommentSet] DROP CONSTRAINT [FK_PersonComment];
GO
IF OBJECT_ID(N'[dbo].[FK_CompetenceIndicator]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[IndicatorSet] DROP CONSTRAINT [FK_CompetenceIndicator];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[PersonSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[PersonSet];
GO
IF OBJECT_ID(N'[dbo].[CompetenceSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CompetenceSet];
GO
IF OBJECT_ID(N'[dbo].[CommentSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CommentSet];
GO
IF OBJECT_ID(N'[dbo].[IndicatorSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[IndicatorSet];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'PersonSet'
CREATE TABLE [dbo].[PersonSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(max)  NOT NULL,
    [IfActive] bit  NOT NULL
);
GO

-- Creating table 'CompetenceSet'
CREATE TABLE [dbo].[CompetenceSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(max)  NOT NULL,
    [IfActive] bit  NOT NULL,
    [PersonId] int  NULL
);
GO

-- Creating table 'CommentSet'
CREATE TABLE [dbo].[CommentSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(max)  NOT NULL,
    [PersonId] int  NOT NULL
);
GO

-- Creating table 'IndicatorSet'
CREATE TABLE [dbo].[IndicatorSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(max)  NOT NULL,
    [IfActive] bit  NOT NULL,
    [CompetenceId] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'PersonSet'
ALTER TABLE [dbo].[PersonSet]
ADD CONSTRAINT [PK_PersonSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CompetenceSet'
ALTER TABLE [dbo].[CompetenceSet]
ADD CONSTRAINT [PK_CompetenceSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CommentSet'
ALTER TABLE [dbo].[CommentSet]
ADD CONSTRAINT [PK_CommentSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'IndicatorSet'
ALTER TABLE [dbo].[IndicatorSet]
ADD CONSTRAINT [PK_IndicatorSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [PersonId] in table 'CompetenceSet'
ALTER TABLE [dbo].[CompetenceSet]
ADD CONSTRAINT [FK_PersonCompetence]
    FOREIGN KEY ([PersonId])
    REFERENCES [dbo].[PersonSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_PersonCompetence'
CREATE INDEX [IX_FK_PersonCompetence]
ON [dbo].[CompetenceSet]
    ([PersonId]);
GO

-- Creating foreign key on [PersonId] in table 'CommentSet'
ALTER TABLE [dbo].[CommentSet]
ADD CONSTRAINT [FK_PersonComment]
    FOREIGN KEY ([PersonId])
    REFERENCES [dbo].[PersonSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_PersonComment'
CREATE INDEX [IX_FK_PersonComment]
ON [dbo].[CommentSet]
    ([PersonId]);
GO

-- Creating foreign key on [CompetenceId] in table 'IndicatorSet'
ALTER TABLE [dbo].[IndicatorSet]
ADD CONSTRAINT [FK_CompetenceIndicator]
    FOREIGN KEY ([CompetenceId])
    REFERENCES [dbo].[CompetenceSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CompetenceIndicator'
CREATE INDEX [IX_FK_CompetenceIndicator]
ON [dbo].[IndicatorSet]
    ([CompetenceId]);
GO

-- Creating DATA for PersonSet
SET IDENTITY_INSERT [dbo].[PersonSet] ON
INSERT INTO [dbo].[PersonSet] (Id, Title, IfActive) VALUES (1, N'�������', 'TRUE'), (2, N'��������', 'TRUE'),(3, N'�������', 'TRUE'),(4, N'�����', 'TRUE'),(5, N'���������', 'FALSE');
SET IDENTITY_INSERT [dbo].[PersonSet] OFF
GO

-- Creating DATA for CommentSet
SET IDENTITY_INSERT [dbo].[CommentSet] ON
INSERT INTO [dbo].[CommentSet] (Id, Title, PersonId) VALUES (1, N'�������', 2), (2, N'������� ����', 2),(3, N'������� ������', 3),(4, N'���������', 4),(5, N'���������', 5), (6, N'���������', 3),(7, N'������������', 5),(8, N'������������', 3),(9, N'����������', 4);
SET IDENTITY_INSERT [dbo].[CommentSet] OFF
GO

-- Creating DATA for CompetenceSet
SET IDENTITY_INSERT [dbo].[CompetenceSet] ON
INSERT INTO [dbo].[CompetenceSet] (Id, Title, IfActive, PersonId) VALUES (1, N'�������� ���������', 'TRUE', 2), (2, N'����� ������', 'TRUE', 2),(3, N'������ ������� ������', 'TRUE', 3),(4, N'������ ������� ������ ����������', 'FALSE', 3),(5, N'��������� �������� ������� (�� 1000�)', 'FALSE', 4), (6, N'��������� ������������� ������� (����� 1000�)', 'FALSE', 4),(7, N'����� ������� �������', 'TRUE', 4),(8, N'�������� �������', 'TRUE', 5),(9, N'������� �����', 'FALSE', 5);
SET IDENTITY_INSERT [dbo].[CompetenceSet] OFF
GO

-- Creating DATA for IndicatorSet
SET IDENTITY_INSERT [dbo].[IndicatorSet] ON
INSERT INTO [dbo].[IndicatorSet] (Id, Title, IfActive, CompetenceId) VALUES (1, N'��������� ���������', 'TRUE', 1), (2, N'���������� ���������', 'TRUE', 1),(3, N'����� ���� � ���������', 'TRUE', 2),(4, N'��������� ���� �� ���������� � ��������', 'FALSE', 2),(5, N'���������� ������� ���������� �� �������', 'FALSE', 2), (6, N'��������� ������ ��� �������', 'FALSE', 7),(7, N'������� �������', 'TRUE', 7),(8, N'�������', 'TRUE', 7),(9, N'������� ������ �� �����', 'FALSE', 7);
SET IDENTITY_INSERT [dbo].[IndicatorSet] OFF
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------