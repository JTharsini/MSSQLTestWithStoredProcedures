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
) ON [PRIMARY]

CREATE TABLE [dbo].[sptestexternal](
	[key] [bigint] IDENTITY(1,1) NOT NULL,
	[type] [int] NOT NULL,
	[va] [varchar](50) NOT NULL,
	[owner] [bigint] NOT NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[sptesthierachical](
	[key] [bigint] IDENTITY(1,1) NOT NULL,
	[node] [varchar](50) NOT NULL,
	[parent] [varchar](50) NULL,
	[child] [varchar](50) NULL
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [dbo].[sptest] ON 
GO
INSERT [dbo].[sptest] ([primaryKey], [id], [type], [value], [latest], [created]) VALUES (2, 1, 1, N'1', 1, NULL)
GO
INSERT [dbo].[sptest] ([primaryKey], [id], [type], [value], [latest], [created]) VALUES (3, 2, 1, N'2', 0, NULL)
GO
INSERT [dbo].[sptest] ([primaryKey], [id], [type], [value], [latest], [created]) VALUES (4, 2, 1, N'3', 1, NULL)
GO
INSERT [dbo].[sptest] ([primaryKey], [id], [type], [value], [latest], [created]) VALUES (5, 3, 2, N'6', 1, NULL)
GO
SET IDENTITY_INSERT [dbo].[sptest] OFF
GO
SET IDENTITY_INSERT [dbo].[sptestexternal] ON 
GO
INSERT [dbo].[sptestexternal] ([key], [type], [va], [owner]) VALUES (3, 10, N'33', 2)
GO
INSERT [dbo].[sptestexternal] ([key], [type], [va], [owner]) VALUES (4, 11, N'55', 3)
GO
INSERT [dbo].[sptestexternal] ([key], [type], [va], [owner]) VALUES (5, 14, N'66', 4)
GO
INSERT [dbo].[sptestexternal] ([key], [type], [va], [owner]) VALUES (6, 12, N'77', 5)
GO
SET IDENTITY_INSERT [dbo].[sptestexternal] OFF
GO
SET IDENTITY_INSERT [dbo].[sptesthierachical] ON 
GO
INSERT [dbo].[sptesthierachical] ([key], [node], [parent], [child]) VALUES (1, N'2', NULL, NULL)
GO
INSERT [dbo].[sptesthierachical] ([key], [node], [parent], [child]) VALUES (2, N'3', N'2', NULL)
GO
INSERT [dbo].[sptesthierachical] ([key], [node], [parent], [child]) VALUES (3, N'4', N'2', NULL)
GO
INSERT [dbo].[sptesthierachical] ([key], [node], [parent], [child]) VALUES (4, N'5', N'4', NULL)
GO
SET IDENTITY_INSERT [dbo].[sptesthierachical] OFF
GO

