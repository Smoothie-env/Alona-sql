IF DB_ID('MSSQLTrip') IS NULL
BEGIN
    CREATE DATABASE MSSQLTrip;
END
GO

USE MSSQLTrip;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'trip')
BEGIN
    EXEC('CREATE SCHEMA trip');
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'trip.Destination') AND type = N'U')
BEGIN
    CREATE TABLE trip.Destination (
        DestinationId INT PRIMARY KEY IDENTITY(1,1),
        Name NVARCHAR(255) NOT NULL,
        Country NVARCHAR(255) NOT NULL,
        Website NVARCHAR(255) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'trip.TripPlan') AND type = N'U')
BEGIN
    CREATE TABLE trip.TripPlan (
        TripId INT PRIMARY KEY IDENTITY(1,1),
        Name NVARCHAR(255) NOT NULL,
        TotalPrice INT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'trip.TripDestination') AND type = N'U')
BEGIN
    CREATE TABLE trip.TripDestination (
        TripId INT NOT NULL,
        DestinationId INT NOT NULL,
        Price INT NOT NULL,
        OrderId INT NOT NULL,
        IsReversed BIT NOT NULL DEFAULT 0,
        PRIMARY KEY (TripId, DestinationId),
        FOREIGN KEY (TripId) REFERENCES trip.TripPlan(TripId),
        FOREIGN KEY (DestinationId) REFERENCES trip.Destination(DestinationId),
        UNIQUE (TripId, OrderId, IsReversed)
    );
END
GO