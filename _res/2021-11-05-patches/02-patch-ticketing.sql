-- ## 2021-11-05

delete from route;
delete from terminal; 

INSERT INTO [dbo].[terminal] ([objid], [state], [name], [address]) VALUES ('038CAG', 'ACTIVE', 'CAGBAN JETTY PORT TERMINAL', 'CAGBAN JETTY PORT TERMINAL, AKLAN');
INSERT INTO [dbo].[terminal] ([objid], [state], [name], [address]) VALUES ('038CAT', 'ACTIVE', 'CATICLAN JETTY PORT TERMINAL', 'CATICLAN JETTY PORT TERMINAL, AKLAN');

INSERT INTO [dbo].[route] ([objid], [state], [name], [sortorder], [originid], [destinationid]) VALUES ('ROUTE290d16d3:17ba01919c0:-7ef0', 'ACTIVE', 'CATICLAN - CAGBAN', '0', '038CAT', '038CAG');
INSERT INTO [dbo].[route] ([objid], [state], [name], [sortorder], [originid], [destinationid]) VALUES ('ROUTE5e26f8cc:17ba02c32c0:-7f77', 'ACTIVE', 'CAGBAN - CATICLAN', '1', '038CAG', '038CAT');
