USE [Test]
GO

/****** Object:  Table [dbo].[sptest]    Script Date: 7/16/2021 8:40:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[sptest](
	[primaryKey] [bigint] IDENTITY(1,1) NOT NULL,
	[id] [bigint] NOT NULL,
	[type] [int] NOT NULL,
	[value] [varchar](50) NULL,
	[latest] [smallint] NOT NULL,
	[created] [datetime] NULL
) ON [MAIN]

CREATE TABLE [dbo].[sptestexternal](
	[key] [bigint] IDENTITY(1,1) NOT NULL,
	[type] [int] NOT NULL,
	[va] [varchar](50) NOT NULL,
	[owner] [bigint] NOT NULL
) ON [MAIN]

CREATE TABLE [dbo].[sptesthierachical](
	[key] [bigint] IDENTITY(1,1) NOT NULL,
	[node] [varchar](50) NOT NULL,
	[parent] [varchar](50) NULL,
	[child] [varchar](50) NULL
) ON [MAIN]
GO


